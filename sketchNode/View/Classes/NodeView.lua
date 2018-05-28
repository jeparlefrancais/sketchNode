--\Description: This class manages the drawing of nodes

local class = {
	__name = 'NodeView'
}

function class.Init()

end

function class.New(o, x , y)
    x, y = class.Package.Utils.Tests.GetArguments(
        {'number', x, 0}, -- The x component.
        {'number', y, 0} -- The y component.
    )
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	o.ui = module.Package.Utils.Create'ImageButton'{
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
	}
	module.Package.Utils.Create'UISizeConstraint'{
    	MaxSize = Vector2.new(500,1000),
    	MinSize = Vector2.new(100,100),
    	Parent = o.ui
    }
  	local nodeTitle = module.Package.Utils.Create'ImageLabel' {
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
  	o.nodeTextLabel = module.Package.Utils.Create'TextLabel' {
    	AnchorPoint = Vector2.new(0.5, 0),
    	BackgroundTransparency = 1,
    	Name = 'NodeTitle',
    	Position = UDim2.new(0.9, -16, 1, -40),
    	Size = UDim2.new(1, 0, 0, 64),
    	ZIndex = 30,
    	Font = Enum.Font.SourceSansSemibold,
    	Text = 'NodeName',
    	TextColor = Color3.new(1,1,1),
    	TextScaled = true;
    	TextXAlignment = Enum.TextXAlignment.Left,
    	Parent = nodeTitle
    }
	o.content = module.Package.Utils.Create'Frame' {
    	AnchorPoint = Vector2.new(0.5, 0),
    	BackgroundTransparency = 1,
    	Name = 'Content',
    	Position = UDim2.new(0.5, 0, 0, 40),
    	Size = UDim2.new(1, -20, 0, 30),
    	ZIndex = 50,
    	Parent = o.ui
 	}
	module.Package.Utils.Create'UIListLayout'{
    	Padding = Vector2.new(0, 0),
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
	newSection = module.Package.Utils.Create'Frame' {
    	AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
    	Name = sectionName,
    	Size = UDim2.new(1, 0, 0, 90),
		ZIndex = 50,
    	Parent = o.ui
 	}
	foldable = module.Package.Utils.Create'TextButton' {
		 AnchorPoint = Vector2.new(0, 0),
		 BackgroundTransparency = 1,
		 Name = "Foldable",
		 Size = UDim2.new(1, 0, 0, 10),
		 ZIndex = 60,
		 Text = "",
		 Parent = newSection
	}
	line = module.Package.Utils.Create'Frame' {
		AnchorPoint = Vector2.new(0, 0),
		BorderSizePixel = 0,
		Name = "Line",
		Position = UDim2.new(0, 0, 0, 5),
    	Size = UDim2.new(1, -20, 0, 2),
		ZIndex = 50,
    	Parent = foldable
 	}
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
