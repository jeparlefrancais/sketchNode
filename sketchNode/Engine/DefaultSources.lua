--\Description: This module contains some default scripts that can be used by the engine.

local module = {}

module.Tests = [[
return function(obj, stringType)
	local objectType = typeof(obj)
	return objectType == typeString or (objectType == 'Instance' and arg:IsA(typeString)) or (objectType == 'table' and typeof(obj.IsA) == 'function' and obj:IsA(typeString))
end
]]

return module
