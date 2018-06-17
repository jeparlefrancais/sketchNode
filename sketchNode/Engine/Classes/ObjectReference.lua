-- \Description: Use this class to hold a reference to a service or an object 

local RobloxTypes = {
	string = 'string',
	number = 'number',
	table = 'table',
	bool = 'boolean'
}
local WarnTypes = {}

local function GetTypeFromRobloxTypes(rbxString)
	local typeString = RobloxTypes[rbxString]
	if typeString == nil then
		typeString = ''
		if not WarnTypes[rbxString] then
			WarnTypes[rbxString] = true
			warn(string.format('Type <%s>', arg.Type))
		end
	end
	return typeString
end

local class = {
	__name = 'ObjectReference'
}

function class.Init()
	class.__super = {class.Package.Classes.BaseReference}
	class.__signals = {

	}
end

function class.New(o, obj, member) --\ReturnType: table
	--\Doc: Manage to reference to a static object.
	obj, member = class.Package.Utils.Tests.GetArguments(
		{'Instance', obj}, -- The object to reference to
		{'string', member} -- The function, property of the object.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.BaseReference.New(o)
	--class.Package.Utils.Signal.SetSignals(class, o)

	o.path = {}
	local parent = obj
	while parent ~= game do
		table.insert(o.path, 1, parent.Name)
		parent = parent.Parent
	end
	
	o.member = member
	o.className = obj.ClassName

	o:GetMemberInfos()
	
	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.BaseReference.Load(o, data.superClass)
	
	--class.Package.Utils.Signal.SetSignals(class, o)

	o.path = data.path
	o.member = data.member
	o.className = data.ClassName
	
	o:GetMemberInfos()

	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		path = self.path,
		member = self.member,
		className = self.className,
		superClass = class.Package.Classes.BaseReference.Serialize(self)
	}
end

function class:GetMemberInfos()
	self.memberData = class.Package.RoloxClasses.GetClassMemberData(o.className, member)
	self.memberType = class.Package.RoloxClasses.GetMemberType(o.className, member)
	self.arguments = {}
	self.returnValues = {}

	for _, arg in ipairs(self.memberData.Arguments) do
		table.insert(self.arguments, class.Package.Classes.Argument:New(
			arg.Name,
			GetTypeFromRobloxTypes(arg.Type), 
			arg.Default
		))
	end

	-- Roblox Api does not give enough details to generate an correct return value
	if self.memberData.ReturnValues ~= 'void' then
		table.insert(self.returnValues, class.Package.Classes.TypedVariable:New(
			'returnValue',
			GetTypeFromRobloxTypes(self.memberData.ReturnValues)
		))
	end
end

function class:IsService() --\ReturnType: boolean
	--\Doc: Returns true if the reference is a service.
	local obj = self:GetObject()
	return obj ~= nil and obj.Parent == game
end

function class:GetObject() --\ReturnType: Instance
	--\Doc: Returns the object or nil if the object is not present.
	local obj = game
	for _, childName in ipairs(self.path) do
		obj = obj:FindFirstChild(childName)
		if obj == nil then
			return nil
		end
	end
	return obj
end

function class:GetTitle() --\ReturnType: string
	--\Doc: Returns the string that will be used as a title for its node.
	return string.format('%s.%s', self.className, self.member)
end

function class:GetArguments() --\ReturnType: table
	return self.arguments
end

function class:GetReturnValues() --\ReturnType: table
	return self.returnValues
end

function class:IsFunction() --\ReturnType: boolean
	return class.Package.RobloxClasses.GetMemberType(self.className, self.member) == 'Function'
end

function class:IsEvent() --\ReturnType: boolean
	return class.Package.RobloxClasses.GetMemberType(self.className, self.member) == 'Event'
end

function class:IsValue() --\ReturnType: boolean
	return class.Package.RobloxClasses.GetMemberType(self.className, self.member) == 'Property'
end

return class