--\Description: An argument is a TypedVariable with a default value. 

local class = {
	__name = 'Argument'
}

function class.Init()
	class.__super = {class.Package.Classes.TypedVariable}
	class.__signals = {
		DefaultValueChanged = {
			'', -- newDefaultValue
		}
	}
end

function class.New(o, name, typeString, defaultValue, canBeNil) --\ReturnType: table
	name, typeString, defaultValue, canBeNil = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name given to the argument.
        {'string', typeString}, -- The type of the argument.
        {'', defaultValue}, -- The default value of the argument.
        {'boolean', canBeNil, false} -- Allows the argument to be nil.
	)
    if o == class then o = class.Package.Utils.Inherit(class) end
    
	class.Package.Utils.Signal.SetSignals(class, o)

	class.Package.Classes.TypedVariable.New(o, name, typeString, canBeNil)

	o.defaultValue = defaultValue

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

    class.Package.Utils.Signal.SetSignals(class, o)
    
	class.Package.Classes.TypedVariable.Load(o, data.superClass)
	o.defaultValue = data.defaultValue

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		defaultValue = self.defaultValue,
		superClass = class.Package.Classes.TypedVariable.Serialize(self)
	}
end

function class:GetDefaultValue() --\ReturnType: any
	--\Doc: Returns the default value of the argument.
	return self.defaultValue
end

function class:SetDefaultValue(defaultValue)
	--\Doc: Sets the default value of the argument.
	self.defaultValue = defaultValue
	self.DefaultValueChanged:Fire(defaultValue)
end

return class
