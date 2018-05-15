--\Description: Allow basic getter and setter for a name. 

local class = {
	__name = 'Named'
}

function class.Init()
	class.__super = nil
	class.__signals = {
		NameChanged = {
			'string' -- newName
		}
	}
end

function class.New(o, name) --\ReturnType: table
	name = class.Package.Utils.Tests.GetArguments(
        {'string', name} -- The name given to the object.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)

	o.name = name

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)

	o.name = data.name

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		name = self.name
	}
end

function class:GetName() --\ReturnType: string
	--\Doc: Returns the name of the object.
	return self.name
end

function class:SetName(name)
	--\Doc: Changes the name of the object.
	name = class.Package.Utils.Tests.GetArguments(
        {'string', name} -- The name given to the object.
	)
	self.name = name
	self.NameChanged:Fire(name)
end

return class
