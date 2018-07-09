--\Description: This class manages the drawing of nodes

local class = {
	__name = 'NodeView'
}

function class.Init()

end

function class.New(o, parent, node, triggers)
	parent, node, triggers = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'Node', node}, -- The node to represent.
		{'string', triggers, "none"} -- The triggers type.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.contentSizeConstraint = {}

	o.ui = class.Package.Templates.ImageLabel{
		AnchorPoint = Vector2.new(0, 0),
		Name = 'NodeView',
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, 270, 0, 350),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(16, 16, 48, 48),
		Parent = parent,
		class.Package.Utils.Create'UISizeConstraint'{Name = 'UISizeConstraint'}
	}
  	local nodeTitle = class.Package.Utils.Create'ImageButton'{ 
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'TitleBar',
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 64),
		ImageColor3 = Color3.fromRGB(200, 75, 75);
		ScaleType = Enum.ScaleType.Slice;
		SliceCenter = Rect.new(16, 16, 48, 48),
		Parent = o.ui
	}
	o.nodeIcon = class.Package.Utils.Create'ImageLabel'{
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 8),
		Name = "NodeIcon",
		Size = UDim2.new(0, 24, 0, 24),
		Image = "rbxassetid://2005814826",
		ImageRectSize = Vector2.new(24, 24),
		ImageTransparency = 0.3,
		Parent = nodeTitle,
	}
  	o.nodeTextLabel = class.Package.Utils.Create'TextLabel'{
		BackgroundTransparency = 1,
		Name = 'NodeTitle',
		Position = UDim2.new(0, 35, 0, 8),
		Size = UDim2.new(1, -80, 1, -40),
		Font = Enum.Font.SourceSansSemibold,
		Text = 'NodeName',
		TextSize = 28;
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = nodeTitle
	}
	o.content = class.Package.Templates.Container{
		AnchorPoint = Vector2.new(0.5, 0),
		Name = 'Content',
		Position = UDim2.new(0.5, 0, 0, 40),
		Size = UDim2.new(1, -20, 0, 30),
		Parent = o.ui
	}
	-- Setup for themes
	class.Package.Themes.Bind(o.ui, 'Image', 'NodeImage')
	class.Package.Themes.Bind(nodeTitle, 'Image', 'NodeTitleImage')
	class.Package.Themes.Bind(o.nodeTextLabel, 'TextColor3', 'NodeTitleTextColor')

	-- triggers
	if triggers ~= "none" then
		o.triggers = class.Package.Utils.Create'Frame'{
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			Name = 'Triggers',
			Position = UDim2.new(0.5, 0, 0, 40),
			Size = UDim2.new(1, 0, 0, 40),
			Parent = o.content,
		}
		if triggers == "both" or triggers == "input" then
			local inputTrigger = class.Package.Utils.Create'ImageLabel'{
				AnchorPoint = Vector2.new(0, 0),
				BackgroundTransparency = 1,
				Name = 'Input',
				Position = UDim2.new(0, 5, 0, 5),
				Size = UDim2.new(0, 36, 0, 27),
				Image = 'rbxassetid://2002751784',
				Parent = o.triggers,
			}
			class.Package.Themes.Bind(inputTrigger, 'ImageColor3', 'TriggerColor')
		end

		if triggers == "both" or triggers == "output" then
			local outputTrigger = class.Package.Utils.Create'ImageLabel'{
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Name = 'Output',
				Position = UDim2.new(1, -5, 0, 5),
				Size = UDim2.new(0, 36, 0, 27),
				Image = 'rbxassetid://2002751784',
				Parent = o.triggers,
			}
			class.Package.Themes.Bind(outputTrigger, 'ImageColor3', 'TriggerColor')
			outputTrigger.MouseButton1Down:Connect(function()
				local position = outputTrigger.AbsolutePosition + (.5 * outputTrigger.AbsoluteSize)
				class.Package.Grid.StartConnection(node, 0, false, position.X, position.Y)
			end)
			outputTrigger.MouseButton1Up:Connect(function(x, y)
				
			end)
		end
	end
	local listLayout = class.Package.Templates.ResponsiveList(
		false,
		Enum.HorizontalAlignment.Center,
		Enum.VerticalAlignment.Top,
		function(size)
			o.ui.Size = UDim2.new(0, size.X + 20, 0, size.Y + 55)
		end,
		0,
		o.content
	)

	node.PositionChanged:Connect(function(x, y)
		o:SetPosition(x, y)
	end)
	local currentPosition = node:GetPosition()
	o:SetPosition(currentPosition.X, currentPosition.Y, false)

	nodeTitle.MouseButton1Down:Connect(function(x, y)
		class.Package.Grid.StartNodeMovement(node, x, y)
	end)
	nodeTitle.MouseButton1Up:Connect(class.Package.Grid.SendMouseUp)

	return o
end

function class:AddConnector(parent, isOutput, typeString, nameString)
	parent, isOutput, typeString, nameString = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'boolean', isOutput},  -- The argument component.
		{'string', typeString},  -- The argument component.
		{'string', nameString}  -- The argument component.
	)
	class.Package.Classes.ConnectorView:New(parent, isOutput, typeString, nameString)
end

function class:SetPosition(x, y, tween)
	x, y, tween = class.Package.Utils.Tests.GetArguments(
		{'number', x}, -- The position on the x-axis.
		{'number', y}, -- The position on the y-axis.
		{'boolean', tween, true} -- If true, it will tweens the node to the given position.
	)
	if tween then
		self.ui:TweenPosition(UDim2.new(0.5, x, 0.5, y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .1, true)
	else
		self.ui.Position = UDim2.new(0.5, x, 0.5, y)
	end
end

function class:SetTitle(title)
	--\Doc: Sets the title of the node.
	title = class.Package.Utils.Tests.GetArguments(
		{'string', title}
	)
	self.nodeTextLabel.Text = title
	self.ui.UISizeConstraint.MinSize = Vector2.new(self.nodeTextLabel.TextBounds.X + 55, 0)
	for _, sizeConstraint in pairs(self.contentSizeConstraint) do
		sizeConstraint.MinSize = Vector2.new(self.content.AbsoluteSize.Y, 0)
	end
end

function class:SetContent(object)
	object = class.Package.Utils.Tests.GetArguments(
		{'Instance', object}
	)
	object.Parent = self.content
	-- local uiSize = class.Package.Utils.Create'UISizeConstraint'{
	-- 	Name = 'UISizeConstraint', 
	-- 	MinSize = Vector2.new(self.content.AbsoluteSize.X, 0),
	-- 	Parent = object
	-- }
end

function class:SetNodeIcon(nodeType)
	nodeType = class.Package.Utils.Tests.GetArguments(
		{'string', nodeType}
	)
	if nodeType == "function" then
		self.nodeIcon.ImageRectOffset = Vector2.new(0, 0)
	elseif nodeType == "value" then
		self.nodeIcon.ImageRectOffset = Vector2.new(24, 0)
	elseif nodeType == "event" then
		self.nodeIcon.ImageRectOffset = Vector2.new(48, 0)
	end
end

function class:ToggleCollapsed()
	--\Doc: Invisible the input/output
end

return class
