--\Description: This class manages

local class = {
	__name = 'LineView'
}

function class.Init()

end

function class.New(o)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	-- ici construit le ui
	o.ui = class.Package.Utils.Create'Frame'{
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30)
	}
	o.inputConnector = class.Package.Utils.Create'ImageLabel'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Name = "InputConnectorStroke",
		Position = UDim2.new(0, -4, 0.5, 0),
		Size = UDim2.new(0, 20, 0 , 20),
		ZIndex = 40,
		Visible = false,
		Image = "rbxassetid://1840922184",
		ImageColor3 = Color3.fromRGB(39, 39, 39),
		Parent = o.ui
	}
	class.Package.Utils.Create'ImageButton'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Name = "InputConnector",
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.7, 0, 0.7, 0),
		ZIndex = 40,
		Image = "rbxassetid://1841010009",
		ImageColor3 = Color3.fromRGB(137, 180, 137),
		Parent = o.inputConnector
	}
	o.outputConnector = class.Package.Utils.Create'ImageLabel'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Name = "OutputConnectorStroke",
		Position = UDim2.new(1, 4, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		ZIndex = 40,
		Visible = false,
		Image = "rbxassetid://1840922184",
		ImageColor3 = Color3.fromRGB(39, 39, 39),
		Parent = o.ui
	}
	class.Package.Utils.Create'ImageButton'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Name = "OutputConnector",
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.7, 0, 0.7, 0),
		ZIndex = 40,
		Image = "rbxassetid://1841010009",
		ImageColor3 = Color3.fromRGB(137, 180, 137),
		Parent = o.outputConnector
	}
	return o
end

function class:SetInput(state)
	--\Doc: Shows the input button
	state = class.Package.Utils.Tests.GetArguments(
		{'boolean', state}
	)
	o.inputConnector.Visible = state
end

function class:SetOutput(state)
	--\Doc: Shows the output button
	state = class.Package.Utils.Tests.GetArguments(
		{'boolean', state}
	)
	o.outputConnector.Visible = state
end

return class
