--\Description: Add a description

local class = {
	__name = 'Node'
}

function class.Init()
	class.__super = nil
	class.__signals = {
		PositionChanged = {
			'number', -- x
			'number', -- y
		},
		ColorChanged = {
			'Color3' -- newColor
		}
	}
end

function class.New(o, x, y) --\ReturnType: table
	x, y = class.Package.Utils.Tests.GetArguments(
		{'number', x, 0}, -- The x component.
		{'number', y, 0} -- The y component.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)

	o.position = Vector2.new(x, y)
	o.color = Color3.fromRGB(255, 255, 255)

	return o
end

function class.Load(o, data) --\ReturnType: table
	--\Doc: Creates a new object with the given table.
	data = class.Package.Utils.Tests.GetArguments(
		{'table', data} -- Data from the Serialize method.
	)
	if o == class then o = class.Package.Utils.Inherit(class) end

	class.Package.Utils.Signal.SetSignals(class, o)
	
	o.position = Vector2.new(data.x, data.y)

	return o
end

function class:Serialize() --\ReturnType: table
	--\Doc: Serializes all the object data in a table to be reloaded using the Load method.
	return {
		x = self.position.X,
		y = self.position.Y
	}
end

function class:GetPosition() --\ReturnType: Vector2
	--\Doc: Returns the position of the node.
	return self.position
end

function class:SetPosition(x, y)
	--\Doc: Sets the position of the node.
	x, y = class.Package.Utils.Tests.GetArguments(
		{'number', x}, -- The name of the method.
		{'number', y} -- A list of the arguments.
	)
	self.position = Vector2.new(x, y)
	self.PositionChanged:Fire(x, y)
end

function class:SetColor(color3)
	--\Doc: Sets the color of the node.
	color3 = class.Package.Utils.Tests.GetArguments(
		{'number', color3} -- The new color of the node.
	)
	self.color = color3
	self.ColorChanged:Fire(color3)
end

function class:GetColor() --\ReturnType: Color3
	return self.color
end

return class
