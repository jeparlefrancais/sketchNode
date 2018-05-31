--\Description: stravant's lua lexer from Minify

local module = {}

local function lookupify(tb)
	for _, v in pairs(tb) do
		tb[v] = true
	end
	return tb
end

local WhiteChars = lookupify{' ', '\n', '\t', '\r'}
local LowerChars = lookupify{
	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 
	'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
	's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
local UpperChars = lookupify{
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 
	'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
	'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
local Digits = lookupify{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
local HexDigits = lookupify{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
                            'A', 'a', 'B', 'b', 'C', 'c', 'D', 'd', 'E', 'e', 'F', 'f'}

local Symbols = lookupify{'+', '-', '*', '/', '^', '%', ',', '{', '}', '[', ']', '(', ')', ';', '#'}

local Keywords = lookupify{
    'and', 'break', 'do', 'else', 'elseif',
    'end', 'false', 'for', 'function', 'goto', 'if',
    'in', 'local', 'nil', 'not', 'or', 'repeat',
    'return', 'then', 'true', 'until', 'while',
}

local function Get() --\ReturnType: string
	local c = module.src:sub(module.p, module.p)
	if c == '\n' then
		module.char = 1
		module.line = module.line + 1
	else
		module.char = module.char + 1
	end
	module.p = module.p + 1
	return c
end

local function Peek(n) --\ReturnType: string
    n = module.Package.Utils.Tests.GetArguments(
        {'number', n, 0}
    )
	local total = module.p + n
	return module.src:sub(total, total)
end

local function Consume(chars) --\ReturnType: string
    chars = module.Package.Utils.Tests.GetArguments(
        {'string', chars} -- The list of characters that can be consumed
    )
	local c = Peek()
	for i = 1, #chars do
		if c == chars:sub(i, i) then return Get() end
	end
end

local function GenerateError(err)
	return error(string.format(">> :%d:%d: %s", module.line, module.char, err), 0)
end

local function TryGetLongString() --\ReturnType: string
	local start = module.p
	if Peek() == '[' then
		local equalsCount = 0
		while Peek(equalsCount+1) == '=' do
			equalsCount = equalsCount + 1
		end
		if Peek(equalsCount+1) == '[' then
			--start parsing the string. Strip the starting bit
			for _ = 0, equalsCount+1 do Get() end

			--get the contents
			local contentStart = module.p
			while true do
				--check for eof
				if Peek() == '' then
					GenerateError('Expected `]' .. string.rep('=', equalsCount) .. ']` near <eof>.', 3)
				end

				--check for the end
				local foundEnd = true
				if Peek() == ']' then
					for i = 1, equalsCount do
						if Peek(i) ~= '=' then foundEnd = false end
					end 
					if Peek(equalsCount+1) ~= ']' then
						foundEnd = false
					end
				else
					foundEnd = false
				end
				--
				if foundEnd then
					break
				else
					Get()
				end
			end

			--get the interior string
			local contentString = module.src:sub(contentStart, module.p - 1)

			--found the end. Get rid of the trailing bit
			for i = 0, equalsCount+1 do Get() end

			--get the exterior string
			local longString = module.src:sub(start, module.p - 1)

			--return the stuff
			return contentString, longString
		else
			return nil
		end
	else
		return nil
	end
end

function module.GetTokens(src) --\ReturnType: table
    src = module.Package.Utils.Tests.GetArguments(
        {'string', src} -- The source code to analyse
    )
	--\Doc: Returns the list of tokens
	local tokens = {}
	
	module.p = 1
	module.src = src
	module.line = 1
	module.char = 1
	
	--main token emitting loop
	while true do
		--get leading whitespace. The leading whitespace will include any comments 
		--preceding the token. This prevents the parser needing to deal with comments 
		--separately.
		local leadingWhite = ''
		while true do
			local c = Peek()
			if WhiteChars[c] then
				--whitespace
				leadingWhite = leadingWhite .. Get()
			elseif c == '-' and Peek(1) == '-' then
				--comment
				Get()
				Get()
				leadingWhite = leadingWhite..'--'
				local _, wholeText = TryGetLongString()
				if wholeText then
					leadingWhite = leadingWhite .. wholeText
				else
					while Peek() ~= '\n' and Peek() ~= '' do
						leadingWhite = leadingWhite .. Get()
					end
				end
			else
				break
			end
		end

		--get the initial char
		local thisLine = module.line
		local thisChar = module.char
		local errorAt = string.format(':%d:%d:> ', module.line, module.char)
		local c = Peek()

		--symbol to emit
		local toEmit = nil

		--branch on type
		if c == '' then
			--eof
			toEmit = {Type = 'Eof'}

		elseif UpperChars[c] or LowerChars[c] or c == '_' then
			--ident or keyword
			local start = module.p
			repeat
				Get()
				c = Peek()
			until not (UpperChars[c] or LowerChars[c] or Digits[c] or c == '_')
			local dat = src:sub(start, module.p - 1)
			if Keywords[dat] then
				toEmit = {Type = 'Keyword', Data = dat}
			else
				toEmit = {Type = 'Ident', Data = dat}
			end

		elseif Digits[c] or (Peek() == '.' and Digits[Peek(1)]) then 
			--number const
			local start = module.p
			if c == '0' and Peek(1) == 'x' then
				Get()
				Get()
				while HexDigits[Peek()] do Get() end
				if Consume('Pp') then
					Consume('+-')
					while Digits[Peek()] do Get() end
				end
			else
				while Digits[Peek()] do Get() end
				if Consume('.') then
					while Digits[Peek()] do Get() end
				end
				if Consume('Ee') then
					Consume('+-')
					while Digits[Peek()] do Get() end
				end
			end
			toEmit = {Type = 'Number', Data = src:sub(start, module.p - 1)}

		elseif c == '\'' or c == '\"' then
			local start = module.p
			--string const
			local delim = Get()
			local contentStart = module.p
			while true do
				local c = Get()
				if c == '\\' then
					Get() --get the escape char
				elseif c == delim then
					break
				elseif c == '' then
					GenerateError('Unfinished string near <eof>')
				end
			end
			local content = src:sub(contentStart, module.p - 2)
			local constant = src:sub(start, module.p - 1)
			toEmit = {Type = 'String', Data = constant, Constant = content}

		elseif c == '[' then
			local content, wholetext = TryGetLongString()
			if wholetext then
				toEmit = {Type = 'String', Data = wholetext, Constant = content}
			else
				Get()
				toEmit = {Type = 'Symbol', Data = '['}
			end

		elseif Consume('>=<') then
			if Consume('=') then
				toEmit = {Type = 'Symbol', Data = c..'='}
			else
				toEmit = {Type = 'Symbol', Data = c}
			end

		elseif Consume('~') then
			if Consume('=') then
				toEmit = {Type = 'Symbol', Data = '~='}
			else
				GenerateError('Unexpected symbol `~` in source.', 2)
			end

		elseif Consume('.') then
			if Consume('.') then
				if Consume('.') then
					toEmit = {Type = 'Symbol', Data = '...'}
				else
					toEmit = {Type = 'Symbol', Data = '..'}
				end
			else
				toEmit = {Type = 'Symbol', Data = '.'}
			end

		elseif Consume(':') then
			if Consume(':') then
				toEmit = {Type = 'Symbol', Data = '::'}
			else
				toEmit = {Type = 'Symbol', Data = ':'}
			end

		elseif Symbols[c] then
			Get()
			toEmit = {Type = 'Symbol', Data = c}

		else
			local contents, all = TryGetLongString()
			if contents then
				toEmit = {Type = 'String', Data = all, Constant = contents}
			else
				GenerateError('Unexpected Symbol `' .. c .. '` in source.', 2)
			end
		end

		--add the emitted symbol, after adding some common data
		toEmit.LeadingWhite = leadingWhite
		toEmit.Line = thisLine
		toEmit.Char = thisChar
		tokens[#tokens + 1] = toEmit

		--halt after eof has been emitted
		if toEmit.Type == 'Eof' then break end
	end
	
	return tokens
end

return module
