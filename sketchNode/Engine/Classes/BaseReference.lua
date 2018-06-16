--\Description: Add a description

local class = {
	__name = 'BaseReference'
}

function class.Init()
	class.__super = nil
end

function class.New(o) --\ReturnType: table
	if o == class then o = class.Package.Utils.Inherit(class) end

	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
	}
end

function class:GetTitle()
	error(string.format('GetTitle() method is not defined in class <%s>',  self:GetClassName()))
end

function class:GetArguments()
	error(string.format('GetArguments() method is not defined in class <%s>',  self:GetClassName()))
end

function class:GetReturnValues()
	error(string.format('GetReturnValues() method is not defined in class <%s>',  self:GetClassName()))
end

function class:IsFunction() --\ReturnType: boolean
	error(string.format('IsFunction() method is not defined in class <%s>',  self:GetClassName()))
end

function class:IsEvent() --\ReturnType: boolean
	error(string.format('IsEvent() method is not defined in class <%s>',  self:GetClassName()))
end

function class:IsValue() --\ReturnType: boolean
	error(string.format('IsValue() method is not defined in class <%s>',  self:GetClassName()))
end

return class
