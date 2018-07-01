--\Description: This module is used to get methods, properties or events from Roblox object classes. It can also be used to know various information about any class, function, property or event, by checking the presence of certain tags (i.e. hidden, readonly, deprecated). For more informations, visit http://wiki.roblox.com/index.php?title=API:Class_reference/Dump/Help.

local HTTP = game:GetService('HttpService')

local memberTypeToKey = {
    Property = 'Properties',
    Event = 'Events',
    Function = 'Functions'
}

local module = {}

local function AddEntry(entry)
	for _, tag in ipairs(entry.tags) do
		if tag == 'deprecated'
			or tag == 'RobloxSecurity'
			or tag == 'PluginSecurity'
			or tag == 'RobloxScriptSecurity'
			or tag == 'hidden'
			then return
		end
	end

	if entry.type == 'Class' then
		module.metadata[entry.Name] = {
			SuperClass = entry.Superclass,
			Properties = {},
			Functions = {},
			Events = {},
			MemberTypeMap = {}
		}

	else
		if module.metadata[entry.Class] then
			if entry.type == 'Property' then
				module.metadata[entry.Class].MemberTypeMap[entry.Name] = 'Property'
				table.insert(module.metadata[entry.Class].Properties, {
					Name = entry.Name,
					Type = entry.ValueType,
					Tags = entry.tags
				})
				
			elseif entry.type == 'Function' then
				module.metadata[entry.Class].MemberTypeMap[entry.Name] = 'Function'
				table.insert(module.metadata[entry.Class].Functions, {
					Name = entry.Name,
					ReturnValues = entry.ReturnType,
					Arguments = entry.Arguments,
					Tags = entry.tags
				})

			elseif entry.type == 'Event' then
				module.metadata[entry.Class].MemberTypeMap[entry.Name] = 'Event'
				table.insert(module.metadata[entry.Class].Events, {
					Name = entry.Name,
					ReturnValues = entry.Arguments,
					Tags = entry.tags
				})

			elseif entry.type == 'YieldFunction' then
				module.metadata[entry.Class].MemberTypeMap[entry.Name] = 'Function'
				table.insert(entry.tags, 'Yield')
				table.insert(module.metadata[entry.Class].Functions, {
					Name = entry.Name,
					ReturnValues = entry.ReturnType,
					Arguments = entry.Arguments,
					Tags = entry.tags
				})
				
			elseif entry.type == 'Callback' then
				module.metadata[entry.Class].MemberTypeMap[entry.Name] = 'Property'
				table.insert(module.metadata[entry.Class].Properties, {
					Name = entry.Name,
					Type = 'Function',
					Tags = entry.tags
				})
				
			elseif entry.type == 'Enum' then
				module.enumMetadata[entry.Name] = {
					Items = {},
					Tags = entry.tags
				}

			elseif entry.type == 'EnumItem' then
				table.insert(module.enumMetadata[entry.Enum].Items, {
					Name = entry.Name,
					Value = entry.Value,
					Tags = entry.tags
				})

			else
				warn(string.format('RobloxClasses can not store entry of type <%s>', entry.type))
			end
		end
	end
end

function module.Init()
	local json = module.Package.Resources.ClassMetadata
	
	-- extract data
	local data = HTTP:JSONDecode(json)
	
	module.metadata = {}
	module.enumMetadata = {}

	for _, entry in ipairs(data) do
		AddEntry(entry)
	end
end

function module.IsRobloxClass(className) --\ReturnType: boolean
	--\Doc: Returns true if the given string is a Roblox class.
	className = module.Package.Utils.Tests.GetArguments(
		{'string', className} -- The class to test.
	)
	return module.metadata[className] ~= nil
end

function module.GetMemberType(className, member) --\ReturnType: string
	--\Doc: Returns the type of the member (property, function or event).
	className, member = module.Package.Utils.Tests.GetArguments(
		{'string', className}, -- The class of the object
		{'string', member} -- The type of member used to index the data table
	)
	repeat
		if module.metadata[className].MemberTypeMap[member] then
			return module.metadata[className].MemberTypeMap[member]
		end
		className = module.metadata[className].SuperClass
	until className == nil
end

function module.GetClassMemberData(className, member) --\ReturnType: table
	className, member = module.Package.Utils.Tests.GetArguments(
		{'string', className}, -- The class of the object
		{'string', member} -- The type of member used to index the data table
	)
	local memberType = module.GetMemberType(className, member)
	if memberType then
		for _, data in ipairs(module.GetClassMembers(className, memberType)) do
			if data.Name == member then
				return data
			end
		end
	end
end

function module.GetClassMembers(className, memberType) --\ReturnType: table
	className, memberType = module.Package.Utils.Tests.GetArguments(
		{'string', className}, -- The class of the object
		{'string', memberType} -- The type of member used to index the data table
	)
	local members = {}
	
	repeat
		for _, result in ipairs(module.metadata[className][memberTypeToKey[memberType]]) do
			table.insert(members, result)
		end
		
		className = module.metadata[className].SuperClass
	until className == nil

	return members
end

function module.GetClassProperties(className) --\ReturnType: table
	--\Doc: Returns the properties from the class with the inherited ones
	className = module.Package.Utils.Tests.GetArguments(
		{'string', className} -- The class of the object
	)
	return module.GetClassMembers(className, 'Property')
end

function module.GetClassFunctions(className) --\ReturnType: table
	--\Doc: Returns the functions from the class with the inherited ones
	className = module.Package.Utils.Tests.GetArguments(
		{'string', className} -- The class of the object
	)
	return module.GetClassMembers(className, 'Function')
end

function module.GetClassEvents(className) --\ReturnType: table
	--\Doc: Returns the events from the class with the inherited ones
	className = module.Package.Utils.Tests.GetArguments(
		{'string', className} -- The class of the object
	)
	return module.GetClassMembers(className, 'Event')
end

function module.ClassHasTag(className, tag) --\ReturnType: boolean
	--\Doc: Returns if a class has a tag
	className, tag = module.Package.Utils.Tests.GetArguments(
		{'string', className}, -- The class of the object
		{'string', tag} -- The tag to look for
	)
	for _, tagged in ipairs(module.metadata[className].Tags) do
		if tagged == tag then
			return true
		end
	end
	return false
end

function module.MemberHasTag(className, memberType, name, tag)
	--\Doc: Returns if a certain field has a tag
	className, memberType, name, tag = module.Package.Utils.Tests.GetArguments(
		{'string', className}, -- The class of the object
		{'string', memberType}, -- The type of member used to index the data table
		{'string', name}, -- The name of the functions, property or event
		{'string', tag} -- The tag to look for
	)
	for _, member in ipairs(module.GetClassMembers(className, memberType)) do
		if member.Name == name then
			for _, tagged in ipairs(member.Tags) do
				if tagged == tag then
					return true
				end
			end
		end
	end
	return false
end

return module
