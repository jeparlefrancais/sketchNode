--\Description: Add a description.

local class = {
	__name = 'Function'
}

function class.Init()
    class.__super = nil
end

function class.New(o, name, args, returnValues) --\ReturnType: table
    name, args, returnValues = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name of the function.
        {'table', args}, -- A list of the arguments.
        {'table', returnValues} -- A list of the returned values.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.name = name
	o.args = args -- Argument
	o.returnValues = returnValues -- TypedVariable
	o.source = ''

	return o
end

function class.Load(o, data) --\ReturnType: table
    --\Doc: Creates a new object with the given table.
    data = class.Package.Utils.Tests.GetArguments(
        {'table', data} -- Data from the Serialize method.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.name = data.name
	o.args = class.Package.LoadTable(data.args, class.Package.Classes.Argument) -- Argument
	o.returnValues = class.Package.LoadTable(data.returnValues, class.Package.Classes.TypedVariable) -- TypedVariable
	o.source = data.source

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		name = self.name,
		args = class.Package.SerializeTable(self.args),
		returnValues = class.Package.SerializeTable(self.returnValues),
		source = self.source
	}
end

function class:CheckArguments(...) --\ReturnType: boolean
	--\Doc: Takes all the given objects and checks if they matches each argument.
	local args = {...}
	for i, arg in pairs(o:GetArguments()) do
		if not arg:Check(args[i]) then
			return false
		end
	end
	return true
end

function class:CheckReturnedValues(...) --\ReturnType: boolean
	--\Doc: Takes all the given objects and checks if they matches each returned values.
	local values = {...}
	for i, typedVariable in pairs(o:GetArguments()) do
		if not typedVariable:Check(values[i]) then
			return false
		end
	end
	return true
end

function class:GetName() --\ReturnType: string
	--\Doc: Returns the name of the function.
	return self.name
end

function class:GetArguments() --\ReturnType: table
	--\Doc: Returns the list of the arguments.
	return self.args
end

function class:GetSource() --\ReturnType: string
	--\Doc: Returns the source code of the function.
	return self.source
end

function class:SetName(name)
	--\Doc: Sets the name of the function.
    name = class.Package.Utils.Tests.GetArguments(
        {'string', name}
    )
	self.name = name
end

function class:SetSource(source)
	--\Doc: Sets the source of the function.
	source = class.Package.Utils.Tests.GetArguments(
        {'string', source}
    )
	self.source = source
end

return class
