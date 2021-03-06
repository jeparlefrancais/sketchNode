--\Description: This class represents a class in the game itself.

local class = {
	__name = 'Class'
}

function class.Init()
	class.__super = {
		class.Package.Classes.BaseObject
	}
	class.__signals = {
		MethodAdded = {
			'Method' -- newMethod
		},
		AddInheritance = {
			'Class' -- parentClass
		},
		AbstractChanged = {
			'boolean' -- isAbstract
		}
	}
end

function class.New(o, name) --\ReturnType: table
    name = class.Package.Utils.Tests.GetArguments(
        {'string', name} -- The new name of the variable.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)

	class.Package.Classes.BaseObject.New(o, name)
	
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

	class.Package.Utils.Signal.SetSignals(class, o)

	class.Package.Classes.BaseObject.Load(o, data.superBaseObject)
	
	o.methods = class.Package.LoadTable(data.methods, class.Package.Classes.Method)
	o.inherits = {}
	o.inherited = {}

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		methods = class.Package.SerializeTable(self.methods),
		superBaseObject = class.Package.Classes.BaseObject.Serialize(self)
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
    method = class.Package.Utils.Tests.GetArguments(
        {'Method', method} -- Method to add.
	)
	local wasAbstract = self:IsAbstract()
	table.insert(self.methods, method)
	self.MethodAdded:Fire(method)
	if not wasAbstract then
		if method:IsAbstract() then
			self.AbstractChanged:Fire(true)
		end
	end
end

function class:RemoveMethod(method) --\ReturnType: boolean
	--\Doc: Removes the method from the class. Returns true if the method was removed.
    method = class.Package.Utils.Tests.GetArguments(
        {'Method', method} -- Method to add.
	)
	local wasAbstract = self:IsAbstract()
	for i, currentMethod in pairs(self.methods) do
		if method == currentMethod then
			table.remove(self.methods, i)
			if wasAbstract and not self:IsAbstract() then
				self.AbstractChanged:Fire(false)
			end
			return true
		end
	end
	return false
end

function class:Inherits(parentClass)
	--\Doc: The parent-child relation is set on each classes.
    parentClass = class.Package.Utils.Tests.GetArguments(
        {'Class', parentClass} -- Method to add.
	)
	table.insert(self.inherits, parentClass)
	parentClass:AddChildClass(self)
	self.AddInheritance:Fire(parentClass)
end

function class:AddChildClass(childClass)
	--\Doc: The current class becomes a parent of the given class. This function should not be used, instead use Class:Inherits.
	childClass = class.Package.Utils.Tests.GetArguments(
		{'Class', childClass} -- The child class that inherits the actual class.
	)
	table.insert(self.inherited, childClass)
end

function class:GetMethods() --\ReturnType: list
	--\Doc: Returns a list of all the methods.
	return self.methods
end

return class
