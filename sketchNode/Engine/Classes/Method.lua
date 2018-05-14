--\Description: Add a description.

local class = {
	__name = 'Method'
}

function class.Init()
	class.__super = {class.Package.Classes.Function}
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

    class.Package.Classes.Function.New(o, name, args, returnValues)
	o.access = access
	o.abstract = abstract

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end
	
    class.Package.Classes.Function.Load(o, data.superFunction)
	o.access = data.access
	o.abstract = data.abstract

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		access = self.access,
		abstract = self.abstract,
		superFunction = class.Package.Classes.Function.Serialize(self)
	}
end

function class:IsAbstract() --\ReturnType: boolean
	--\Doc: Returns if the method is asbtract or not.
	return self.abstract
end

function class:GetAccess() --\ReturnType: string
	--\Doc: Returns the access of the method.
	return self.access
end

return class
