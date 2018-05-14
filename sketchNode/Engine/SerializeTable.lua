local HTTP = game:GetService("HttpService")

return function(list)
	local content = {}
	for _, element in ipairs(list) do
		table.insert(content, element.Serialize())
	end
	return HTTP:JSONEncode(content)
end
