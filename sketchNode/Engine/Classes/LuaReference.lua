-- \Description: This class is meant to make it easy to get informations about the lua built-in functions (tostring, tonumber, the math and string libraries).

local class = {
	__name = 'LuaReference'
}

function class.Init()
	class.__super = {class.Package.Classes.BaseReference}
	class.__signals = {

	}
end

function class.New(o, referenceName) --\ReturnType: table
	--\Doc: Create a reference to a built-in function in lua.
	referenceName = class.Package.Utils.Tests.GetArguments(
		{'string', referenceName} -- The name that references to a Lua built-in function or value. See the LuaMetadata module for the reference names.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.BaseReference.New(o)
	
	o.referenceName = referenceName
	
	o:GetReferenceInfo()
	
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

	o.referenceName = data.referenceName

	o:GetReferenceInfo()

	return o
end

function class:GetReferenceInfo()
	--\Doc: Updates the members of the object.
	self.isFunction = class.Package.LuaMetadata.IsFunction(self.referenceName)
	if class.Package.LuaMetadata.IsFunction(self.referenceName) then
		self.func = class.Package.LuaMetadata.GetFunction(self.referenceName)
		if not self.func then
			warn(string.format('LuaReference to function <%s> returns nil', self.referenceName))
		end
	else
		self.valueType = class.Package.LuaMetadata.GetValueType(self.referenceName)
	end
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		referenceName = self.referenceName,
		superClass = class.Package.Classes.BaseReference.Serialize(self)
	}
end

function class:GetTitle() --\ReturnType: string
	return string.format('%s', self.referenceName)
end

function class:GetArguments() --\ReturnType: table
	--\Doc: Returns the arguments of the function. If the reference is not to a function, it returns an empty list. 
	if self.func then
		return self.func:GetArguments()
	else
		return {}
	end
end

function class:GetReturnValues() --\ReturnType: table
	--\Doc: Returns the return values of the function. If the reference is not to a function, it returns an empty list. 
	if self.func then
		return self.func:GetReturnValues()
	else
		return {}
	end
end

function class:GetValueType() --\ReturnType: string
	return self.valueType
end

function class:IsFunction() --\ReturnType: boolean
	--\Doc: Returns if the reference is a function
	return self.isFunction
end

function class:IsEvent() --\ReturnType: boolean
	--\Doc: Returns if the reference is an event. Always false for a LuaReference.
	return false
end

function class:IsValue() --\ReturnType: boolean
	--\Doc: Returns if the reference is a value.
	return not self.isFunction
end

return class
