-- \Description: No description yet

local class = {
	__name = 'FunctionNode'
}

function class.Init()
	class.__super = {class.Package.Classes.EventNode}
	class.__signals = {}
end

function class.New(o, reference, x, y) --\ReturnType: table
	--\Doc: Creates a node to connect to a function.
	reference = class.Package.Utils.Tests.GetArguments(
		{'BaseReference', reference}, -- The function to call.
		{'number', x, 0}, -- The position on the x-axis of the node to create
		{'number', y, 0} -- The position on the y-axis of the node to create
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	--class.Package.Utils.Signal.SetSignals(class, o)
	
	class.Package.Classes.EventNode.New(o, reference, x, y)
	
	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.EventNode.Load(o, data.superClass)
	--class.Package.Utils.Signal.SetSignals(class, o)
	
	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		superClass = class.Package.Classes.EventNode.Serialize(self)
	}
end

function class:GetArguments() --\ReturnType: table
	--\Doc: Returns a list of the arguments of the function.
	return self.reference:GetArguments()
end

function class:GetTitle() --\ReturnType: string
	return self.reference:GetTitle()
end

function class:GetReference() --\ReturnType: BaseReference
	--\Doc: Returns the reference of the node.
	return self.reference
end

return class
