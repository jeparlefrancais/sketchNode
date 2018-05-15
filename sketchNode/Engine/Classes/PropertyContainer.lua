-- \Description: This is a class to allow basic insertion or deletion of properties.

local class = {
	__name = 'PropertyContainer'
}

function class.Init()
	class.__super = nil
	class.__signals = {
		PropertyAdded = {
			'', -- newProperty
		}
	}
end

function class.New(o) --\ReturnType: table
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Utils.Signal.SetSignals(class, o)
	
	o.properties = {}

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
    if o == class then o = class.Package.Utils.Inherit(class) end
    
	class.Package.Utils.Signal.SetSignals(class, o)

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
    property = class.Package.Utils.Tests.GetArguments(
        {'', property} -- Data from the Serialize method.
    )
	table.insert(self.properties, property)
	self.PropertyAdded:Fire(property)
end

return class
