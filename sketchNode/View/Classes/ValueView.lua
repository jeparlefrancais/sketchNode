--\Description: This class is used to make value inputs content for nodes

local class = {
	__name = 'ValueView'
}

function class.Init()
	class.__super = {class.Package.Classes.NodeView}
end

function class.New(o, parent, valueNode)
	parent, valueNode = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'ValueNode', valueNode}
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.NodeView.New(o, parent, valueNode, "none")
	
	o.connectorContainer = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Connectors',
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0, 40, 0, 90), -- The Size is the highest column of parameters
	}

	local outLayout = class.Package.Templates.ResponsiveList(
		false,
		Enum.HorizontalAlignment.Right,
		Enum.VerticalAlignment.Top,
		function(outputSize)
			local width = math.max(outputSize.X + 20, o:GetMinimumWidth())
			o.connectorContainer.Size = UDim2.new(0, width, 0, outputSize.Y)
		end,
		0,
		o.connectorContainer
	)
	
	o:SetContent(o.connectorContainer)

	o:AddConnector(o.connectorContainer, true, valueNode:GetValueType(), valueNode:GetConnectorName())

	o:SetTitle(valueNode:GetTitle())
	o:SetNodeIcon("value")

	return o
end

return class