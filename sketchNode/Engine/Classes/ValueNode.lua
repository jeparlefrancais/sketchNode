-- \Description: No description yet

local class = {
	__name = 'ValueNode'
}

function class.Init()
	class.__super = {class.Package.Classes.Node}
	class.__signals = {}
end

function class.New(o, reference, x, y) --\ReturnType: table
	--\Doc: Creates a node to connect to a function.
	reference, x, y = class.Package.Utils.Tests.GetArguments(
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

function class:GetValueType() --\ReturnType: string
	--\Doc: Returns the type of the referenced value.
	return self.reference:GetValueType()
end

function class:IsInputReference() --\ReturnType: boolean
	--\Doc: Returns true if the reference inherits the InputReference class. In that case, the ValueView should allow the user to change the value.
	return self.reference:IsA('InputReference')
end

function class:SetInputCode(sourceCode)
	--\Doc: Sets the Lua source code to obtain that value.
	sourceCode = class.Package.Utils.Tests.GetArguments(
		{'string', sourceCode} -- The Lua source code that would create that value. 
	)
	if self:IsInputReference() then
		self.reference:SetInputCode(sourceCode)
	end
end

function class:GetInputCode() --\ReturnType: string
	return self:IsInputReference() and self.reference:GetInputCode() or nil
end

return class
