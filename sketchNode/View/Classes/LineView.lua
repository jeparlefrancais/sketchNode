--\Description: This class manages

local class = {
	__name = 'LineView'
}

function class.Init()

end

function class.New(o)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	-- ici construit le ui
	--o.ui = 
	
	return o
end

function class:ShowInput()
	--\Doc: Shows the input button
end

return class
