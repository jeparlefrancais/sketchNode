--\Description: This class is used to make function content for nodes

local class = {
	__name = 'EventView'
}

function class.Init()
	class.__super = {class.Package.Classes.NodeView}
end

function class.New(o, parent, event)
	parent, event = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'EventNode', event}
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.NodeView.New(o, parent)
	
	o.triggers = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Triggers',
		Position = UDim2.new(0.5, 0, 0, 40),
		Size = UDim2.new(1, 0, 0, 40),
		ZIndex = 50,

		class.Package.Utils.Create'ImageLabel'{
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Name = 'Output',
			Position = UDim2.new(1, -5, 0, 5),
			Rotation = 90,
			Size = UDim2.new(0, 18, 0, 18),
			ZIndex = 50,
			Image = 'rbxassetid://1848975407',
			ImageColor3 = Color3.new(1, 1, 1)
		}
	}
	class.Package.Themes.Bind(o.triggers.Output, 'ImageColor3', 'TriggerColor')
		
	o.connectorContainer = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Connectors',
		Position = UDim2.new(0.5, 0, 0, 40),
		Size = UDim2.new(1, 0, 0, 90), -- The Size is the highest column of parameters
		class.Package.Templates.VerticalList(0, 'OutUIListLayout')
	}

	class.Package.Classes.NodeView.SetContent(o, o.triggers)
	class.Package.Classes.NodeView.SetContent(o, o.connectorContainer)

	o.connectorContainer.OutUIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		o.connectorContainer.Size = UDim2.new(1, 0, 0, o.connectorContainer.OutUIListLayout.AbsoluteContentSize.Y)
	end)

	for _, tv in ipairs(event:GetReturnValues()) do
		class.AddConnector(o, tv)
	end

	return o
end

function class:AddConnector(arg)
	arg = class.Package.Utils.Tests.GetArguments(
		{'TypedVariable', arg} -- The parent component.
	)
	class.Package.Classes.ConnectorView:New(self.connectorContainer, arg)
end

return class