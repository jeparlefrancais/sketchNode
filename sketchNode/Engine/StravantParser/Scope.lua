--\Description: Add a description

local class = {
	__name = 'Scope'
}

function class.Init()
	class.__super = nil
end

function class.New(o, parent) --\ReturnType: table
	--\Doc: Creates a Scope that has not any parent.
	parent = class.Package.Utils.Tests.GetArguments(
		{'table', parent} -- The scope parenting the new one.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.TopScope(o)
	
	o.Parent = parent
	table.insert(parent.Children, o)

	return o
end

function class.TopScope(o) --\ReturnType: table
	--\Doc: Creates a Scope that has not any parent.
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.Children = {}
	o.LocalList = {}
	o.LocalMap = {}
	o.Vars = {}

	return o
end

function class:Rename(name, newName)
	--\Doc: Renames a variable.
	name, newName = class.Package.Utils.Tests.GetArguments(
		{'string', name}, -- The variable that you want to rename.
		{'string', newName} -- The new name of the variable.
	)
	for _, localVar in pairs(self.LocalList) do
		if localVar.Name == name then
			localVar.Name = newName
		end
	end
	for _, var in pairs(self.Vars) do
		if var.Local and var.Local.Name == newName then
			var.Name = newName
		end
	end
	for _, subScope in pairs(self.Children) do
		subScope:Rename(name, newName)
	end
end

function class:GetLocal(name) --\ReturnType: table
	--\Doc: Gets the local variable with the given name.
	name = class.Package.Utils.Tests.GetArguments(
		{'string', name} -- The variable name
	)
	--first, try to get my variable 
	local my = self.LocalMap[name]
	if my then return my end

	--next, try parent
	if self.Parent then
		local par = self.Parent:GetLocal(name)
		if par then return par end
	end

	return nil
end

function class:AddVariable(var)
	--\Doc: Adds a variable to the scope variables list.
	table.insert(self.Vars, var)
end

function class:CreateLocal(name) --\ReturnType: table
	--\Doc: Adds a local variable to the scope local variables list. Only the variables created with the local keyword in that scope will be in that list.
	name = class.Package.Utils.Tests.GetArguments(
		{'string', name} -- The variable name
	)
	--create my own var
	local my = {}
	my.Scope = self
	my.Name = name
	my.CanRename = true
	--
	table.insert(self.LocalList, my)
	self.LocalMap[name] = my
	--
	return my
end

return class
