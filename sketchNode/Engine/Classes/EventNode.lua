-- \Description: No description yet

local class = {
	__name = 'EventNode'
}

function class.Init()
	class.__super = {class.Package.Classes.Node}
	class.__signals = {}
end

function class.New(o, reference) --\ReturnType: table
	--\Doc: Creates a node to connect to a function.
	reference = class.Package.Utils.Tests.GetArguments(
		{'BaseReference', reference}, -- The function to call.
		{'number', x, 0}, -- The position on the x-axis of the node to create
		{'number', y, 0} -- The position on the y-axis of the node to create
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	--class.Package.Utils.Signal.SetSignals(class, o)
	
	class.Package.Classes.Node.New(o, x, y)
	
	o.referenceClass = reference:GetClassName()
	o.reference = reference
	
	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.Node.Load(o, data.superClass)
	--class.Package.Utils.Signal.SetSignals(class, o)

	o.referenceClass = data.referenceClass

	if data.referenceClass == 'LuaReference' then
		o.reference = class.Package.Classes.LuaReference.Load(o, data.referenceData)
	elseif data.referenceClass == 'ObjectReference' then
		o.reference = class.Package.Classes.ObjectReference.Load(o, data.referenceData)
	else
		warn(string.format('Data corrupted: Unexpected reference class <%s>', data.referenceClass))
	end

	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		referenceClass = self.referenceClass,
		referenceData = self.reference:Serialize(),
		superClass = class.Package.Classes.Node.Serialize(self)
	}
end

function class:GetReturnValues() --\ReturnType: table
	--\Doc: Returns a list of the values fired by the event, or returned by the function.
	return self.reference:GetReturnValues()
end

function class:GetTitle() --\ReturnType: string
	return self.reference:GetTitle()
end

function class:GetReference() --\ReturnType: BaseReference
	--\Doc: Returns the reference of the node.
	return self.reference
end

return class
