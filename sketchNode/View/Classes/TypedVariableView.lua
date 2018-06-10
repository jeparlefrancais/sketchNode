--\Description: This class is used to make typedvariable (output) connectors in function nodes

local TXT = game:GetService('TextService')

local class = {
	__name = 'ArgumentView'
}

function class.Init()

end

function class.New(o, parent, typedVariable)
	parent, typedVariable = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'TypedVariable', typedVariable}  -- The argument component.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end
	
	local typedVariableView = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0, 0),
		BackgroundTransparency = 1,
		Name = typedVariable:GetName(),
		Size = UDim2.new(1, 0, 0, 30),
		ZIndex = 50,
		Parent = parent
	}
	local connectorStroke = class.Package.Utils.Create'ImageLabel'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Name = "OutputConnectorStroke",
		Position = UDim2.new(1, 4, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		ZIndex = 40,
		Image = "rbxassetid://1840922184",
		ImageColor3 = Color3.fromRGB(39, 39, 39),
		Parent = typedVariableView
	}
	class.Package.Utils.Create'ImageButton'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Name = "OutputConnector",
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.7, 0, 0.7, 0),
		ZIndex = 40,
		Image = "rbxassetid://1841010009",
		ImageColor3 = Color3.fromRGB(137, 180, 137),
		Parent = connectorStroke
	}
	o.valueName = class.Package.Utils.Create'TextLabel'{
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Name = "ValueName",
		Position = UDim2.new(1, -10, 0.5, -2),
		Size = UDim2.new(1, 0, 0.6, 0),
		ZIndex = 60,
		Font = Enum.Font.SourceSans,
		Text = typedVariable:GetName(),
		TextColor3 = Color3.fromRGB(243, 243, 243),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = typedVariableView
	}
	o.inputType = class.Package.Utils.Create'TextLabel'{
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Name = "InputType",
		Position = UDim2.new(1, -15 - TXT:GetTextSize(o.valueName.Text, o.valueName.TextSize, o.valueName.Font, Vector2.new(500, 500)).x, 0.5, -2),
		Size = UDim2.new(1, 0, 0.6, 0),
		ZIndex = 60,
		Font = Enum.Font.SourceSansItalic,
		Text = typedVariable:GetType(),
		TextColor3 = Color3.fromRGB(150, 150, 150),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = typedVariableView
	}

	return o
end

return class