--\Description: stravant's lua parser from Minify

local module = {}

local statListCloseKeywords = {
	['end'] = true,
	['else'] = true,
	['elseif'] = true,
	['until'] = true
}
local unops = {['-'] = true, ['not'] = true, ['#'] = true}
local unopprio = 8
local priority = {
	['+'] = {6,6};
	['-'] = {6,6};
	['%'] = {7,7};
	['/'] = {7,7};
	['*'] = {7,7};
	['^'] = {10,9};
	['..'] = {5,4};
	['=='] = {3,3};
	['<'] = {3,3};
	['<='] = {3,3};
	['~='] = {3,3};
	['>'] = {3,3};
	['>='] = {3,3};		
	['and'] = {2,2};
	['or'] = {1,1};
}

-- getters
local function Peek(n)
    n = module.Package.Utils.Tests.GetArguments(
        {'number', n, 0}
    )
	return module.tokens[math.min(#module.tokens, module.p + n)]
end

local function Get()
	local t = module.tokens[module.p]
	module.p = math.min(module.p + 1, #module.tokens)
	return t
end

local function Is(t)
	return Peek().Type == t
end

--save / restore points in the stream
local function Save()
	module.savedP[#module.savedP + 1] = module.p
end

local function Commit()
	module.savedP[#module.savedP] = nil
end

local function Restore()
	module.p = module.savedP[#module.savedP]
	module.savedP[#module.savedP] = nil
end

local function ConsumeSymbol(symb)
	local t = Peek()
	if t.Type == 'Symbol' then
		if symb then
			if t.Data == symb then
				Get()
				return true
			else
				return nil
			end
		else
			Get()
			return t
		end
	else
		return nil
	end
end

local function ConsumeKeyword(kw)
	local t = Peek()
	if t.Type == 'Keyword' and t.Data == kw then
		Get()
		return true
	else
		return nil
	end
end

local function IsKeyword(kw)
	local t = Peek()
	return t.Type == 'Keyword' and t.Data == kw
end

local function IsSymbol(s)
	local t = Peek()
	return t.Type == 'Symbol' and t.Data == s
end

local function IsEof()
	return Peek().Type == 'Eof'
end

local function GenerateError(msg)
	local err = string.format('>> :%d:%d: %s\n', Peek().Line, Peek().Char, msg)
	--find the line
	local lineNum = 0
	for line in module.src:gmatch('[^\n]*\n?') do
		if line:sub(-1,-1) == '\n' then line = line:sub(1,-2) end
		lineNum = lineNum+1
		if lineNum == Peek().Line then
			err = string.format('%s>> `%s`\n', err, line:gsub('\t','    '))
			for i = 1, Peek().Char do
				local c = line:sub(i,i)
				if c == '\t' then 
					err = err .. '    '
				else
					err = err .. ' '
				end
			end
			err = err .. "   ^---"
			break
		end
	end
	return err
end

local ParsePrimaryExpr, ParseSuffixedExpr, ParseSimpleExpr
local ParseSubExpr, ParseExpr
local ParseStatement, ParseStatementList, ParseFunctionArgsAndBody

function ParseSubExpr(scope, level)
	--base item, possibly with unop prefix
	local st, exp
	if unops[Peek().Data] then
		local op = Get().Data
		st, exp = ParseSubExpr(scope, unopprio)
		if not st then return false, exp end
		local nodeEx = {}
		nodeEx.AstType = 'UnopExpr'
		nodeEx.Rhs = exp
		nodeEx.Op = op
		exp = nodeEx
	else
		st, exp = ParseSimpleExpr(scope)
		if not st then return false, exp end
	end

	--next items in chain
	while true do
		local prio = priority[Peek().Data]
		if prio and prio[1] > level then
			local op = Get().Data
			local st, rhs = ParseSubExpr(scope, prio[2])
			if not st then return false, rhs end
			local nodeEx = {}
			nodeEx.AstType = 'BinopExpr'
			nodeEx.Lhs = exp
			nodeEx.Op = op
			nodeEx.Rhs = rhs
			--
			exp = nodeEx
		else
			break
		end
	end

	return true, exp
end

function ParseExpr(scope)
	return ParseSubExpr(scope, 0)
end

function ParsePrimaryExpr(scope)
	if ConsumeSymbol('(') then
		local st, ex = ParseExpr(scope)
		if not st then return false, ex end
		if not ConsumeSymbol(')') then
			return false, GenerateError('`)` Expected.')
		end
		--save the information about parenthesized expressions somewhere
		ex.ParenCount = (ex.ParenCount or 0) + 1
		return true, ex

	elseif Is('Ident') then
		local id = Get()
		local var = scope:GetLocal(id.Data)
--		if not var then
--			GlobalVarGetMap[id.Data] = true
--		end
		--
		local nodePrimExp = {}
		nodePrimExp.AstType = 'VarExpr'
		nodePrimExp.Name = id.Data
		nodePrimExp.Local = var
		scope:AddVariable(nodePrimExp)
		--
		return true, nodePrimExp
	else
		return false, GenerateError('primary expression expected')
	end
end

function ParseSuffixedExpr(scope, onlyDotColon)
	--base primary expression
	local st, prim = ParsePrimaryExpr(scope)
	if not st then return false, prim end
	--
	while true do
		if IsSymbol('.') or IsSymbol(':') then
			local symb = Get().Data
			if not Is('Ident') then
				return false, GenerateError('<Ident> expected.')
			end
			local id = Get()
			local nodeIndex = {}
			nodeIndex.AstType = 'MemberExpr'
			nodeIndex.Base = prim
			nodeIndex.Indexer = symb
			nodeIndex.Ident = id
			--
			prim = nodeIndex

		elseif not onlyDotColon and ConsumeSymbol('[') then
			local st, ex = ParseExpr(scope)
			if not st then return false, ex end
			if not ConsumeSymbol(']') then
				return false, GenerateError('`]` expected.')
			end
			local nodeIndex = {}
			nodeIndex.AstType = 'IndexExpr'
			nodeIndex.Base = prim
			nodeIndex.Index = ex
			--
			prim = nodeIndex

		elseif not onlyDotColon and ConsumeSymbol('(') then
			local args = {}
			while not ConsumeSymbol(')') do
				local st, ex = ParseExpr(scope)
				if not st then return false, ex end
				args[#args+1] = ex
				if not ConsumeSymbol(',') then
					if ConsumeSymbol(')') then
						break
					else
						return false, GenerateError('`)` Expected.')
					end
				end
			end
			local nodeCall = {}
			nodeCall.AstType = 'CallExpr'
			nodeCall.Base = prim
			nodeCall.Arguments = args
			--
			prim = nodeCall

		elseif not onlyDotColon and Is('String') then
			--string call
			local nodeCall = {}
			nodeCall.AstType = 'StringCallExpr'
			nodeCall.Base = prim
			nodeCall.Arguments  = {Get()}
			--
			prim = nodeCall

		elseif not onlyDotColon and IsSymbol('{') then
			--table call
			local st, ex = ParseExpr(scope)
			if not st then return false, ex end
			local nodeCall = {}
			nodeCall.AstType = 'TableCallExpr'
			nodeCall.Base = prim
			nodeCall.Arguments = {ex}
			--
			prim = nodeCall

		else
			break
		end
	end
	return true, prim
end


function ParseSimpleExpr(scope)
	if Is('Number') then
		local nodeNum = {}
		nodeNum.AstType = 'NumberExpr'
		nodeNum.Value = Get()
		return true, nodeNum

	elseif Is('String') then
		local nodeStr = {}
		nodeStr.AstType = 'StringExpr'
		nodeStr.Value = Get()
		return true, nodeStr

	elseif ConsumeKeyword('nil') then
		local nodeNil = {}
		nodeNil.AstType = 'NilExpr'
		return true, nodeNil

	elseif IsKeyword('false') or IsKeyword('true') then
		local nodeBoolean = {}
		nodeBoolean.AstType = 'BooleanExpr'
		nodeBoolean.Value = (Get().Data == 'true')
		return true, nodeBoolean

	elseif ConsumeSymbol('...') then
		local nodeDots = {}
		nodeDots.AstType = 'DotsExpr'
		return true, nodeDots

	elseif ConsumeSymbol('{') then
		local v = {}
		v.AstType = 'ConstructorExpr'
		v.EntryList = {}
		--
		while true do
			if IsSymbol('[') then
				--key
				Get()
				local st, key = ParseExpr(scope)
				if not st then 
					return false, GenerateError('Key Expression Expected')
				end
				if not ConsumeSymbol(']') then
					return false, GenerateError('`]` Expected')
				end
				if not ConsumeSymbol('=') then
					return false, GenerateError('`=` Expected')
				end
				local st, value = ParseExpr(scope)
				if not st then
					return false, GenerateError('Value Expression Expected')
				end
				v.EntryList[#v.EntryList+1] = {
					Type = 'Key';
					Key = key;
					Value = value;
				}

			elseif Is('Ident') then
				--value or key
				local lookahead = Peek(1)
				if lookahead.Type == 'Symbol' and lookahead.Data == '=' then
					--we are a key
					local key = Get() 
					if not ConsumeSymbol('=') then
						return false, GenerateError('`=` Expected')
					end
					local st, value = ParseExpr(scope)
					if not st then
						return false, GenerateError('Value Expression Expected')
					end
					v.EntryList[#v.EntryList+1] = {
						Type = 'KeyString';
						Key = key.Data;
						Value = value; 
					}

				else
					--we are a value
					local st, value = ParseExpr(scope)
					if not st then
						return false, GenerateError('Value Expected')
					end
					v.EntryList[#v.EntryList+1] = {
						Type = 'Value';
						Value = value;
					}

				end
			elseif ConsumeSymbol('}') then
				break

			else
				--value
				local st, value = ParseExpr(scope)
				v.EntryList[#v.EntryList+1] = {
					Type = 'Value';
					Value = value;
				}
				if not st then
					return false, GenerateError('Value Expected')
				end
			end

			if ConsumeSymbol(';') or ConsumeSymbol(',') then
				--all is good
			elseif ConsumeSymbol('}') then
				break
			else
				return false, GenerateError('`}` or table entry Expected')
			end
		end
		return true, v

	elseif ConsumeKeyword('function') then
		local st, func = ParseFunctionArgsAndBody(scope)
		if not st then return false, func end
		--
		func.IsLocal = true
		return true, func

	else
		return ParseSuffixedExpr(scope)
	end
end

function ParseStatement(scope)
	local stat = nil
	if ConsumeKeyword('if') then
		--setup
		local nodeIfStat = {}
		nodeIfStat.AstType = 'IfStatement'
		nodeIfStat.Clauses = {}

		--clauses
		repeat
			local st, nodeCond = ParseExpr(scope)
			if not st then return false, nodeCond end
			if not ConsumeKeyword('then') then
				return false, GenerateError('`then` expected.')
			end
			local st, nodeBody = ParseStatementList(scope)
			if not st then return false, nodeBody end
			nodeIfStat.Clauses[#nodeIfStat.Clauses+1] = {
				Condition = nodeCond;
				Body = nodeBody;
			}
		until not ConsumeKeyword('elseif')

		--else clause
		if ConsumeKeyword('else') then
			local st, nodeBody = ParseStatementList(scope)
			if not st then return false, nodeBody end
			nodeIfStat.Clauses[#nodeIfStat.Clauses+1] = {
				Body = nodeBody;
			}
		end

		--end
		if not ConsumeKeyword('end') then
			return false, GenerateError('`end` expected.')
		end

		stat = nodeIfStat

	elseif ConsumeKeyword('while') then
		--setup
		local nodeWhileStat = {}
		nodeWhileStat.AstType = 'WhileStatement'

		--condition
		local st, nodeCond = ParseExpr(scope)
		if not st then return false, nodeCond end

		--do
		if not ConsumeKeyword('do') then
			return false, GenerateError('`do` expected.')
		end

		--body
		local st, nodeBody = ParseStatementList(scope)
		if not st then return false, nodeBody end

		--end
		if not ConsumeKeyword('end') then
			return false, GenerateError('`end` expected.')
		end

		--return
		nodeWhileStat.Condition = nodeCond
		nodeWhileStat.Body = nodeBody
		stat = nodeWhileStat

	elseif ConsumeKeyword('do') then
		--do block
		local st, nodeBlock = ParseStatementList(scope)
		if not st then return false, nodeBlock end
		if not ConsumeKeyword('end') then
			return false, GenerateError('`end` expected.')
		end

		local nodeDoStat = {}
		nodeDoStat.AstType = 'DoStatement'
		nodeDoStat.Body = nodeBlock
		stat = nodeDoStat

	elseif ConsumeKeyword('for') then
		--for block
		if not Is('Ident') then
			return false, GenerateError('<ident> expected.')
		end
		local baseVarName = Get()
		if ConsumeSymbol('=') then
			--numeric for
			local forScope = module.Package.StravantParser.Scope:New(scope)
			local forVar = forScope:CreateLocal(baseVarName.Data)
			--
			local st, startEx = ParseExpr(scope)
			if not st then return false, startEx end
			if not ConsumeSymbol(',') then
				return false, GenerateError('`,` Expected')
			end
			local st, endEx = ParseExpr(scope)
			if not st then return false, endEx end
			local st, stepEx;
			if ConsumeSymbol(',') then
				st, stepEx = ParseExpr(scope)
				if not st then return false, stepEx end
			end
			if not ConsumeKeyword('do') then
				return false, GenerateError('`do` expected')
			end
			--
			local st, body = ParseStatementList(forScope)
			if not st then return false, body end
			if not ConsumeKeyword('end') then
				return false, GenerateError('`end` expected')
			end
			--
			local nodeFor = {}
			nodeFor.AstType = 'NumericForStatement'
			nodeFor.Scope = forScope
			nodeFor.Variable = forVar
			nodeFor.Start = startEx
			nodeFor.End = endEx
			nodeFor.Step = stepEx
			nodeFor.Body = body
			stat = nodeFor
		else
			--generic for
			local forScope = module.Package.StravantParser.Scope:New(scope)
			--
			local varList = {forScope:CreateLocal(baseVarName.Data)}
			while ConsumeSymbol(',') do
				if not Is('Ident') then
					return false, GenerateError('for variable expected.')
				end
				varList[#varList+1] = forScope:CreateLocal(Get().Data)
			end
			if not ConsumeKeyword('in') then
				return false, GenerateError('`in` expected.')
			end
			local generators = {}
			local st, firstGenerator = ParseExpr(scope)
			if not st then return false, firstGenerator end
			generators[#generators+1] = firstGenerator
			while ConsumeSymbol(',') do
				local st, gen = ParseExpr(scope)
				if not st then return false, gen end
				generators[#generators+1] = gen
			end
			if not ConsumeKeyword('do') then
				return false, GenerateError('`do` expected.')
			end
			local st, body = ParseStatementList(forScope)
			if not st then return false, body end
			if not ConsumeKeyword('end') then
				return false, GenerateError('`end` expected.')
			end
			--
			local nodeFor = {}
			nodeFor.AstType = 'GenericForStatement'
			nodeFor.Scope = forScope
			nodeFor.VariableList = varList
			nodeFor.Generators = generators
			nodeFor.Body = body
			stat = nodeFor
		end

	elseif ConsumeKeyword('repeat') then
		local st, body = ParseStatementList(scope)
		if not st then return false, body end
		--
		if not ConsumeKeyword('until') then
			return false, GenerateError('`until` expected.')
		end
		--
		local st, cond = ParseExpr(scope)
		if not st then return false, cond end
		--
		local nodeRepeat = {}
		nodeRepeat.AstType = 'RepeatStatement'
		nodeRepeat.Condition = cond
		nodeRepeat.Body = body
		stat = nodeRepeat

	elseif ConsumeKeyword('function') then
		if not Is('Ident') then
			return false, GenerateError('Function name expected')
		end
		local st, name = ParseSuffixedExpr(scope, true) --true => only dots and colons
		if not st then return false, name end
		--
		local st, func = ParseFunctionArgsAndBody(scope)
		if not st then return false, func end
		--
		func.IsLocal = false
		func.Name = name
		stat = func

	elseif ConsumeKeyword('local') then
		if Is('Ident') then
			local varList = {Get().Data}
			while ConsumeSymbol(',') do
				if not Is('Ident') then
					return false, GenerateError('local var name expected')
				end
				varList[#varList+1] = Get().Data
			end

			local initList = {}
			if ConsumeSymbol('=') then
				repeat
					local st, ex = ParseExpr(scope)
					if not st then return false, ex end
					initList[#initList+1] = ex
				until not ConsumeSymbol(',')
			end

			--now patch var list
			--we can't do this before getting the init list, because the init list does not
			--have the locals themselves in scope.
			for i, v in pairs(varList) do
				varList[i] = scope:CreateLocal(v)
			end

			local nodeLocal = {}
			nodeLocal.AstType = 'LocalStatement'
			nodeLocal.LocalList = varList
			nodeLocal.InitList = initList
			--
			stat = nodeLocal

		elseif ConsumeKeyword('function') then
			if not Is('Ident') then
				return false, GenerateError('Function name expected')
			end
			local name = Get().Data		
			local localVar = scope:CreateLocal(name)
			--	
			local st, func = ParseFunctionArgsAndBody(scope)
			if not st then return false, func end
			--
			func.Name = localVar
			func.IsLocal = true
			stat = func

		else
			return false, GenerateError('local var or function def expected')
		end 

	elseif ConsumeSymbol('::') then
		if not Is('Ident') then
			return false, GenerateError('Label name expected')
		end
		local label = Get().Data
		if not ConsumeSymbol('::') then
			return false, GenerateError('`::` expected')
		end
		local nodeLabel = {}
		nodeLabel.AstType = 'LabelStatement'
		nodeLabel.Label = label
		stat = nodeLabel

	elseif ConsumeKeyword('return') then
		local exList = {}
		if not IsKeyword('end') then
			local st, firstEx = ParseExpr(scope)
			if st then 
				exList[1] = firstEx
				while ConsumeSymbol(',') do
					local st, ex = ParseExpr(scope)
					if not st then return false, ex end
					exList[#exList+1] = ex
				end
			end
		end

		local nodeReturn = {}
		nodeReturn.AstType = 'ReturnStatement'
		nodeReturn.Arguments = exList
		stat = nodeReturn

	elseif ConsumeKeyword('break') then
		local nodeBreak = {}
		nodeBreak.AstType = 'BreakStatement'
		stat = nodeBreak

	elseif IsKeyword('goto') then
		if not Is('Ident') then
			return false, GenerateError('Label expected')
		end
		local label = Get().Data
		local nodeGoto = {}
		nodeGoto.AstType = 'GotoStatement'
		nodeGoto.Label = label
		stat = nodeGoto

	else
		--statementParseExpr
		local st, suffixed = ParseSuffixedExpr(scope)
		if not st then return false, suffixed end

		--assignment or call?
		if IsSymbol(',') or IsSymbol('=') then
			--check that it was not parenthesized, making it not an lvalue
			if (suffixed.ParenCount or 0) > 0 then
				return false, GenerateError('Can not assign to parenthesized expression, is not an lvalue')
			end

			--more processing needed
			local lhs = {suffixed}
			while ConsumeSymbol(',') do
				local st, lhsPart = ParseSuffixedExpr(scope)
				if not st then return false, lhsPart end
				lhs[#lhs+1] = lhsPart
			end

			--equals
			if not ConsumeSymbol('=') then
				return false, GenerateError('`=` Expected.')
			end

			--rhs
			local rhs = {}
			local st, firstRhs = ParseExpr(scope)
			if not st then return false, firstRhs end
			rhs[1] = firstRhs
			while ConsumeSymbol(',') do
				local st, rhsPart = ParseExpr(scope)
				if not st then return false, rhsPart end
				rhs[#rhs+1] = rhsPart
			end

			--done
			local nodeAssign = {}
			nodeAssign.AstType = 'AssignmentStatement'
			nodeAssign.Lhs = lhs
			nodeAssign.Rhs = rhs
			stat = nodeAssign

		elseif suffixed.AstType == 'CallExpr' or 
		       suffixed.AstType == 'TableCallExpr' or 
		       suffixed.AstType == 'StringCallExpr' 
		then
			--it's a call statement
			local nodeCall = {}
			nodeCall.AstType = 'CallStatement'
			nodeCall.Expression = suffixed
			stat = nodeCall
		else
			return false, GenerateError('Assignment Statement Expected')
		end
	end

	stat.HasSemicolon = ConsumeSymbol(';')
	return true, stat
end

function ParseStatementList(scope)
	local nodeStatlist = {}
	nodeStatlist.Scope = module.Package.StravantParser.Scope:New(scope)
	nodeStatlist.AstType = 'Statlist'
	--
	local stats = {}
	--
	while not statListCloseKeywords[Peek().Data] and not IsEof() do
		local st, nodeStatement = ParseStatement(nodeStatlist.Scope)
		if not st then return false, nodeStatement end
		stats[#stats+1] = nodeStatement
	end
	--
	nodeStatlist.Body = stats
	return true, nodeStatlist
end

function ParseFunctionArgsAndBody(scope)
	local funcScope = module.Package.StravantParser.Scope:New(scope)
	if not ConsumeSymbol('(') then
		return false, GenerateError('`(` expected.')
	end

	--arg list
	local argList = {}
	local isVarArg = false
	while not ConsumeSymbol(')') do
		if Is('Ident') then
			local arg = funcScope:CreateLocal(Get().Data)
			argList[#argList+1] = arg
			if not ConsumeSymbol(',') then
				if ConsumeSymbol(')') then
					break
				else
					return false, GenerateError('`)` expected.')
				end
			end
		elseif ConsumeSymbol('...') then
			isVarArg = true
			if not ConsumeSymbol(')') then
				return false, GenerateError('`...` must be the last argument of a function.')
			end
			break
		else
			return false, GenerateError('Argument name or `...` expected')
		end
	end

	--body
	local st, body = ParseStatementList(funcScope)
	if not st then return false, body end

	--end
	if not ConsumeKeyword('end') then
		return false, GenerateError('`end` expected after function body')
	end

	local nodeFunc = {}
	nodeFunc.AstType = 'Function'
	nodeFunc.Scope = funcScope
	nodeFunc.Arguments = argList
	nodeFunc.Body = body
	nodeFunc.VarArg = isVarArg
	--
	return true, nodeFunc
end

function module.Parse(src)
    src = module.Package.Utils.Tests.GetArguments(
        {'string', src} -- The source code to parse
    )
	module.src = src
	module.tokens = module.Package.StravantParser.Lexer.GetTokens(src)
	module.p = 1
	module.savedP = {}
	
	local topScope = module.Package.StravantParser.Scope:TopScope()
	
	local success, ast = ParseStatementList(topScope)
	--print("Last Token: "..PrintTable(Peek()))
	return success and ast or nil
end

return module
