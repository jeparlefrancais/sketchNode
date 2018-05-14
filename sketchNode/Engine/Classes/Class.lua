--\Description: This class represents a class in the game itself.

local class = {
	__name = 'Class'
}

function class.Init()
	class.__super = {class.Package.Classes.PropertyContainer}
end

function class.New(o, name) --\ReturnType: table
    name = self.Package.Utils.Tests.GetArguments(
        {'string', name} -- The new name of the variable.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.PropertyContainer.New(o)
	
	o.name = name
	o.methods = {}
	o.inherits = {}
	o.inherited = {}

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.PropertyContainer.Load(o, data.superPropertyContainer)

	o.name = name
	o.methods = class.Package.LoadTable(data.methods, class.Package.Classes.Method)
	o.inherits = {}
	o.inherited = {}

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		name = self.name,
		methods = class.Package.SerializeTable(self.methods),
		superPropertyContainer = class.Package.Classes.PropertyContainer.Serialize(self)
	}
end

function class:IsAbstract() --\ReturnType: boolean
    --\Doc: Returns true if the class is abstract (meaning it contains at least one abstract method).
	for _, method in ipairs(self.methods) do
		if method:IsAbstract() then
			return true
		end
	end
	return false
end

function class:GetInheritedMethods() --\ReturnType: table
    --\Doc: Returns a list of dictionnaries for each inherited method. Each dictionnary has a 'Method' and 'Class' key.
	local methodClassPairs = {}
	for _, parentClass in ipairs(self.inherits) do
		for _, method in ipairs(parentClass:GetMethods()) do
			if method:GetAccess() ~= 'Private' then
				table.insert({Method = method, Class = parentClass})
			end
		end
	end
	return methodClassPairs
end

function class:AddMethod(method)
	--\Doc: Adds a method to the class.
	table.insert(self.methods, method)
end

function class:Inherits(parentClass)
	table.insert(self.inherits, parentClass)
	parentClass:AddChildClass(self)
end

function class:AddChildClass(childClass)
	table.insert(self.inherited, childClass)
end

function class:GetMethods() --\ReturnType: list
	--\Doc: Returns a list of all the methods.
	return self.methods
end

function class:GetName() --\ReturnType: string
	--\Doc: Returns the name of the class.
	return self.name
end

return class
