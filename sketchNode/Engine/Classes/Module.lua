--\Description: Add a description

local class = {
	__name = 'Module'
}

function class.Init()
	class.__super = {class.Package.Classes.BaseObject}
	class.__signals = {
		FunctionAdded = {
			'Function' -- newFunction
		}
	}
end

function class.New(o, name, isServer) --\ReturnType: table
	name, isServer = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name of the module.
        {'boolean', isServer, true} -- If the module runs on the server or the client.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)

	class.Package.Classes.BaseObject.New(o, name)

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
	
	class.Package.Utils.Signal.SetSignals(class, o)

	class.Package.Classes.BaseObject.Load(o, data.superBaseObject)

	o.isServer = data.isServer
	o.functions = class.Package.LoadTable(data.functions, class.Package.Classes.Function)

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		isServer = self.isServer,
		functions = class.Package.SerializeTable(self.functions),
		superBaseObject = class.Package.Classes.BaseObject.Serialize(self)
	}
end

function class:AddFunction(func)
	--\Doc: Adds a function to the module.
	func = class.Package.Utils.Tests.GetArguments(
        {'Function', func} -- The function to add.
    )
	table.insert(self.functions, func)
	self.FunctionAdded:Fire(func)
end

function class:RemoveFunction(func) --\ReturnType: boolean
	--\Doc: Removes the function from the module. Returns true if the function was removed.
	func = class.Package.Utils.Tests.GetArguments(
        {'Function', func} -- The function to remove.
	)
	for i, currentFunc in pairs(self.functions) do
		if func == currentFunc then
			table.remove(self.functions, i)
			return true
		end
	end
	return false
end

function class:GetFunctions()
	--\Doc: Returns a list of the functions.
	return self.functions
end

return class
