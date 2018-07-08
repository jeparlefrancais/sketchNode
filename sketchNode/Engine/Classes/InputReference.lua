-- \Description: No description yet.

local class = {
	__name = 'LuaReference'
}

function class.Init()
	class.__super = {class.Package.Classes.BaseReference}
	class.__signals = {

	}
end

function class.New(o, typeString) --\ReturnType: table
	--\Doc: Reference to a user provided value.
	typeString = class.Package.Utils.Tests.GetArguments(
		{'string', typeString} -- The type of the value.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.BaseReference.New(o)
	
	o.typeString = typeString
	o.inputSourceCode = 'nil'
	
	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.BaseReference.Load(o, data.superClass)
	
	o.typeString = data.typeString
	o.inputSourceCode = data.inputSourceCode

	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		typeString = self.typeString,
		inputSourceCode = self.inputSourceCode,
		superClass = class.Package.Classes.BaseReference.Serialize(self)
	}
end

function class:GetTitle() --\ReturnType: string
	return string.format('%s', self.typeString)
end

function class:GetArguments() --\ReturnType: table
	--\Doc: Returns the arguments of the function. If the reference is not to a function, it returns an empty list. 
	return {}
end

function class:GetReturnValues() --\ReturnType: table
	--\Doc: Returns the return values of the function. If the reference is not to a function, it returns an empty list. 
	return {}
end

function class:GetValueType() --\ReturnType: string
	return self.typeString
end

function class:IsFunction() --\ReturnType: boolean
	--\Doc: Returns if the reference is a function
	return false
end

function class:IsEvent() --\ReturnType: boolean
	--\Doc: Returns if the reference is an event. Always false for a LuaReference.
	return false
end

function class:IsValue() --\ReturnType: boolean
	--\Doc: Returns if the reference is a value.
	return true
end

function class:SetInputCode(sourceCode)
	--\Doc: Sets the source code that represents the value.
	sourceCode = class.Package.Utils.Tests.GetArguments(
		{'string', sourceCode} -- The Lua code to obtain that value. (i.e. '"value"' or '9.2' or '{5, 2, 3, 4}')
	)
	self.inputSourceCode = sourceCode
end

function class:GetInputCode() --\ReturnType: string
	--\Doc: Returns the source code that represents the value.
	return self.inputSourceCode
end

return class
