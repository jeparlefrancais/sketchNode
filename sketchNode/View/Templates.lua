-- \Description: Useful templates to draw GUI

local module = {}

local function Merge(base, new)
	if new then
		for k, v in pairs(new) do
			base[k] = v
		end
	end
	return base
end

function module.Container(properties)
	return module.Package.Utils.Create'Frame'(Merge({
		BackgroundTransparency = 1,
		Name = 'Container',
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}, properties))
end

function module.ScrollingContainer(properties)
	return module.Package.Utils.Create'ScrollingFrame'(Merge({
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = 'Container',
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ScrollBarThickness = 6,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, properties))
end

function module.MinimalText(text, properties)
	local textLabel = module.Package.Utils.Create'TextLabel'(Merge({
		BackgroundTransparency = 1,
		Name = 'MinimizedText',
		Text = text,
		TextSize = 18,
	}, properties))

	module.Package.Functions.MinimizeTextLabel(textLabel)

	textLabel:GetPropertyChangedSignal('Text'):Connect(function()
		module.Package.Functions.MinimizeTextLabel(textLabel)
	end)

	return textLabel
end

function module.ImageLabel(properties)
	return module.Package.Utils.Create'ImageLabel'(Merge({
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}, properties))
end

function module.IconImage(properties)
	return module.Package.Utils.Create'ImageButton'(Merge({
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 16, 0, 16),
	}, properties))
end

function module.IconButton(properties)
	return module.Package.Utils.Create'ImageButton'(Merge({
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 18, 0, 18),
	}, properties))
end

function module.ImageButton(properties)
	return module.Package.Utils.Create'ImageButton'(Merge({
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}, properties))
end

function module.ClickButton(localizationText, properties)
	local button = module.Package.Utils.Create'ImageButton'(Merge({
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0.45, 0, 1, 0),
		Image = 'rbxassetid://1858994698',
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(24, 24, 40, 40),

		module.Package.Utils.Create'TextLabel'{
			Name = 'Label',
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = 24,
		}
	}, properties))
	module.Package.Localization.Bind(button.Label, localizationText)
	button.MouseEnter:connect(function()
		button.ImageTransparency = 0.2
	end)
	button.MouseLeave:connect(function()
		button.ImageTransparency = 0.5
	end)
	return button
end

function module.HorizontalList(padding, rightAligned, centered)
	return module.Package.Utils.Create'UIListLayout'{
		Padding = UDim.new(0, padding or 0),
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = centered or Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = rightAligned and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
	}
end

function module.ResponsiveList(isHorizontal, horizontalAlignment, verticalAlignment, sizeChangedFunction, padding, parent)
	local listLayout = module.Package.Utils.Create'UIListLayout'{
		Padding = UDim.new(0, padding or 0),
		FillDirection = isHorizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Center,
		VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Center,
		Parent = parent
	}
	listLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() sizeChangedFunction(listLayout.AbsoluteContentSize) end)
	return listLayout
end

function module.SectionButton(properties)
	local sectionButton = module.Package.Utils.Create'TextButton'(Merge({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Font = Enum.Font.SourceSans,
		TextColor3 = Color3.fromRGB(193, 193, 193),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, properties))
	sectionButton.MouseEnter:connect(function()
		sectionButton.BackgroundTransparency = 0.9
	end)
	sectionButton.MouseLeave:connect(function()
		sectionButton.BackgroundTransparency = 1
	end)

	return sectionButton
end

function module.VerticalList(padding, name)
	return module.Package.Utils.Create'UIListLayout'{
		Name = name or "VerticalListLayout",
		Padding = UDim.new(0, padding or 0),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}
end

function module.RightVerticalList(padding, name)
	return module.Package.Utils.Create'UIListLayout'{
		Name = name or "VerticalListLayout",
		Padding = UDim.new(0, padding or 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder
	}
end

return module
