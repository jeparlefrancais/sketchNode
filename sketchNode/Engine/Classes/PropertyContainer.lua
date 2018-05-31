-- \Description: This is a class to allow basic insertion or deletion of properties.

local class = {
	__name = 'PropertyContainer'
}

function class.Init()
	class.__super = nil
	class.__signals = {
		PropertyAdded = {
			'Property', -- newProperty
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

function class:RemoveProperty(property) --\ReturnType: boolean
	--\Doc: Removes the property from the container. Returns true if the property was removed.
    property = class.Package.Utils.Tests.GetArguments(
        {'', property} -- The property to remove.
	)
	for i, currentProperty in pairs(self.properties) do
		if currentProperty == property then
			table.remove(self.properties, i)
			return true
		end
	end
	return false
end

function class:GetProperties() --\ReturnType: table
	--\Doc: Returns the list of properties.
	return self.properties
end

return class
