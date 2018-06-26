--\Description: This class is used to make function content for nodes

local class = {
	__name = 'FunctionView'
}

function class.Init()
	class.__super = {class.Package.Classes.NodeView}
end

function class.New(o, parent, funcNode)
	parent, funcNode = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'FunctionNode', funcNode}
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.NodeView.New(o, parent, "both")
	
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

	o.connectorContainer.In.InUIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		local maxHeight = math.max(o.connectorContainer.In.InUIListLayout.AbsoluteContentSize.Y, o.connectorContainer.Out.OutUIListLayout.AbsoluteContentSize.Y)
		o.connectorContainer.Size = UDim2.new(1, 0, 0, maxHeight)
	end)
	o.connectorContainer.Out.OutUIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		local maxHeight = math.max(o.connectorContainer.In.InUIListLayout.AbsoluteContentSize.Y, o.connectorContainer.Out.OutUIListLayout.AbsoluteContentSize.Y)
		o.connectorContainer.Size = UDim2.new(1, 0, 0, maxHeight)
	end)

	for _, arg in ipairs(funcNode:GetArguments()) do
		o:AddConnector(arg, o.connectorContainer:FindFirstChild('In'))
	end
	for _, tv in ipairs(funcNode:GetReturnValues()) do
		o:AddConnector(tv, o.connectorContainer:FindFirstChild('Out'))
	end

	o:SetContent(o.connectorContainer)
	o:SetTitle(funcNode:GetTitle())

	return o
end

function class:AddConnector(arg, parent)
	arg = class.Package.Utils.Tests.GetArguments(
		{'TypedVariable', arg} -- The parent component.
	)
	class.Package.Classes.ConnectorView:New(parent, arg)
end

return class