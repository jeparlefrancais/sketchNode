--\Description: This class manages the drawing of sections

local class = {
	__name = 'SectionView'
}

function class.Init()

end

function class.New(o, parent, sectionName, sortByName)
	parent, sectionName, sortByName = class.Package.Utils.Tests.GetArguments(
		{'GuiObject', parent}, -- The parent of the SectionView UI.
		{'string', sectionName}, -- The name of the section (sets the title of the section).
		{'boolean', sortByName, false} -- Orders the elements by name or by the insertion order.
	)
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
		class.Package.Templates.RightVerticalList(0, "RightListLayout")
	}
	o.ui.RightListLayout.Changed:connect(function(property)
		if property == "AbsoluteContentSize" and not folded then
			o.ui.Size = UDim2.new(1, 0, 0, o.ui.RightListLayout.AbsoluteContentSize.y)
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

	o.container = class.Package.Utils.Create'Frame'{
		BackgroundTransparency = 1,
		Name = 'Container',
		Size = UDim2.new(1, -30, 0, 18),
		Parent = o.ui,
	}
	local listLayout = class.Package.Templates.VerticalList(2, "ListLayout")
	listLayout.SortOrder = sortByName and Enum.SortOrder.Name or Enum.SortOrder.LayoutOrder
	listLayout.Parent = o.container

	listLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		--if not folded then
			o.container.Size = UDim2.new(1, -30, 0, listLayout.AbsoluteContentSize.Y)
		--end
	end)

	foldable.MouseButton1Click:connect(function()
		listLayout:ApplyLayout()
		folded = not folded
		foldImage.Image = folded and "rbxassetid://2006450498" or "rbxassetid://2006451211"
		o.ui.Size = folded and UDim2.new(1, 0, 0, 18) or UDim2.new(1, 0, 0, o.ui.RightListLayout.AbsoluteContentSize.y)
	end)

	return o
end

function class:AddElement(guiObject)
	--\Doc: Adds a GuiObject into the container
	guiObject = class.Package.Utils.Tests.GetArguments(
		{'GuiObject', guiObject} -- The GuiObject to add into the container.
	)
	guiObject.LayoutOrder = #self.container:GetChildren()
	guiObject.Name = string.lower(guiObject.Name)
	guiObject.Parent = self.container
end

function class:AddFooter(guiObject)
	--\Doc: Adds a GuiObject at the bottom of the section					
	guiObject = class.Package.Utils.Tests.GetArguments(
		{'GuiObject', guiObject} -- The GuiObject to add at the bottom of the section
	)
	guiObject.Parent = self.ui
	guiObject.LayoutOrder = 1000
end

return class