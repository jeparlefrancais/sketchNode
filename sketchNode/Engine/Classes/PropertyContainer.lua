-- \Description: This is a class to allow basic insertion or deletion of properties.

local class = {
	__name = 'PropertyContainer'
}

function class.Init()
	class.__super = nil
end

function class.New(o) --\ReturnType: table
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	o.properties = {}

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end
    
	o.properties = class.Package.LoadTable(data.properties, class.Package.Classes.Property)

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		properties = class.Package.SerializeTable(self.properties)
	}
end

function class:AddProperty(property)
	--\Doc: Adds a property to the container.
	table.insert(self.properties, property)
end

return class
