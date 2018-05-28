--\Description: Add a description.

local class = {
	__name = 'Function'
}

function class.Init()
	class.__super = {class.Package.Classes.Named}
	class.__signals = {
		ArgumentAdded = {
			'Argument' -- newArgument
		},
		ArgumentOrderChanged = {
			'table' -- argumentList
		}
	}
end

function class.New(o, name, args, returnValues) --\ReturnType: table
    name, args, returnValues = class.Package.Utils.Tests.GetArguments(
        {'string', name}, -- The name of the function.
        {'table', args}, -- A list of the arguments.
        {'table', returnValues} -- A list of the returned values.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Classes.Named.New(o, name)

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

	class.Package.Classes.Named.Load(o, data.superNamed)

	o.args = class.Package.LoadTable(data.args, class.Package.Classes.Argument) -- Argument
	o.returnValues = class.Package.LoadTable(data.returnValues, class.Package.Classes.TypedVariable) -- TypedVariable
	o.source = data.source

	return o
end

function class:Serialize() --\ReturnType: table
    --\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		args = class.Package.SerializeTable(self.args),
		returnValues = class.Package.SerializeTable(self.returnValues),
		source = self.source,
		superNamed = class.Package.Classes.Named.Serialize(self)
	}
end

function class:AddArgument(argument)
	--\Doc: Adds a new argument.
    argument = class.Package.Utils.Tests.GetArguments(
        {'Argument', argument} -- The argument to add.
    )
	table.insert(self.args, argument)
	self.ArgumentAdded:Fire(argument)
end

function class:RemoveArgument(argument) --\ReturnType: boolean
	--\Doc: Removes the argument. Returns true if the argument was removed.
    argument = class.Package.Utils.Tests.GetArguments(
        {'Argument', argument} -- The argument to add.
    )
	for i, arg in pairs(self.args) do
		if arg == argument then
			table.remove(self.args, i)
			self.ArgumentOrderChanged:Fire(self:GetArguments())
			return true
		end
	end
	return false
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

function class:GetArguments() --\ReturnType: table
	--\Doc: Returns the list of the arguments.
	return self.args
end

function class:GetSource() --\ReturnType: string
	--\Doc: Returns the source code of the function.
	return self.source
end

function class:SetSource(source)
	--\Doc: Sets the source of the function.
	source = class.Package.Utils.Tests.GetArguments(
        {'string', source}
    )
	self.source = source
end

function class:GetScriptHeader(escapeChars) --\ReturnType: string
	--\Doc: Returns the header used when opening the script in the editor.
	escapeChars = class.Package.Utils.Tests.GetArguments(
        {'boolean', escapeChars, false}
    )
	local arguments = {}
	local totalArguments = #self.args
	for i, arg in pairs(self.args) do
		table.insert(arguments, arg:GetName() .. (i ~= totalArgument and ', ' or ''))
	end
	if escapeChars then
		return 'function ' .. self:GetName() .. '%(' .. table.concat(arguments) .. '%)'
	else
		return string.format('function %s(%s)', self:GetName(), table.concat(arguments))
	end
end

function class:GetEditingSource() --\ReturnType: string
	local arguments = {}
	local totalArguments = #self.args
	for i, arg in pairs(self.args) do
		table.insert(arguments, arg:GetName() .. (i ~= totalArgument and ', ' or ''))
	end
	return string.format([[%s
%s
end
]], self:GetScriptHeader(), self.source)
end

function class:EditSource()
	--\Doc: Opens a script to edit this function
	if self.editingScript == nil then
		self.editingScript = Instance.new('Script')
		self.editingScript.Source = self:GetEditingSource()
		self.editingScript.Changed:Connect(function(property)
			if property == 'Source' then
				local source = string.match(self.editingScript.Source, '^' .. self:GetScriptHeader(true) .. '%s(.*)%send%s*$')
				if source == nil then
					self.editingScript.Source = self:GetEditingSource()
				else
					self:SetSource(source)
				end
			end
		end)
	end
	self.editingScript.Name = self:GetName()
	class.Package.ScriptEditor.OpenScript(self.editingScript, 2)
end

return class
