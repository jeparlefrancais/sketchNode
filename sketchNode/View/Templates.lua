-- \Description: Useful templates to draw GUI

local module = {}

local function Merge(base, new)
	if new then
		for k, v in pairs(new) do
			base[k] = v
		end
		return base
	end
end

function module.CenterPoint(parent)
	return module.Package.Utils.Create'Frame'{
		BackgroundTransparency = 1,
		Name = 'CenterPoint',
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		Parent = parent
	}
end

function module.Container(properties)
	return module.Package.Utils.Create'Frame'(Merge({
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = 'Container',
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 50,
	}, properties))
end

-- function module.MinimalLabel(properties)
-- 	local text = Create'TextLabel'(merge bla bla bla)
	
-- 	text:GetPropertySignalChanged('Text'):Connect(function()
-- 		module.Package.Functions.MinizeLabel(text)
-- 	end
-- end

function module.MinimalText(text, properties)
	local textLabel = module.Package.Utils.Create'TextLabel'(Merge({
		BackgroundTransparency = 1,
		Name = 'MinimizedText',
		Text = text,
		TextSize = 18,
		ZIndex = 50,
	}, properties))

	module.Package.Functions.MinimizeTextLabel(textLabel)

	textLabel:GetPropertyChangedSignal('Text'):Connect(function()
		module.Package.Functions.MinimizeTextLabel(textLabel)
	end)

	return textLabel
end

function module.ImageLabel(properties)
	return module.Package.Utils.Create'ImageLabel'(Merge({
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 40,
	}, properties))
end

function module.ImageButton(properties)
	return module.Package.Utils.Create'ImageLabel'(Merge({
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 40,
	}, properties))
end

function module.HorizontalList(padding, rightAligned)
	return module.Package.Utils.Create'UIListLayout'{
		Padding = UDim.new(0, padding or 0),
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = rightAligned and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
	}
end

function module.VerticalList(padding, name)
	return module.Package.Utils.Create'UIListLayout'{
		Name = name or "VerticalListLayout",
		Padding = UDim.new(0, padding or 0),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	}
end

return module