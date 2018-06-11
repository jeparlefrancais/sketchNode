return [[
return function(obj, stringType)
	local objectType = typeof(obj)
	return objectType == typeString or (objectType == 'Instance' and arg:IsA(typeString)) or (objectType == 'table' and typeof(obj.IsA) == 'function' and obj:IsA(typeString))
end
]]