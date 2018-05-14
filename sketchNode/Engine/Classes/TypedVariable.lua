-- \Description: This class is meant to represent a typed variable.

local class = {
    __name = 'TypedVariable'
}

function class.Init()
    class.__super = nil
end

function class.New(o, name, typeString, canBeNil) --\ReturnType: table
    name, typeString, canBeNil = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name given to the variable.
        {'string', typeString}, -- The type of the variable.
        {'boolean', canBeNil, false} -- Allow the variable to be nil.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end

    o.name = name
    o.typeString = typeString
    o.canBeNil = canBeNil

    return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = self.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end

	o.name = data.name
	o.typeString = data.typeString
    o.canBeNil = data.canBeNil
    
    return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		name = self.defaultValue,
		typeString = self.typeString,
		canBeNil = self.canBeNil
	}
end

function class:Check(object) --\ReturnType: boolean
    --\Doc: Returns true if the given object matches with the variable type.
	local objectType = typeof(object)
	return objectType == self.typeString or (self.canBeNil and object == nil) or (objectType == 'Instance' and object:IsA(self.typeString))
end

function class:GetName() --\ReturnType: string
    --\Doc: Returns the name of the variable.
	return self.name
end

function class:GetType() --\ReturnType: string
    --\Doc: Returns the type of the variable.
    return self.typeString
end

function class:GetCanBeNil() --\ReturnType: boolean
    --\Doc: Returns true if the variable is allowed to be nil.
    return self.canBeNil
end

function class:SetName(name)
    --\Doc: Renames the variable.
    name = self.Package.Utils.Tests.GetArguments(
        {'string', name} -- The new name of the variable.
    )
    self.name = name
end

function class:SetType(typeString)
    --\Doc: Changes the type of the variable.
    typeString = self.Package.Utils.Tests.GetArguments('string', typeString)
    self.typeString = typeString
end

function class:SetCanBeNil(canBeNil)
    --\Doc: Sets if the variable is allowed to be nil.
    canBeNil = self.Package.Utils.Tests.GetArguments('boolean', canBeNil)
    self.canBeNil = canBeNil
end

return class
