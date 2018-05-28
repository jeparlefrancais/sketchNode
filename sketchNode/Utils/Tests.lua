local module = {}

function module.Check(arg, typeString)
	local objectType = typeof(arg)
	return objectType == typeString or (objectType == 'Instance' and arg:IsA(typeString)) or (objectType == 'table' and typeof(object.IsA) == 'function' and object:IsA(typeString))
end

function module.Test(arg, typeString)
	if not module.Check(arg, typeString) then
		error(string.format('Bad argument given to function. Received type <%s> but expected <%s>', typeof(arg), typeString))
	else
		return true
	end
end

function module.GetArguments(...)
	local args = {...}
	local returnArgs = {}
	for i=1, #args do
		local argType, arg, defaultValue = unpack(args[i])
		if arg == nil and defaultValue ~= nil then
			arg = defaultValue
		end
		if argType ~= nil and argType ~= '' then
			module.Test(arg, argType)
		end
		returnArgs[i] = arg
	end
	return unpack(returnArgs)
end

return module
