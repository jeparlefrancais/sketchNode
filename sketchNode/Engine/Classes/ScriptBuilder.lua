-- \Description: Add a description

local IDENTIFIER_PATTERN = '^[_%a][_%a%d]*$'
local FORBIDDEN_IDENTIFIER = '[^_%a%d]'

local class = {
	__name = 'ScriptBuilder'
}

function class.Init()

end

function class.New(o) --\ReturnType: table
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.services = {}
	o.constants = {}
	o.globalVariables = {}
	o.identifiers = {}

	return o
end

function class:GetServiceVariable(serviceName) --\ReturnType: string
	--\Doc: Take the service class name and returns the variable identifier
	serviceName = class.Package.Utils.Tests.GetArguments(
		{'string', serviceName} -- The service class.
	)
	return string.format('service_%s', serviceName:gsub('%s', ''))
end

function class:IsServiceAdded(serviceName) --\ReturnType: boolean
	--\Doc: Returns if the service is already in the list
	serviceName = class.Package.Utils.Tests.GetArguments(
		{'string', serviceName} -- The service class.
	)
	for _, service in ipairs(self.services) do
		if service == serviceName then
			return true
		end
	end
	return false
end

function class:AddService(serviceName) --\ReturnType: boolean
	--\Doc: Returns true if the service was added, or false if it was already there.
	serviceName = class.Package.Utils.Tests.GetArguments(
		{'string', serviceName} -- The service class.
	)
	if self:IsServiceAdded(serviceName) then
		return false
	else
		table.insert(self.services, string.format(
			"local %s = game:GetService('%s')",
			self:GetServiceVariable(serviceName),
			serviceName
		))
		return true
	end
end

function class:IsIdentifierUsed(identifier) --\ReturnType: boolean
	serviceName = class.Package.Utils.Tests.GetArguments(
		{'string', serviceName} -- The service class.
	)
	return self.identifiers[identifier] ~= nil
end

function class:AddConstant(identifier, codeValue)
	--\Doc: Adds the identifier to the constant list
	identifier, codeValue = class.Package.Utils.Tests.GetArguments(
		{'string', identifier}, -- The service class.
		{'string', codeValue} -- The code that gives that value.
	)
	self.identifiers[indentifier] = true
	table.insert(self.constants, string.format(
		'local %s = %s',
		identifier,
		codeValue
	))
end

function class:GetCleanIdentifier(identifier, spaceReplace) --\ReturnType: string
	--\Doc: Take a potential identifier and returns a clean version (remove the spaces, ponctuations, operators, etc)
	identifier, spaceReplace = class.Package.Utils.Tests.GetArguments(
		{'string', identifier}, -- The list of object names to the final object
		{'string', spaceReplace, ''} -- The string to replace the spaces with.
	)
	if string.match(identifier, IDENTIFIER_PATTERN) then
		return identifier
	else
		if string.len(identifier) == 0 then
			return 'noName'
		else
			identifier = string.gsub(identifier, ' ', spaceReplace)
			if string.match(identifier, IDENTIFIER_PATTERN) then
				return identifier
			else
				if string.match(string.gsub(identifier, 1, 1), '[_%a]') == nil then
					identifier = '_' .. identifier
				end
				if string.match(identifier, IDENTIFIER_PATTERN) then
					return identifier
				else
					return string.gsub(identifier, FORBIDDEN_IDENTIFIER, '_')
				end
			end
		end
	end
end

function class:AddObjectReference(objectReference) --\ReturnType: string
	--\Doc: Adds a constant for the object reference and returns the identifier of that constant.
	objectReference = class.Package.Utils.Tests.GetArguments(
		{'ObjectReference', objectReference}
	)
	if ref:IsService() then
		local serviceClass = ref:GetObject().ClassName
		builder:AddService(serviceClass)
		return GetServiceVariable(serviceClass)
	else
		local path = ref:GetPath()
		builder:AddService(path[1])
		local serviceVar = builder:GetServiceVariable(path[1])
		local indexMethod = flags.WaitForStaticObjects and ":WaitForChild('')" or ":FindFirstChild('')"

		local codeValue = serviceVar .. string.format(
			string.rep(indexMethod, #path - 1),
			unpack(path, 2)
		)
		local object = ref:GetObject()
		local identifier = builder:GetCleanIdentifier(string.upper(object.Name), '_')
		local tries = 0
		while self:IsIdentifierUsed(identifier) do
			if tries == 0 then
				identifier = builder:GetCleanIdentifier(string.upper(
					string.format('%s_%s', object.ClassName, object.Name)
				), '_')
			else
				identifier = builder:GetCleanIdentifier(string.upper(
					string.format('%s_%d', object.Name, tries)
				), '_')
			end
		end
		builder:AddConstant(identifier, codeValue)
		return identifier
	end
end

function class:AddEventConnection(identifier, parameters, contentLines)
	--\Doc: Adds code to connect an event.
	identifier, parameters, contentLines = class.Package.Utils.Tests.GetArguments(
		{'string', identifier}, -- The event identifier to connect to.
		{'table', parameters}, -- The list of string containing the variable names.
		{'table', contentLines} -- The list of lines of code.
	)
	local code = string.format([=[%s:Connect(function(%s)
\t%s
end)]=],
	identifier,
	table.concat(parameters, ', '),
	table.concat(contentLines, '\n\t')
	)
end

function class:GetCode() --\ReturnType: string
	table.sort(self.services)
	table.sort(self.constants)
	table.sort(self.globalVariables)
	return string.format(
		[=[-- SERVICES
%s

-- CONSTANTS
%s

-- GLOBAL VARIABLES
%s

-- SCRIPT
%s
		]=],
		table.concat(self.services, '\n'),
		table.concat(self.constants, '\n'),
		table.concat(self.globalVariables, '\n')
	)
end

return class
