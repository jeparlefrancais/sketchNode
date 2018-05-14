--\Description: Add a description

local class = {
	__name = 'Module'
}

function class.Init()
	class.__super = {class.Package.Classes.PropertyContainer}
end

function class.New(o, name, isServer) --\ReturnType: table
	name, isServer = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name of the module.
        {'boolean', isServer} -- If the module runs on the server or the client.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.PropertyContainer.New(o)

	o.name = name
	o.isServer = isServer
	o.functions = {}

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.PropertyContainer.Load(o, data.superPropertyContainer)

	o.name = data.name
	o.isServer = data.isServer
	o.functions = class.Package.LoadTable(data.functions, class.Package.Classes.Function)

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		name = self.name,
		isServer = self.isServer,
		functions = class.Package.SerializeTable(self.functions),
		superPropertyContainer = class.Package.Classes.PropertyContainer.Serialize(self)
	}
end

function class:AddFunction(func)
	func = class.Package.Utils.Tests.GetArguments(
        {'', func} -- The name of the module.
    )
	--\Doc: Adds a function to the module.
	table.insert(self.functions, func)
end

function class:GetFunctions()
	--\Doc: Returns a list of the functions.
	return self.functions
end

function class:GetName()
	--\Doc: Returns the name of the module.
	return self.name
end

return class
