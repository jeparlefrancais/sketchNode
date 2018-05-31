local function IndexClass(class, key)
	if type(class[key]) == "function" then
		return class[key]
	else
		if class.__super ~= nil then
			for _, superClass in ipairs(class.__super) do
				local func = IndexClass(superClass, key)
				if func ~= nil then
					return func
				end
			end
		end
	end
end

return function(class)
	return setmetatable(
		{
			IsA = function(o, className)
				if className == class.__name then
					return true
				else
					for _, superClass in ipairs(class.__super or {}) do
						if superClass.__name == className then
							return true
						end
					end
					return false
				end
			end
		},
		{
			__index = function(t, key)
				return IndexClass(class, key)
			end
		}
	)
end
