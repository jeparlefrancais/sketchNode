--\Description: This is a class to create connection wires.

local class = {
	__name = 'ConnectorView'
}

function class.Init()

end

function class.New(o, parent, startVector2, endVector2)
	parent, startVector2, endVector2 = class.Package.Utils.Tests.GetArguments(
		{'Instance', parent}, -- The parent component.
		{'Vector2', startVector2},  -- The argument component.
		{'Vector2', endVector2}  -- The argument component.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	o.startObject = startObject
	o.endObject = endObject

	o.wire = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 189, 56),
		BorderSizePixel = 0,
		Name = nameString,
		Size = UDim2.new(0, (endVector2 - startVector2).Magnitude, 0, 2),
		Rotation = math.deg(math.atan((endVector2.Y - startVector2.Y)/(endVector2.X - startVector2.X))),
		Position = UDim2.new(0, (startVector2.X + endVector2.X)/2, 0, (startVector2.Y + endVector2.Y)/2),
		Parent = parent
	}

	o.debugStart = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 255, 0),
		BorderSizePixel = 0,
		Name = nameString,
		Size = UDim2.new(0, 4, 0, 4),
		Position = UDim2.new(0, startVector2.X, 0, startVector2.Y),
		Parent = parent
	}

	o.debugEnd = class.Package.Utils.Create'Frame'{
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 255),
		BorderSizePixel = 0,
		Name = nameString,
		Size = UDim2.new(0, 4, 0, 4),
		Position = UDim2.new(0, endVector2.X, 0, endVector2.Y),
		Parent = parent
	}

	o.debugStart.Changed:connect(function()
		o:Update(o.debugStart.AbsolutePosition, o.debugEnd.AbsolutePosition)
	end)

	return o
end

function class:Update(startVector2, endVector2)
	o.wire.Size = UDim2.new(0, (endVector2 - startVector2).Magnitude, 0, 2)
	o.wire.Rotation = math.deg(math.atan((endVector2.Y - startVector2.Y)/(endVector2.X - startVector2.X)))
	o.wire.Position = UDim2.new(0, (startVector2.X + endVector2.X)/2, 0, (startVector2.Y + endVector2.Y)/2)
end

return class