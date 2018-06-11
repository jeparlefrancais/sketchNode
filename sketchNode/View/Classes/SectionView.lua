--\Description: This class manages the drawing of sections

local TXT = game:GetService('TextService')

local class = {
	__name = 'SectionView'
}

function class.Init()

end

function class.New(o, parent, sectionName)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	local folded = false
	o.ui = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Name = sectionName,
		Size = UDim2.new(1, 0, 0, 90),
		ClipsDescendants = true,
		ZIndex = 50,
		Parent = parent
	}
	local layout = class.Package.Utils.Create'UIListLayout'{
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = o.ui
	}
	layout.Changed:connect(function(property)
		if property == "AbsoluteContentSize" and not folded then
			o.ui.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.y)
		end
	end)
	local foldable = class.Package.Utils.Create'TextButton'{
		 AnchorPoint = Vector2.new(0, 0),
		 BackgroundTransparency = 1,
		 Name = "Foldable",
		 Size = UDim2.new(1, 0, 0, 10),
		 ZIndex = 60,
		 Text = "",
		 Parent = o.ui
	}
	local text = class.Package.Utils.Create'TextLabel'{
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = "SectionName",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		ZIndex = 50,
		Font = Enum.Font.SourceSansItalic,
		Text = sectionName,
		TextColor3 = Color3.fromRGB(193, 193, 193),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = foldable
	}
	local line = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(1, 0),
		BorderSizePixel = 0,
		Name = "Line",
		Position = UDim2.new(1, -20, 0, 5),
		Size = UDim2.new(1, -30 - TXT:GetTextSize(sectionName, 18, Enum.Font.SourceSansItalic, Vector2.new(250, 20)).x, 0, 2),
		ZIndex = 50,
		Parent = foldable
	}
	class.Package.Utils.Create'Frame'{
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		Name = "LineShadow",
		Position = UDim2.new(0, 0, 0, 2),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 50,
		Parent = line
	}
	local foldImage = class.Package.Utils.Create'ImageLabel'{
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Name = "Fold",
		Position = UDim2.new(1, -2, 0, 0),
		Rotation = -180,
		Size = UDim2.new(0, 12, 0, 12),
		ZIndex = 50,
		Image = "rbxassetid://1848975407",
		ImageColor3 = Color3.fromRGB(193, 193, 193),
		Parent = foldable
	}

	local arrowFoldAnim = class.Package.Functions.GetAnimation(foldImage, .4, {Rotation = -90})
	local arrowUnfoldAnim = class.Package.Functions.GetAnimation(foldImage, .4, {Rotation = -180})
	foldable.MouseButton1Click:connect(function()
		folded = not folded
		if folded then
			arrowFoldAnim:Play()
			o.ui:TweenSize(UDim2.new(1,0,0,13), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
		else
			arrowUnfoldAnim:Play()
			o.ui:TweenSize(UDim2.new(1, 0, 0, layout.AbsoluteContentSize.y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
		end
	end)

	-- temp
	class.Package.Utils.Create'ImageLabel'{
		ZIndex = 60,
		Size = UDim2.new(0, 100, 0, 100),
		Parent = o.ui
	}
	return o
end

return class