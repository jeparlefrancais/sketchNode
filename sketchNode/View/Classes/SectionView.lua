--\Description: This class manages the drawing of sections

local class = {
	__name = 'SectionView'
}

function class.Init()

end

function class.New(o, parent, sectionName)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	local folded = true

	o.ui = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Name = sectionName,
		Size = UDim2.new(1, 0, 0, 18),
		ClipsDescendants = true,
		Parent = parent,
		class.Package.Templates.VerticalList(0, "ListLayout")
	}
	o.ui.ListLayout.Changed:connect(function(property)
		if property == "AbsoluteContentSize" and not folded then
			o.ui.Size = UDim2.new(1, 0, 0, o.ui.ListLayout.AbsoluteContentSize.y)
		end
	end)

	local foldable = class.Package.Utils.Create'TextButton'{
		 BackgroundTransparency = 1,
		 Name = "Foldable",
		 Size = UDim2.new(1, 0, 0, 18),
		 Text = "",
		 Parent = o.ui
	}

	local foldImage = class.Package.Utils.Create'ImageLabel'{
		BackgroundTransparency = 1,
		Name = "Fold",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 18, 0, 18),
		Image = "rbxassetid://2006450498",
		ImageColor3 = Color3.fromRGB(193, 193, 193),
		Parent = foldable
	}

	local text = class.Package.Utils.Create'TextLabel'{
		BackgroundTransparency = 1,
		Name = sectionName,
		Position = UDim2.new(0, 18, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.SourceSans,
		Text = sectionName,
		TextColor3 = Color3.fromRGB(193, 193, 193),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = foldable
	}
	
	foldable.MouseButton1Click:connect(function()
		folded = not folded
		foldImage.Image = folded and "rbxassetid://2006450498" or "rbxassetid://2006451211"
		o.ui.Size = folded and UDim2.new(1, 0, 0, 18) or UDim2.new(1, 0, 0, o.ui.ListLayout.AbsoluteContentSize.y)
	end)

	-- temp
	class.Package.Utils.Create'ImageLabel'{
		Size = UDim2.new(0, 100, 0, 100),
		Parent = o.ui
	}
	return o
end

return class