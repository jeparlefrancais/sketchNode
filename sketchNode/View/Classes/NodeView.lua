--\Description: This class manages the drawing of nodes

local TXT = game:GetService('TextService')

local class = {
	__name = 'NodeView'
}

function class.Init()

end

function class.New(o, parent, x , y)
    x, y = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
        {'number', x, 0}, -- The x component.
        {'number', y, 0} -- The y component.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	o.sections = {}

	o.ui = class.Package.Utils.Create'ImageButton'{
    	AnchorPoint = Vector2.new(0.5, 0.5),
    	BackgroundTransparency = 1,
    	BorderSizePixel = 0,
    	Name = 'NodeView',
    	Position = UDim2.new(0.5, x, 0.5, y),
		Size = UDim2.new(0, 270, 0, 350),
    	ZIndex = 20,
    	Image = 'rbxassetid://1840836042',
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(16, 16, 48, 48),
		Parent = parent
	}
	class.Package.Utils.Create'UISizeConstraint'{
    	MaxSize = Vector2.new(500,1000),
    	MinSize = Vector2.new(100,100),
    	Parent = o.ui
    }
  	local nodeTitle = class.Package.Utils.Create'ImageLabel' {
    	AnchorPoint = Vector2.new(0.5, 0),
    	BackgroundTransparency = 1,
    	Name = 'TitleBar',
    	Position = UDim2.new(0.5, 0, 0, 0),
    	Size = UDim2.new(1, 0, 0, 64),
    	ZIndex = 20,
    	Image = 'rbxassetid://1840881064',
    	ImageColor3 = Color3.fromRGB(200, 75, 75);
    	ScaleType = Enum.ScaleType.Slice;
    	SliceCenter = Rect.new(16, 16, 48, 48),
    	Parent = o.ui
    }
  	o.nodeTextLabel = class.Package.Utils.Create'TextLabel' {
    	AnchorPoint = Vector2.new(0.5, 0),
    	BackgroundTransparency = 1,
    	Name = 'NodeTitle',
    	Position = UDim2.new(0.5, 0, 0, 8),
    	Size = UDim2.new(0.9, -16, 1, -40),
    	ZIndex = 30,
    	Font = Enum.Font.SourceSansSemibold,
    	Text = 'NodeName',
    	TextColor3 = Color3.new(1,1,1),
    	TextScaled = true;
    	TextXAlignment = Enum.TextXAlignment.Left,
    	Parent = nodeTitle
    }
	o.content = class.Package.Utils.Create'Frame' {
    	AnchorPoint = Vector2.new(0.5, 0),
    	BackgroundTransparency = 1,
    	Name = 'Content',
    	Position = UDim2.new(0.5, 0, 0, 40),
    	Size = UDim2.new(1, -20, 0, 30),
    	ZIndex = 50,
    	Parent = o.ui
 	}
	 class.Package.Utils.Create'UIListLayout'{
    	SortOrder = Enum.SortOrder.LayoutOrder,
    	Parent = o.content
	}
	return o
end

function class:SetPosition(x, y)
    x, y = class.Package.Utils.Tests.GetArguments(
        {'number', x, 0}, -- The x component.
        {'number', y, 0} -- The y component.
    )
	self.ui.Position = UDim2.new(0.5, x, 0.5, y)
end

function class:AddSection(sectionName)
	--\Doc: Adds a new section to the node.
	sectionName = class.Package.Utils.Tests.GetArguments(
        {'string', sectionName}
	)
	local sectionData = {folded = false}
	sectionData.ui = class.Package.Utils.Create'Frame' {
    	AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
    	Name = sectionName,
		Size = UDim2.new(1, 0, 0, 90),
		ClipsDescendants = true,
		ZIndex = 50,
    	Parent = self.content
	}
	local layout = class.Package.Utils.Create'UIListLayout' {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = sectionData.ui
	}
	layout.Changed:connect(function(property)
		if property == "AbsoluteContentSize" and not sectionData.folded then
			sectionData.ui.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.y)
		end
	end)
	local foldable = class.Package.Utils.Create'TextButton' {
		 AnchorPoint = Vector2.new(0, 0),
		 BackgroundTransparency = 1,
		 Name = "Foldable",
		 Size = UDim2.new(1, 0, 0, 10),
		 ZIndex = 60,
		 Text = "",
		 Parent = sectionData.ui
	}
	local text = class.Package.Utils.Create'TextLabel' {
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
	local line = class.Package.Utils.Create'Frame' {
		AnchorPoint = Vector2.new(1, 0),
		BorderSizePixel = 0,
		Name = "Line",
		Position = UDim2.new(1, -20, 0, 5),
    	Size = UDim2.new(1, -30 - TXT:GetTextSize(sectionName, 18, Enum.Font.SourceSansItalic, Vector2.new(250, 20)).x, 0, 2),
		ZIndex = 50,
    	Parent = foldable
	}
	class.Package.Utils.Create'Frame' {
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		Name = "LineShadow",
		Position = UDim2.new(0, 0, 0, 2),
    	Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 50,
    	Parent = line
	}
	local foldImage = class.Package.Utils.Create'ImageLabel' {
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
		sectionData.folded = not sectionData.folded
		--foldImage.Rotation = sectionData.folded and -90 or 180
		if sectionData.folded then
			arrowFoldAnim:Play()
			sectionData.ui:TweenSize(UDim2.new(1,0,0,13), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		else
			arrowUnfoldAnim:Play()
			sectionData.ui:TweenSize(UDim2.new(1, 0, 0, layout.AbsoluteContentSize.y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		end
		--sectionData.ui.Size = sectionData.folded and UDim2.new(1,0,0,13) or UDim2.new(1, 0, 0, layout.AbsoluteContentSize.y)
	end)

	-- temp
	class.Package.Utils.Create'ImageLabel' {
		ZIndex = 60,
		Size = UDim2.new(0, 100, 0, 100),
		Parent = sectionData.ui
	}
	table.insert(self.sections, sectionData);
end

function class:ReorderSection(sectionName)
	--\Doc: Reorders the sections
	sectionName = class.Package.Utils.Tests.GetArguments(
        {'string', sectionName}
    )
end

function class:SetTitle(title)
	--\Doc: Sets the title of the node.
	title = class.Package.Utils.Tests.GetArguments(
        {'string', title}
    )
	self.nodeTextLabel.Text = title
end

function class:AddLine(line, sectionName)
  	--\Doc: Adds the line object to the NodeView in the given section
	--line:SetParent = self.ui
end

function class:MinimizeWidth()
	--\Doc: Iterate on all the lines and sets the width get the biggest 
end

return class
