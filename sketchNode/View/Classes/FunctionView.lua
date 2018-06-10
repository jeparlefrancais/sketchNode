--\Description: This class is used to make function content for nodes

local class = {
	__name = 'FunctionView'
}

function class.Init()
	class.__super = {class.Package.Classes.NodeView}
end

function class.New(o, parent)
	parent = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent} -- The parent component.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.NodeView.New(o, parent)
	
	local triggers = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Triggers',
		Position = UDim2.new(0.5, 0, 0, 40),
		Size = UDim2.new(1, 0, 0, 40),
		ZIndex = 50
	}
		
	o.triggerInput = class.Package.Utils.Create'ImageLabel'{
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = 'Input',
		Position = UDim2.new(0, 5, 0, 5),
		Rotation = 90,
		Size = UDim2.new(0, 18, 0, 18),
		ZIndex = 50,
		Visible = false,
		Image = 'rbxassetid://1848975407',
		ImageColor3 = Color3.new(1, 1, 1);
		Parent = triggers
	}
		
	o.triggerOutput = class.Package.Utils.Create'ImageLabel'{
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Name = 'Input',
		Position = UDim2.new(1, -5, 0, 5),
		Rotation = 90,
		Size = UDim2.new(0, 18, 0, 18),
		ZIndex = 50,
		Visible = false,
		Image = 'rbxassetid://1848975407',
		ImageColor3 = Color3.new(1, 1, 1);
		Parent = triggers
	}
		
	local connectors = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Connectors',
		Position = UDim2.new(0.5, 0, 0, 40),
		Size = UDim2.new(1, 0, 0, 90), -- The Size is the highest column of parameters
		ZIndex = 50
	}
		
	o.inConnectors = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = 'In',
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		ZIndex = 50,
		Parent = connectors,
		class.Package.Utils.Create'UIListLayout'{SortOrder = Enum.SortOrder.LayoutOrder}
	}
	
	o.outConnectors = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = 'Out',
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, 0),
		ZIndex = 50,
		Parent = connectors,
		class.Package.Utils.Create'UIListLayout'{SortOrder = Enum.SortOrder.LayoutOrder}
	}
		
		class.Package.Classes.NodeView.SetContent(o, triggers)
		class.Package.Classes.NodeView.SetContent(o, connectors)
	
	return o
end

function class:SetTriggerInput(visible)
	visible = class.Package.Utils.Tests.GetArguments(
		{'boolean', visible, not self.triggerInput.Visible} -- The parent component.
	)
	self.triggerInput.Visible = visible
end

function class:SetTriggerOutput(visible)
	visible = class.Package.Utils.Tests.GetArguments(
		{'boolean', visible, not self.triggerOutput.Visible} -- The parent component.
	)
	self.triggerOutput.Visible = visible
end

return class