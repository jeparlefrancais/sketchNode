local HTTP = game:GetService("HttpService")

return function(data, class)
	if class == nil then
		error("Can not load table if class is not provided.")
	end
	local content = {}
	for _, element in ipairs(data) do
		table.insert(content, class.Load(element))
	end
	return content
end
