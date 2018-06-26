--\Description: This class manages the drawing of nodes

local class = {
	__name = 'NodeView'
}

function class.Init()

end

function class.New(o, parent, triggers)
	parent, triggers = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'string', triggers, "none"} -- The triggers type.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.ui = class.Package.Templates.ImageButton{
		AnchorPoint = Vector2.new(0, 0),
		Name = 'NodeView',
		Position = UDim2.new(0, x, 0, y),
		Size = UDim2.new(0, 270, 0, 350),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(16, 16, 48, 48),
		Parent = parent
	}
  	local nodeTitle = class.Package.Utils.Create'ImageLabel'{ 
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
  	o.nodeTextLabel = class.Package.Utils.Create'TextLabel'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'NodeTitle',
		Position = UDim2.new(0.5, 0, 0, 8),
		Size = UDim2.new(0.9, -16, 1, -40),
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
		Parent = o.ui,
		class.Package.Templates.VerticalList(0, 'VerticalListLayout')
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
		end
	end
	
	o.content.VerticalListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		o.ui.Size = UDim2.new(0, 270, 0, 60 + o.content.VerticalListLayout.AbsoluteContentSize.Y)
	end)

	return o
end

function class:SetPosition(x, y)
	x, y = class.Package.Utils.Tests.GetArguments(
		{'number', x, 0}, -- The x component.
		{'number', y, 0} -- The y component.
	)
	self.ui.Position = UDim2.new(0.5, x, 0.5, y)
end

function class:SetTitle(title)
	--\Doc: Sets the title of the node.
	title = class.Package.Utils.Tests.GetArguments(
		{'string', title}
	)
	self.nodeTextLabel.Text = title
end

function class:SetContent(object)
	object = class.Package.Utils.Tests.GetArguments(
		{'Instance', object}
	)
	object.Parent = self.content
end

function class:ToggleCollapsed()
	--\Doc: Invisible the input/output
end

return class
