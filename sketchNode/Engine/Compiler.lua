--\Description: This module is used to generate scripts from the different nodes.

local module = {}

function module.GetArgumentList(func) --\ReturnType: string
    func = module.Package.Utils.Tests.GetArguments(
		{'Function', func} -- The function to get the argument list from.
	)
	local args = {}
	for _, arg in ipairs(func:GetArguments()) do
		table.insert(args, arg:GetName())
	end
	return table.concat(args, ', ')
end

function module.GetDefaultValue(arg) --\ReturnType: string
	--\Doc: Returns the source code to set a variable to have the given default value.
    arg = module.Package.Utils.Tests.GetArguments(
		{'Argument', arg} -- The argument or property.
	)
	local defaultValue = arg:GetDefaultValue()
	local valueType = arg:GetType()
	if valueType == 'number' then
		return tostring(defaultValue)
	elseif valueType == 'string' then
		local pattern = '[[%s]]'
		if string.find(defaultValue, "'") == nil then
			pattern = "'%s'"
		elseif string.find(defaultValue, '"') == nil then
			pattern = '"%s"'
		end
		return string.format(pattern, defaultValue)
	end
	return 'nil'
end

function module.GetArgumentsDefaultValues(func) --\ReturnType: string
	--\Doc: Returns the source code to set arguments to their default values.
    func = module.Package.Utils.Tests.GetArguments(
		{'Function', func} -- The function to get the argument list from.
	)
	local args = {}
	for _, arg in ipairs(func:GetArguments()) do
		local name = arg:GetName()
		local defaultValueText = module.GetDefaultValue(arg)
		if defaultValueText ~= 'nil' then
			table.insert(args, string.format('if %s == nil then %s = %s end', name, name, defaultValueText))
		end
	end
	return table.concat(args, '\n	')
end

function module.GetArgumentsTesting(func) --\ReturnType: string
	--\Doc: Returns the source code that tests the function arguments.
    func = module.Package.Utils.Tests.GetArguments(
		{'Function', func} -- The function to get the argument list from.
	)
	local args = {}
	for _, arg in ipairs(func:GetArguments()) do
		local name = arg:GetName()
		local typeString = arg:GetType()
		if typeString ~= nil and typeString ~= '' then
			if arg:GetCanBeNil() then
				table.insert(args, string.format('if %s ~= nil then Tests(%s, %s) end', name, name, typeString))
			else
				table.insert(args, string.format('Tests(%s, %s)', name, typeString))
			end
		end
	end
	return table.concat(args, '\n	')
end

function module.GetRequirement(sourceName, access, sourceType) --\ReturnType: string
	--\Doc: Returns the code to require the given script name.
    sourceName, access, sourceType = module.Package.Utils.Tests.GetArguments(
		{'string', sourceName}, -- The name of the script.
		{'string', access}, -- The access of the script (Shared, Client, Server)
		{'string', sourceType}
	)
	local service = module.Package.EngineSettings.ServiceFromAccess[access]
	local folder = module.Package.EngineSettings.FolderFromType[sourceType]
	if service == nil or folder == nil then
		error(string.format('Can not require source named <%s> of type <%s>', sourceName, sourceType))
	end
	return string.format("local %s = require(game:GetService('%s'):WaitForChild('%s%s'):WaitForChild('%s'))", sourceName, service, access, folder, sourceName)
end

function module.CompileModule(moduleObject, testTypes) --\ReturnType: string
    --\Doc: Returns the script source of the given module.
    moduleObject, testTypes = module.Package.Utils.Tests.GetArguments(
		{'Module', moduleObject}, -- The module to compile.
		{'boolean', testTypes, true} -- If types should be tested whenever it's possible.
	)
	local requirements = {}
	if testTypes then
		table.insert(requirements, module.GetRequirement(module.Package.EngineSettings.TestsScriptName, 'Shared', 'Function'))
	end
	local properties = {}
	for _, property in ipairs(moduleObject:GetProperties()) do
		table.insert(properties, string.format('%s = %s', property:GetName(), module.GetDefaultValue(property)))
	end
	local functions = {}
	for _, func in ipairs(moduleObject:GetFunctions()) do
		local defaultValues = module.GetArgumentsDefaultValues(func)
		local funcSource = string.format(
			'%s%s\n%s',
			defaultValues == '' and '' or '	' .. defaultValues .. '\n',
			testTypes and '	' .. module.GetArgumentsTesting(func) or '',
			func:GetSource()
		)
		local source = string.format(
			'function module.%s(%s)\n%s\nend',
			func:GetName(),
			module.GetArgumentList(func),
			funcSource
		)
		table.insert(functions, source)
	end
	return string.format([[%s
local module = {
	%s
}

%s

return module
]], table.concat(requirements, '\n'), table.concat(properties, ',\n	'), table.concat(functions, '\n\n'))
end

function module.CompileClass(classObject, testTypes) --\ReturnType: string
	--\Doc: Returns the script source of the given class.
    classObject, testTypes = module.Package.Utils.Tests.GetArguments(
        {'Class', classObject}, -- The module to compile.
		{'boolean', testTypes, true} -- If types should be tested whenever it's possible.
	)
end

return module
