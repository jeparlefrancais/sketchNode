local module = {
	valueTypeMap = {
		['math.pi'] = 'number',
		['math.huge'] = 'number'
	}
}

function module.Start()
	module.nameToObject = {
		['tick'] = module.Package.Classes.Function:New('tick', {}, {
			module.Package.Classes.TypedVariable:New('seconds', 'number')
		}),
		['tostring'] = module.Package.Classes.Function:New('tostring', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('resultString', 'string')
		}),
		['tonumber'] = module.Package.Classes.Function:New('tonumber', {
			module.Package.Classes.Argument:New('str', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('resultNumber', 'number')
		}),
		['type'] = module.Package.Classes.Function:New('type', {
			module.Package.Classes.Argument:New('var', '')
		}, {
			module.Package.Classes.TypedVariable:New('type', 'string')
		}),
		['typeof'] = module.Package.Classes.Function:New('typeof', {
			module.Package.Classes.Argument:New('var', '')
		}, {
			module.Package.Classes.TypedVariable:New('type', 'string')
		}),
		-- os library
		['os.time'] = module.Package.Classes.Function:New('typeof', {}, {
			module.Package.Classes.TypedVariable:New('seconds', 'number')
		}),
		['os.date'] = module.Package.Classes.Function:New('typeof', {
			module.Package.Classes.Argument:New('formatString', 'string'),
			module.Package.Classes.Argument:New('time', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('dict', 'table')
		}),
		['os.difftime'] = module.Package.Classes.Function:New('typeof', {
			module.Package.Classes.Argument:New('time1', 'number'),
			module.Package.Classes.Argument:New('time2', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('diff', 'number')
		}),
		-- string library
		['string.byte'] = module.Package.Classes.Function:New('string.byte', {
			module.Package.Classes.Argument:New('charString', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('charNum', 'number')
		}),
		['string.char'] = module.Package.Classes.Function:New('string.char', {
			module.Package.Classes.Argument:New('char', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'string')
		}),
		['string.find'] = module.Package.Classes.Function:New('string.find', {
			module.Package.Classes.Argument:New('search', 'string'),
			module.Package.Classes.Argument:New('pattern', 'string'),
			module.Package.Classes.Argument:New('startFrom', 'number', 1),
			module.Package.Classes.Argument:New('plain', 'boolean', false),
		}, {
			module.Package.Classes.TypedVariable:New('location', 'number'),
		}),
		['string.format'] = module.Package.Classes.Function:New('string.format', {
			module.Package.Classes.Argument:New('format', 'string'),
			module.Package.Classes.Argument:New('values', 'table'),
		}, {
			module.Package.Classes.TypedVariable:New('result', 'string'),
		}),
		['string.len'] = module.Package.Classes.Function:New('string.len', {
			module.Package.Classes.Argument:New('str', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('length', 'number'),
		}),
		['string.lower'] = module.Package.Classes.Function:New('string.lower', {
			module.Package.Classes.Argument:New('str', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('lowerString', 'string'),
		}),
		['string.upper'] = module.Package.Classes.Function:New('string.upper', {
			module.Package.Classes.Argument:New('str', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('upperString', 'string'),
		}),
		['string.match'] = module.Package.Classes.Function:New('string.upper', {
			module.Package.Classes.Argument:New('str', 'string'),
			module.Package.Classes.Argument:New('pattern', 'string'),
			module.Package.Classes.Argument:New('init', 'number', 1)
		}, {
			module.Package.Classes.TypedVariable:New('match', 'string', true),
		}),
		['string.rep'] = module.Package.Classes.Function:New('string.rep', {
			module.Package.Classes.Argument:New('str', 'string'),
			module.Package.Classes.Argument:New('count', 'number', 1)
		}, {
			module.Package.Classes.TypedVariable:New('repeated', 'string'),
		}),
		['string.reverse'] = module.Package.Classes.Function:New('string.reverse', {
			module.Package.Classes.Argument:New('str', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('reversed', 'string')
		}),
		['string.sub'] = module.Package.Classes.Function:New('string.sub', {
			module.Package.Classes.Argument:New('str', 'string'),
			module.Package.Classes.Argument:New('start', 'number', 1),
			module.Package.Classes.Argument:New('chars', 'number', nil, true)
		}, {
			module.Package.Classes.TypedVariable:New('result', 'string')
		}),
		['string.gsub'] = module.Package.Classes.Function:New('string.gsub', {
			module.Package.Classes.Argument:New('str', 'string'),
			module.Package.Classes.Argument:New('pattern', 'string'),
			module.Package.Classes.Argument:New('replace', 'string'),
			module.Package.Classes.Argument:New('n', 'number', nil, true)
		}, {
			module.Package.Classes.TypedVariable:New('result', 'string')
		}),
		['string.gmatch'] = module.Package.Classes.Function:New('string.gmatch', {
			module.Package.Classes.Argument:New('str', 'string'),
			module.Package.Classes.Argument:New('pattern', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('iterator', 'function')
		}),
		-- math library
		['math.abs'] = module.Package.Classes.Function:New('math.abs', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.acos'] = module.Package.Classes.Function:New('math.acos', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.asin'] = module.Package.Classes.Function:New('math.asin', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.atan'] = module.Package.Classes.Function:New('math.atan', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.atan2'] = module.Package.Classes.Function:New('math.atan2', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.ceil'] = module.Package.Classes.Function:New('math.ceil', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.cos'] = module.Package.Classes.Function:New('math.cos', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.cosh'] = module.Package.Classes.Function:New('math.cosh', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.exp'] = module.Package.Classes.Function:New('math.exp', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.floor'] = module.Package.Classes.Function:New('math.floor', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.frexp'] = module.Package.Classes.Function:New('math.frexp', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.log'] = module.Package.Classes.Function:New('math.log', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.log10'] = module.Package.Classes.Function:New('math.log10', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.clamp'] = module.Package.Classes.Function:New('math.clamp', {
			module.Package.Classes.Argument:New('num', 'number'),
			module.Package.Classes.Argument:New('min', 'number'),
			module.Package.Classes.Argument:New('max', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.deg'] = module.Package.Classes.Function:New('math.deg', {
			module.Package.Classes.Argument:New('rad', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.fmod'] = module.Package.Classes.Function:New('math.fmod', {
			module.Package.Classes.Argument:New('num', 'number'),
			module.Package.Classes.Argument:New('divider', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.ldexp'] = module.Package.Classes.Function:New('math.ldexp', {
			module.Package.Classes.Argument:New('m', 'number'),
			module.Package.Classes.Argument:New('e', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.modf'] = module.Package.Classes.Function:New('math.modf', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('int', 'number'),
			module.Package.Classes.TypedVariable:New('frac', 'number')
		}),
		['math.noise'] = module.Package.Classes.Function:New('math.noise', {
			module.Package.Classes.Argument:New('x', 'number'),
			module.Package.Classes.Argument:New('y', 'number', 0),
			module.Package.Classes.Argument:New('z', 'number', 0)
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.pow'] = module.Package.Classes.Function:New('math.pow', {
			module.Package.Classes.Argument:New('num', 'number'),
			module.Package.Classes.Argument:New('exponent', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.rad'] = module.Package.Classes.Function:New('math.rad', {
			module.Package.Classes.Argument:New('degree', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('radian', 'number')
		}),
		['math.random'] = module.Package.Classes.Function:New('math.random', {}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.randInt'] = module.Package.Classes.Function:New('math.randInt', {
			module.Package.Classes.Argument:New('min', 'number'),
			module.Package.Classes.Argument:New('max', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.randomseed'] = module.Package.Classes.Function:New('math.randomseed', {
			module.Package.Classes.Argument:New('seed', 'number')
		}, {}),
		['math.sign'] = module.Package.Classes.Function:New('math.sign', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.sin'] = module.Package.Classes.Function:New('math.sin', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.sinh'] = module.Package.Classes.Function:New('math.sinh', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.sqrt'] = module.Package.Classes.Function:New('math.sqrt', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.tan'] = module.Package.Classes.Function:New('math.tan', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.tanh'] = module.Package.Classes.Function:New('math.tanh', {
			module.Package.Classes.Argument:New('num', 'number')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'number')
		}),
		['math.pi'] = 'math.pi',
		['math.huge'] = 'math.huge',
		-- table library
		['table.concat'] = module.Package.Classes.Function:New('table.concat', {
			module.Package.Classes.Argument:New('table', 'table'),
			module.Package.Classes.Argument:New('seperator', 'string')
		}, {
			module.Package.Classes.TypedVariable:New('result', 'string')
		}),
		['table.insert'] = module.Package.Classes.Function:New('table.insert', {
			module.Package.Classes.Argument:New('table', 'table'),
			module.Package.Classes.Argument:New('element', '')
		}, {}),
		['table.insertAt'] = module.Package.Classes.Function:New('table.insertAt', {
			module.Package.Classes.Argument:New('table', 'table'),
			module.Package.Classes.Argument:New('position', 'number'),
			module.Package.Classes.Argument:New('element', '')
		}, {}),
		['table.remove'] = module.Package.Classes.Function:New('table.remove', {
			module.Package.Classes.Argument:New('table', 'table'),
			module.Package.Classes.Argument:New('position', 'number')
		}, {}),
		['table.sort'] = module.Package.Classes.Function:New('table.sort', {
			module.Package.Classes.Argument:New('table', 'table'),
			module.Package.Classes.Argument:New('comparer', 'function')
		}, {
			module.Package.Classes.TypedVariable:New('element', '')
		}),
	}

	module.referenceNames = {}
	for name in pairs(module.nameToObject) do
		table.insert(module.referenceNames, name)
	end
	
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
        {'string', referenceName} -- The name of the reference.
    )
    return type(module.nameToObject[referenceName]) ~= 'string'
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
        {'string', referenceName} -- The name of the reference.
    )
    if module.IsFunction(referenceName) then
        return module.nameToObject[referenceName]
    else
        return nil
    end
end

function module.GetValueType(referenceName) --\ReturnType: string
    --Doc: Returns the type of the value link by the reference.
	referenceName = module.Package.Utils.Tests.GetArguments(
        {'string', referenceName} -- The name of the reference.
	)
	return module.valueTypeMap[referenceName]
end

function module.GetSource(referenceName) --\ReturnType: string
    --\Doc: Returns the source with '%s' symbols to format with the arguments.
	referenceName = module.Package.Utils.Tests.GetArguments(
        {'string', referenceName} -- The name of the reference.
    )
	return module.nameToCode[referenceName]
end

function module.GetReferenceNames() --\ReturnType: table
    --\Doc: Returns the possible names that refer to lua functions or values.
    return module.referenceNames
end

return module
