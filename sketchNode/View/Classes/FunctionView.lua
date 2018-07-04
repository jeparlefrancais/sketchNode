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
	
	class.Package.Classes.NodeView.New(o, parent, funcNode, "both")
	
	o.connectorContainer = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Name = 'Connectors',
		Position = UDim2.new(0.5, 0, 0, 40),
		class.Package.Utils.Create'Frame'{
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			Name = 'In',
			Position = UDim2.new(0, 0, 0, 0)
		},
		class.Package.Utils.Create'Frame'{
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Name = 'Out',
			Position = UDim2.new(1, 0, 0, 0)
		}
	}
	local outLayout
	local inLayout = class.Package.Templates.ResponsiveList(
		false,
		Enum.HorizontalAlignment.Left,
		Enum.VerticalAlignment.Top,
		function(inputSize)
			local maxHeight = math.max(inputSize.Y, outLayout.AbsoluteContentSize.Y)
			o.connectorContainer.In.Size = UDim2.new(0, inputSize.X, 0, maxHeight)
			local width = math.max(inputSize.X + o.connectorContainer.Out.Size.X.Offset + 20, o:GetMinimumWidth())
			o.connectorContainer.Size = UDim2.new(0, width, 0, maxHeight)
		end,
		0,
		o.connectorContainer.In
	)
	outLayout = class.Package.Templates.ResponsiveList(
		false,
		Enum.HorizontalAlignment.Right,
		Enum.VerticalAlignment.Top,
		function(outputSize)
			local maxHeight = math.max(inLayout.AbsoluteContentSize.Y, outputSize.Y)
			o.connectorContainer.Out.Size = UDim2.new(0, outputSize.X, 0, maxHeight)
			local width = math.max(outputSize.X + o.connectorContainer.In.Size.X.Offset + 20, o:GetMinimumWidth())
			o.connectorContainer.Size = UDim2.new(0, width, 0, maxHeight)
		end,
		0,
		o.connectorContainer.Out
	)

	for _, arg in ipairs(funcNode:GetArguments()) do
		o:AddConnector(o.connectorContainer.In, false, arg:GetType(), arg:GetName())
	end
	for _, tv in ipairs(funcNode:GetReturnValues()) do
		o:AddConnector(o.connectorContainer.Out, true, tv:GetType(), tv:GetName())
	end

	o:SetContent(o.connectorContainer)
	o:SetTitle(funcNode:GetTitle())
	o:SetNodeIcon("function")

	return o
end

return class