local class = {
	__name = 'Service'
}

function class.Init()
	class.__super = {class.Package.Classes.Node}
end

function class.New(o, name, x, y)
    if o == class then o = class.Package.Utils.Inherit(class) end
	if x == nil then x = 0 end
	if y == nil then y = 0 end

    class.Package.Classes.Node.New(o, x, y)
    
	o.name = name
	local success = pcall( function()
		return game:GetService(name)
	end)
	--o.service = service

	return o
end

return class
