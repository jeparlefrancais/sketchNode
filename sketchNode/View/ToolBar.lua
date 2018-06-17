-- \Description: Module to draw the top bar

local TXT = game:GetService("TextService")

local module = {
	buttons = {}
}

function module.Start(parent)
	--\Doc: Setup the grid.
	parent = module.Package.Utils.Tests.GetArguments(
		{'GuiBase', parent}
	)

	local topBar = module.Package.Utils.Create'Frame'{
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Name = "ToolBar",
		Size = UDim2.new(1, 0, 0, 26),
		ZIndex = 100,
		Parent = parent
	}
	module.leftContainer = module.Package.Utils.Create'Frame'{
		BackgroundTransparency = 1,
		Name = "LeftContainer",
		Size = UDim2.new(1, 0, 1, 0),
		Parent = topBar
	}
	module.Package.Utils.Create'UIListLayout'{
		Padding = UDim.new(0, 3),
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = module.leftContainer
	}
	module.rightContainer = module.Package.Utils.Create'Frame'{
		BackgroundTransparency = 1,
		Name = "RightContainer",
		Size = UDim2.new(1, 0, 1, 0),
		Parent = topBar
	}
	module.Package.Utils.Create'UIListLayout'{
		Padding = UDim.new(0, 3),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = module.rightContainer
	}
end

function module.CreateButton(name, icon, stickLeft, func)
	module.buttons[name] = {
		Enabled = true,
		Button = button,
		Function = func
	}
	local Parent = stickLeft and module.leftContainer or module.rightContainer
	local textSize = TXT:GetTextSize(string.upper(name), 14, Enum.Font.SourceSans, Vector2.new(500, 500))
	local button = module.Package.Utils.Create'TextButton'{
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 0,
		Name = name .. "Button",
		Size = UDim2.new(0, textSize.x + 35, 1, 0),
		Text = "",
		Parent = Parent
	}
	local buttonText = module.Package.Utils.Create'TextLabel'{
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Name = "ButtonText",
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(1, -20, 1, 0),
		Font = Enum.Font.SourceSans,
		Text = string.upper(name),
		TextColor3 = Color3.fromRGB(248, 248, 248),
		TextSize = 14,
		Parent = button
	}
	local iconLabel = module.Package.Utils.Create'ImageLabel'{
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 4, 0, 4),
		Size = UDim2.new(0, 18, 0, 18),
		Image = module.Package.ViewSettings.Icons[icon] or "",
		Parent = button,
	}
	local buttonReady = true
	button.MouseButton1Click:connect(function()
		buttonReady = false
		if buttonReady and module.buttons[name].Enabled then
			module.buttons[name].Function()
		end
		wait()
		buttonReady = true
	end)
end

function module:CreateSeparator()
	local categorySpacer = module.Package.Utils.Create'Frame'{
		BackgroundTransparency = 1,
		Name = "CategorySpacer",
		Size = UDim2.new(0, 10, 1, 0),
		Parent = module.toolBar
	}
	module.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color.fromRGB(49, 49, 49),
		BorderSizePixel = 0,
		Name = "Line",
		Position = UDim2.new(0.3, 0, 0.5),
		Size = UDim2.new(0, 2, 0.8, 0),
		Parent = categorySpacer
	}
	module.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color.fromRGB(49, 49, 49),
		BorderSizePixel = 0,
		Name = "Line",
		Position = UDim2.new(0.7, 0, 0.5),
		Size = UDim2.new(0, 2, 0.8, 0),
		Parent = categorySpacer
	}
end

return module
