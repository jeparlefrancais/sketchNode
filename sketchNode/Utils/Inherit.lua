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
					if class.__super then
						local parents = {}
						for _, superClass in ipairs(class.__super) do
							table.insert(parents, superClass)
						end
						local parent = table.remove(parents, 1)
						while parent do
							if parent.__name == className then
								return true 
							else 
								if parent.__super then
									for _, superClass in ipairs(parent.__super) do
										table.insert(parents, superClass)
									end
								end
							end
							parent = table.remove(parents, 1)
						end
					end
					return false
				end
			end,
			GetClassName = function()
				return class.__name
			end
		},
		{
			__index = function(t, key)
				return IndexClass(class, key)
			end
		}
	)
end
