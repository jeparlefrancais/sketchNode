--\Description: Add a description

local class = {
	__name = 'Enumeration'
}

function class.Init()
	class.__super = nil
end

function class.New(o, name, elements) --\ReturnType: table
	name, elements = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name given to the enumeration.
        {'table', elements} -- The list of strings in the enumeration.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end
    
	o.name = name
	o.elements = elements

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.name = data.name
	o.elements = data.elements

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		name = self.name,
		elements = self.elements
	}
end

function class:Exists(element) --\ReturnType: boolean
	--\Doc: Returns true if the given string exists
	stringElement = class.Package.Utils.Tests.GetArguments(
        {'string', stringElement} -- The string to test.
    )
	for _, element in ipairs(self.elements) do
		if element == stringElement then
			return true
		end
	end
	return false
end

function class:AddElement(element)
	--\Doc: Adds a new element to the enumeration
	element = class.Package.Utils.Tests.GetArguments(
        {'string', element} -- The string to test.
	)
	for _, existing in ipairs(self.elements) do
		if existing == element then
			return
		end
	end
	table.insert(self.elements, element)
end

function class:GetName() --\ReturnType: string
	--\Doc: Returns the name of the enumeration.
	return self.name
end

return class
