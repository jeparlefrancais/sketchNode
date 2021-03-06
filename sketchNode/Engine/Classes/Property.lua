-- \Description: This class is meant to represent a property of a class or a module.

local class = {
	__name = 'Property'
}

function class.Init()
	class.__super = {
		class.Package.Classes.Argument,
		class.Package.Classes.AccessRestricted
	}
end

function class.New(o, name, typeString, defaultValue, canBeNil, access) --\ReturnType: table
    name, typeString, defaultValue, canBeNil, access = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name given to the property.
        {'string', typeString}, -- The type of the property.
        {'', defaultValue}, -- The default value of the property.
		{'boolean', canBeNil, false}, -- Allows the property to be nil.
		{'string', access, 'Private'} -- Public or private.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.Argument.New(o, name, typeString, defaultValue, canBeNil)
	class.Package.Classes.AccessRestricted.New(o, access)

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.Argument.Load(o, data.superArgument)
	class.Package.Classes.AccessRestricted.Load(o, data.superAccessRestricted)

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		superAccessRestricted = class.Package.Classes.AccessRestricted.Serialize(self),
		superArgument = class.Package.Classes.Argument.Serialize(self)
	}
end

return class
