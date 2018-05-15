--\Description: Add a description.

local class = {
	__name = 'Method'
}

function class.Init()
	class.__super = {
		class.Package.Classes.Function,
		class.Package.Classes.AccessRestricted
	}
	class.__signals = {
		AbstractChanged = {
			'boolean' -- isAbstract
		}
	}
end

function class.New(o, name, args, returnValues, access, abstract) --\ReturnType: table
    name, args, returnValues, access, abstract = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name of the method.
        {'table', args}, -- A list of the arguments.
        {'table', returnValues}, -- A list of the returned values.
        {'table', access, 'Public'}, -- The method access.
        {'table', abstract, false} -- If the method is abstract or not.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)

	class.Package.Classes.Function.New(o, name, args, returnValues)
    class.Package.Classes.AccessRestricted.Load(o, data.superAccessRestricted)
	
	o.abstract = abstract

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Utils.Signal.SetSignals(class, o)

    class.Package.Classes.Function.Load(o, data.superFunction)
    class.Package.Classes.AccessRestricted.Load(o, data.superAccessRestricted)
	o.abstract = data.abstract

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		abstract = self.abstract,
		superFunction = class.Package.Classes.Function.Serialize(self),
		superAccessRestricted = class.Package.Classes.AccessRestricted.Serialize(self)
	}
end

function class:IsAbstract() --\ReturnType: boolean
	--\Doc: Returns if the method is asbtract or not.
	return self.abstract
end

function class:SetAbstract(isAbstract)
    --\Doc: Changes if the method is abstract or not.
    isAbstract = class.Package.Utils.Tests.GetArguments(
        {'boolean', isAbstract} -- The new value.
	)
	self.asbtract = isAbstract
	self.AbstractChanged:Fire(isAbstract)
end

return class
