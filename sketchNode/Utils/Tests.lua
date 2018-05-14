local module = {}

function module.Check(arg, typeString)
	local objectType = typeof(arg)
	return objectType == typeString or (objectType == 'Instance' and object:IsA(self.typeString))
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
	print('')
	for i=1, #args do
--	for i, tuple in pairs(args) do
		local argType, arg, defaultValue = unpack(args[i])
		print('getting tuple', argType, arg, defaultValue, i)
		if arg == nil and defaultValue ~= nil then
			print('Setting default value from', argType, arg, defaultValue, i)
			arg = defaultValue
		end
		if argType ~= nil and argType ~= '' then
			module.Test(arg, argType)
		end
		print(' ->', arg)
		returnArgs[i] = arg
		--table.insert(returnArgs, arg)
		print('Now t=', unpack(returnArgs))
	end
	print('')
	return unpack(returnArgs)
end

return module
