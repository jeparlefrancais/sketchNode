--\Description: This is a super class for connector types (TypedVariableView and ArgumentView)

local TXT = game:GetService('TextService')

local class = {
	__name = 'ConnectorView'
}

local function GetConnectorColor(typedVariable)
	typedVariable = class.Package.Utils.Tests.GetArguments(
		{'TypedVariable', typedVariable}
	)
	if typedVariable:IsA('Argument') then
		if typedVariable:GetDefaultValue() ~= nil then
			return Color3.fromRGB(95, 180, 105) -- il y a une valeur par default alors cest chill
		else
			if typedVariable:GetCanBeNil() then -- if its NEEDED
				return Color3.fromRGB(80, 147, 218) -- ca peut etre nil donc c'est risque un peu
		 	else
				return Color3.fromRGB(218, 79, 79) -- oblige de connecter
			end
		end
	end
	return Color3.fromRGB(95, 180, 105) -- pour les valeurs de retour
end


function class.Init()

end

function class.New(o, parent, isOutput, typeString, nameString)
	parent, isOutput, typeString, nameString = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'boolean', isOutput},  -- The argument component.
		{'string', typeString},  -- The argument component.
		{'string', nameString}  -- The argument component.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	--o.typedVariable = typedVariableOrArgument
	--local isOutput = not typedVariableOrArgument:IsA('Argument')

	--parent = isRight and parent:FindFirstChild('Out') or parent:FindFirstChild('In')
	
	o.connectorView = class.Package.Templates.Container{
		Name = nameString,
		Size = UDim2.new(1, 0, 0, 30),
		Parent = parent,
		class.Package.Templates.ImageLabel{
			AnchorPoint = Vector2.new(0.5, 0.5),
			Name = "ConnectorStroke",
			Position = isOutput and UDim2.new(1, 4, 0.5, 0) or UDim2.new(0, -4, 0.5, 0),
			Size = UDim2.new(0, 20, 0, 20),
			Image = "rbxassetid://1840922184",

			class.Package.Templates.ImageButton{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Name = "Connector",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0.7, 0, 0.7, 0),
				ZIndex = 40,
				Image = "rbxassetid://1841010009",
				ImageColor3 = Color3.fromRGB(137, 180, 137)
			}
		}
	}
	local container = class.Package.Templates.Container{
		Position = isOutput and UDim2.new(0, -10, 0, -3) or UDim2.new(0, 10, 0, -3),
		Parent = o.connectorView,
		class.Package.Templates.MinimalText(typeString, {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Name = "ConnectorType",
			ZIndex = 60,
			Font = Enum.Font.SourceSansItalic,
			Text = typeString,
			TextColor3 = Color3.fromRGB(150, 150, 150),
			TextSize = 18
		}),
		class.Package.Templates.MinimalText(nameString, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Name = "ConnectorValue",
			ZIndex = 60,
			Font = Enum.Font.SourceSans,
			Text = nameString,
			TextColor3 = Color3.fromRGB(243, 243, 243),
			TextSize = 18,
			TextXAlignment = isOutput and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
		})
	}
	class.Package.Templates.ResponsiveList(
		true,
		isOutput and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left,
		Enum.VerticalAlignment.Center,
		function(size)
			o.connectorView.Size = UDim2.new(0, size.X + 30, 0, 30)
		end,
		5,
		container
	)
	class.Package.Themes.Bind(o.connectorView.ConnectorStroke, 'ImageColor3', 'ConnectorStrokeColor')
	class.Package.Themes.Bind(container.ConnectorType, 'TextColor3', 'ConnectorTypeColor')
	class.Package.Themes.Bind(container.ConnectorValue, 'TextColor3', 'ConnectorValueColor')

	o.SetConnected(o, false)

	return o
end

function class:SetSize(isOutput)
	isOutput = class.Package.Utils.Tests.GetArguments(
		{'boolean', isOutput}
	)
end

function class:SetConnected(linked)
	self.connectorView.ConnectorStroke.ImageColor3 = linked and Color3.fromRGB(231, 105, 15) or Color3.fromRGB(39, 39, 39)
	--TO REWORK self.connectorView.ConnectorStroke.Connector.ImageColor3 = linked and Color3.fromRGB(112, 112, 112) or GetConnectorColor(self.typedVariable)
end

function class:SetConnectorColor(color)

end

return class