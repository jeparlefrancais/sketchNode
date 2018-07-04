--\Description: This class is used to make function content for nodes

local class = {
	__name = 'EventView'
}

function class.Init()
	class.__super = {class.Package.Classes.NodeView}
end

function class.New(o, parent, eventNode)
	parent, eventNode = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'EventNode', eventNode}
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	class.Package.Classes.NodeView.New(o, parent, eventNode, "output")
	
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
		Enum.VerticalAlignment.Center,
		function(outputSize)
			o.connectorContainer.Size = UDim2.new(0, outputSize.X, 0, outputSize.Y)
		end,
		0,
		o.connectorContainer
	)

	o:SetContent(o.connectorContainer)

	for _, tv in ipairs(eventNode:GetReturnValues()) do
		o:AddConnector(o.connectorContainer, true, tv:GetType(), tv:GetName())
	end

	o:SetTitle(eventNode:GetTitle())
	o:SetNodeIcon("event")

	return o
end

return class