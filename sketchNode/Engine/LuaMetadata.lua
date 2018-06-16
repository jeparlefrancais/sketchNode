local module = {}

function module.Init()
	module.nameToObject = {
		['tostring'] = module.Classes.Function:New('tostring', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('resultString', 'string')
		}),
		['tonumber'] = module.Classes.Function:New('tonumber', {
			module.Classes.Argument:New('str', 'string')
		}, {
			module.Classes.TypedVariable:New('resultNumber', 'number')
		}),
		['type'] = module.Classes.Function:New('type', {
			module.Classes.Argument:New('var', '')
		}, {
			module.Classes.TypedVariable:New('type', 'string')
		}),
		['typeof'] = module.Classes.Function:New('typeof', {
			module.Classes.Argument:New('var', '')
		}, {
			module.Classes.TypedVariable:New('type', 'string')
		}),
		-- os library
		['os.time'] = module.Classes.Function:New('os.time', {}, {}),
		['os.date'] = module.Classes.Function:New('typeof', {
			module.Classes.Argument:New('formatString', 'string'),
			module.Classes.Argument:New('time', 'number')
		}, {
			module.Classes.TypedVariable:New('dict', 'table')
		}),
		['os.difftime'] = module.Classes.Function:New('typeof', {
			module.Classes.Argument:New('time1', 'number'),
			module.Classes.Argument:New('time2', 'number')
		}, {
			module.Classes.TypedVariable:New('diff', 'number')
		}),
		-- string library
		['string.byte'] = module.Classes.Function:New('string.byte', {
			module.Classes.Argument:New('charString', 'string')
		}, {
			module.Classes.TypedVariable:New('charNum', 'number')
		}),
		['string.char'] = module.Classes.Function:New('string.char', {
			module.Classes.Argument:New('char', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'string')
		}),
		['string.find'] = module.Classes.Function:New('string.find', {
			module.Classes.Argument:New('search', 'string'),
			module.Classes.Argument:New('pattern', 'string'),
			module.Classes.Argument:New('startFrom', 'number', 1),
			module.Classes.Argument:New('plain', 'boolean', false),
		}, {
			module.Classes.TypedVariable:New('location', 'number'),
		}),
		['string.format'] = module.Classes.Function:New('string.format', {
			module.Classes.Argument:New('format', 'string'),
			module.Classes.Argument:New('values', 'table'),
		}, {
			module.Classes.TypedVariable:New('result', 'string'),
		}),
		['string.len'] = module.Classes.Function:New('string.len', {
			module.Classes.Argument:New('str', 'string')
		}, {
			module.Classes.TypedVariable:New('length', 'number'),
		}),
		['string.lower'] = module.Classes.Function:New('string.lower', {
			module.Classes.Argument:New('str', 'string')
		}, {
			module.Classes.TypedVariable:New('lowerString', 'string'),
		}),
		['string.upper'] = module.Classes.Function:New('string.upper', {
			module.Classes.Argument:New('str', 'string')
		}, {
			module.Classes.TypedVariable:New('upperString', 'string'),
		}),
		['string.match'] = module.Classes.Function:New('string.upper', {
			module.Classes.Argument:New('str', 'string'),
			module.Classes.Argument:New('pattern', 'string'),
			module.Classes.Argument:New('init', 'number', 1)
		}, {
			module.Classes.TypedVariable:New('match', 'string', true),
		}),
		['string.rep'] = module.Classes.Function:New('string.rep', {
			module.Classes.Argument:New('str', 'string'),
			module.Classes.Argument:New('count', 'number', 1)
		}, {
			module.Classes.TypedVariable:New('repeated', 'string'),
		}),
		['string.reverse'] = module.Classes.Function:New('string.reverse', {
			module.Classes.Argument:New('str', 'string')
		}, {
			module.Classes.TypedVariable:New('reversed', 'string')
		}),
		['string.sub'] = module.Classes.Function:New('string.sub', {
			module.Classes.Argument:New('str', 'string'),
			module.Classes.Argument:New('start', 'number', 1),
			module.Classes.Argument:New('chars', 'number', nil, true)
		}, {
			module.Classes.TypedVariable:New('result', 'string')
		}),
		['string.gsub'] = module.Classes.Function:New('string.gsub', {
			module.Classes.Argument:New('str', 'string'),
			module.Classes.Argument:New('pattern', 'string'),
			module.Classes.Argument:New('replace', 'string'),
			module.Classes.Argument:New('n', 'number', nil, true)
		}, {
			module.Classes.TypedVariable:New('result', 'string')
		}),
		['string.gmatch'] = module.Classes.Function:New('string.gmatch', {
			module.Classes.Argument:New('str', 'string'),
			module.Classes.Argument:New('pattern', 'string')
		}, {
			module.Classes.TypedVariable:New('iterator', 'function')
		}),
		-- math library
		['math.abs'] = module.Classes.Function:New('math.abs', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.acos'] = module.Classes.Function:New('math.acos', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.asin'] = module.Classes.Function:New('math.asin', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.atan'] = module.Classes.Function:New('math.atan', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.atan2'] = module.Classes.Function:New('math.atan2', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.ceil'] = module.Classes.Function:New('math.ceil', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.cos'] = module.Classes.Function:New('math.cos', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.cosh'] = module.Classes.Function:New('math.cosh', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.exp'] = module.Classes.Function:New('math.exp', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.floor'] = module.Classes.Function:New('math.floor', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.frexp'] = module.Classes.Function:New('math.frexp', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.log'] = module.Classes.Function:New('math.log', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.log10'] = module.Classes.Function:New('math.log10', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.clamp'] = module.Classes.Function:New('math.clamp', {
			module.Classes.Argument:New('num', 'number'),
			module.Classes.Argument:New('min', 'number'),
			module.Classes.Argument:New('max', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.deg'] = module.Classes.Function:New('math.deg', {
			module.Classes.Argument:New('rad', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.fmod'] = module.Classes.Function:New('math.fmod', {
			module.Classes.Argument:New('num', 'number'),
			module.Classes.Argument:New('divider', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.ldexp'] = module.Classes.Function:New('math.ldexp', {
			module.Classes.Argument:New('m', 'number'),
			module.Classes.Argument:New('e', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.modf'] = module.Classes.Function:New('math.modf', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('int', 'number'),
			module.Classes.TypedVariable:New('frac', 'number')
		}),
		['math.noise'] = module.Classes.Function:New('math.noise', {
			module.Classes.Argument:New('x', 'number'),
			module.Classes.Argument:New('y', 'number', 0),
			module.Classes.Argument:New('z', 'number', 0)
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.pow'] = module.Classes.Function:New('math.pow', {
			module.Classes.Argument:New('num', 'number'),
			module.Classes.Argument:New('exponent', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.rad'] = module.Classes.Function:New('math.rad', {
			module.Classes.Argument:New('degree', 'number')
		}, {
			module.Classes.TypedVariable:New('radian', 'number')
		}),
		['math.random'] = module.Classes.Function:New('math.random', {}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.randInt'] = module.Classes.Function:New('math.randInt', {
			module.Classes.Argument:New('min', 'number'),
			module.Classes.Argument:New('max', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.randomseed'] = module.Classes.Function:New('math.randomseed', {
			module.Classes.Argument:New('seed', 'number')
		}, {}),
		['math.sign'] = module.Classes.Function:New('math.sign', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.sin'] = module.Classes.Function:New('math.sin', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.sinh'] = module.Classes.Function:New('math.sinh', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.sqrt'] = module.Classes.Function:New('math.sqrt', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.tan'] = module.Classes.Function:New('math.tan', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.tanh'] = module.Classes.Function:New('math.tanh', {
			module.Classes.Argument:New('num', 'number')
		}, {
			module.Classes.TypedVariable:New('result', 'number')
		}),
		['math.pi'] = 'math.pi',
		['math.huge'] = 'math.huge',
		-- table library
		['table.concat'] = module.Classes.Function:New('table.concat', {
			module.Classes.Argument:New('table', 'table'),
			module.Classes.Argument:New('seperator', 'string')
		}, {
			module.Classes.TypedVariable:New('result', 'string')
		}),
		['table.insert'] = module.Classes.Function:New('table.insert', {
			module.Classes.Argument:New('table', 'table'),
			module.Classes.Argument:New('element', '')
		}, {}),
		['table.insertAt'] = module.Classes.Function:New('table.insertAt', {
			module.Classes.Argument:New('table', 'table'),
			module.Classes.Argument:New('position', 'number'),
			module.Classes.Argument:New('element', '')
		}, {}),
		['table.remove'] = module.Classes.Function:New('table.remove', {
			module.Classes.Argument:New('table', 'table'),
			module.Classes.Argument:New('position', 'number')
		}, {}),
		['table.sort'] = module.Classes.Function:New('table.sort', {
			module.Classes.Argument:New('table', 'table'),
			module.Classes.Argument:New('comparer', 'function')
		}, {
			module.Classes.TypedVariable:New('element', '')
		}),
	}
	
	-- some functions needs a wrapper, otherwise it should only use the name
	module.nameToCode = {
		['string.format'] = 'string.format(%s, unpack(%s))',
		['table.insertAt'] = 'table.insert(%s, %s, %s)'
	}

	setmetatable(module.nameToCode, {
		__index = function(t, key)
            if module.nameToObject[key] then
                if module.IsFunction(key) then
					local args = #module.nameToObject[key]:GetArguments()
					if args == 0 then
						return string.format('%s()', module.nameToObject[key]:GetName())
					elseif args == 1 then
						return string.format('%s(%s)', module.nameToObject[key]:GetName(), '%s')
					else
						return string.format('%s(%s%s)', module.nameToObject[key]:GetName(), '%s', string.rep(', %s', args - 1))
                    end
                else
                    return module.nameToObject[key]
				end
			end
		end
	})
end

function module.IsFunction(referenceName) --\ReturnType: boolean
	referenceName = module.Package.Utils.Tests.GetArguments(
        {'string', referenceName} -- The name of the .
    )
    return type(module.nameToObject[key]) ~= 'string'
end

function module.Search(search) --\ReturnType: table
    --\Doc: Returns a list of reference names
	search = module.Package.Utils.Tests.GetArguments(
        {'string', search} -- Search text
    )
end

function module.GetFunction(referenceName) --\ReturnType: Function
    --Doc: Returns the function link by the reference.
	referenceName = module.Package.Utils.Tests.GetArguments(
        {'string', referenceName} -- The name of the .
    )
    if module.IsFunction(referenceName) then
        return module.nameToCode[referenceName]
    else
        return nil
    end
end


function module.GetSource(referenceName) --\ReturnType: string
    --\Doc: Returns the source with '%s' symbols to format with the arguments.
	referenceName = module.Package.Utils.Tests.GetArguments(
        {'string', referenceName} -- The name of the .
    )
	return module.nameToCode[referenceName]
end

return module
