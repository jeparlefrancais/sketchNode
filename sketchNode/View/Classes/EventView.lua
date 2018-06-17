--\Description: This class is used to make function content for nodes

local class = {
	__name = 'EventView'
}

function class.Init()
	class.__super = {class.Package.Classes.NodeView}
end

function class.New(o, parent, func)
	parent, func = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'Function', func}
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
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Name = 'Input',
			Position = UDim2.new(0, 5, 0, 5),
			Rotation = 90,
			Size = UDim2.new(0, 18, 0, 18),
			ZIndex = 50,
			Image = 'rbxassetid://1848975407',
			ImageColor3 = Color3.new(1, 1, 1)
		},

		class.Package.Utils.Create'ImageLabel'{
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Name = 'Input',
			Position = UDim2.new(1, -5, 0, 5),
			Rotation = 90,
			Size = UDim2.new(0, 18, 0, 18),
			ZIndex = 50,
			Image = 'rbxassetid://1848975407',
			ImageColor3 = Color3.new(1, 1, 1)
		}
	}
		
	o.connectorContainer = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Connectors',
		Position = UDim2.new(0.5, 0, 0, 40),
		Size = UDim2.new(1, 0, 0, 90), -- The Size is the highest column of parameters
		
		class.Package.Utils.Create'Frame'{
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Name = 'In',
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
			class.Package.Templates.VerticalList(0, 'InUIListLayout')
		},
	
		class.Package.Utils.Create'Frame'{
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Name = 'Out',
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
			ZIndex = 50,
			class.Package.Templates.VerticalList(0, 'OutUIListLayout')
		}
	}

	class.Package.Classes.NodeView.SetContent(o, o.triggers)
	class.Package.Classes.NodeView.SetContent(o, o.connectorContainer)

	o.connectorContainer.In.InUIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		local maxHeight = math.max(o.connectorContainer.In.InUIListLayout.AbsoluteContentSize.Y, o.connectorContainer.Out.OutUIListLayout.AbsoluteContentSize.Y)
		o.connectorContainer.Size = UDim2.new(1, 0, 0, maxHeight)
	end)

	for _, arg in ipairs(func:GetArguments()) do
		class.AddConnector(o, arg)
	end
	for _, tv in ipairs(func:GetReturnValues()) do
		class.AddConnector(o, tv)
	end

	return o
end

function class:SetTriggerInput(visible)
	visible = class.Package.Utils.Tests.GetArguments(
		{'boolean', visible, not self.triggerInput.Visible} -- The parent component.
	)
	self.triggers.Input.Visible = visible
end

function class:SetTriggerOutput(visible)
	visible = class.Package.Utils.Tests.GetArguments(
		{'boolean', visible, not self.triggerOutput.Visible} -- The parent component.
	)
	self.triggers.Output.Visible = visible
end

function class:AddConnector(arg)
	arg = class.Package.Utils.Tests.GetArguments(
		{'TypedVariable', arg} -- The parent component.
	)
	class.Package.Classes.ConnectorView:New(self.connectorContainer, arg)
end

return class