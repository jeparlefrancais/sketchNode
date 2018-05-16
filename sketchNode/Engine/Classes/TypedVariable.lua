-- \Description: This class is meant to represent a typed variable.

local class = {
    __name = 'TypedVariable'
}

function class.Init()
    class.__super = {class.Package.Classes.Named}
	class.__signals = {
		TypeChanged = {
			'string' -- newTypeString
		},
		CanBeNilChanged = {
			'boolean' -- canBeNil
		}
	}
end

function class.New(o, name, typeString, canBeNil) --\ReturnType: table
    name, typeString, canBeNil = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name given to the variable.
        {'string', typeString}, -- The type of the variable.
        {'boolean', canBeNil, false} -- Allow the variable to be nil.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end

    class.Package.Classes.Named.New(o, name)
    o.typeString = typeString
    o.canBeNil = canBeNil

    return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end

    class.Package.Classes.Named.Load(o, data.superNamed)
	o.name = data.name
	o.typeString = data.typeString
    o.canBeNil = data.canBeNil
    
    return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		typeString = self.typeString,
		canBeNil = self.canBeNil,
		superNamed = class.Package.Classes.Named.Serialize(self)
	}
end

function class:Check(object) --\ReturnType: boolean
    --\Doc: Returns true if the given object matches with the variable type.
	local objectType = typeof(object)
	return objectType == self.typeString or (self.canBeNil and object == nil) or (objectType == 'Instance' and object:IsA(self.typeString))
end

function class:GetType() --\ReturnType: string
    --\Doc: Returns the type of the variable.
    return self.typeString
end

function class:GetCanBeNil() --\ReturnType: boolean
    --\Doc: Returns true if the variable is allowed to be nil.
    return self.canBeNil
end

function class:SetType(typeString)
    --\Doc: Changes the type of the variable.
    typeString = self.Package.Utils.Tests.GetArguments('string', typeString)
    self.typeString = typeString
    self.TypeChanged:Fire(typeString)
end

function class:SetCanBeNil(canBeNil)
    --\Doc: Sets if the variable is allowed to be nil.
    canBeNil = self.Package.Utils.Tests.GetArguments('boolean', canBeNil)
    self.canBeNil = canBeNil
    self.CanBeNilChanged:Fire(canBeNil)
end

return class
