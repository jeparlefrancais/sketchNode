--\Description: Add a description

local class = {
	__name = 'BaseObject'
}

function class.Init()
	class.__super = {
		class.Package.Classes.Named,
		class.Package.Classes.PropertyContainer,
		class.Package.Classes.Node
	}
end

function class.New(o, name) --\ReturnType: table
	name = class.Package.Utils.Tests.GetArguments(
        {'string', name} -- The name of the object.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.Named.New(o, name)
	class.Package.Classes.PropertyContainer.New(o)
    class.Package.Classes.Node.New(o)

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.Named.Load(o, data.superNamed)
	class.Package.Classes.PropertyContainer.Load(o, data.superPropertyContainer)
	class.Package.Classes.Node.Load(o, data.superNode)

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		superNamed = class.Package.Classes.Named.Serialize(self),
		superPropertyContainer = class.Package.Classes.PropertyContainer.Serialize(self),
		superNode = class.Package.Classes.Node.Serialize(self)
	}
end



return class
