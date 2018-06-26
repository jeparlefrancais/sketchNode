-- \Description: Module to draw the grid.

local TILE_SIZE = 128
local PADDING_TILE = 2
local GRID_SNAP = 16

local module = {}

local nodeToViewMap = nil

function module.Init()
	nodeToViewMap = {
		FunctionNode = module.Package.Classes.FunctionView,
		EventNode = module.Package.Classes.EventView
	}
end

function module.Start(parent)
	--\Doc: Setup the grid.
	parent = module.Package.Utils.Tests.GetArguments(
		{'GuiObject', parent}
	)
	module.window = module.Package.Utils.Create'TextButton'{
		Name = 'MouseInput',
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(49, 49, 49),
		Size = UDim2.new(1, 0, 1, 0),
		Text = '',
		Parent = parent
	}
	module.world = module.Package.Templates.Container{
		Name = 'World',
		Size = UDim2.new(0, 0, 0, 0),
		Parent = module.window
	}
	
	local sizeConstraint = module.Package.Utils.Create'UISizeConstraint'{MaxSize = Vector2.new(50000, 50000)}
	local function UpdateSizeConstraint()
		sizeConstraint.MinSize = module.GetGridSize(module.window.AbsoluteSize.X, module.window.AbsoluteSize.Y)
	end
	module.window:GetPropertyChangedSignal('AbsoluteSize'):Connect(UpdateSizeConstraint)
	UpdateSizeConstraint()

	module.gridImage = module.Package.Utils.Create'ImageLabel'{
		BorderSizePixel = 0,
		Name = 'Grid',
		Position = UDim2.new(0, 0, 0, 0),
		Image = 'rbxassetid://1837504812',
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.new(0, TILE_SIZE, 0, TILE_SIZE),
		ZIndex = 1,
		Parent = module.world,
		sizeConstraint
	}
	module.Package.Themes.Bind(module.gridImage, 'Image', 'GridImage')

	local mouseClickPosition = nil
	local gridPosition = nil
	module.window.MouseButton1Down:Connect(function(x, y)
		mouseClickPosition = Vector2.new(x, y)
		gridPosition = Vector2.new(module.world.Position.X.Offset, module.world.Position.Y.Offset)
	end)
	module.window.MouseMoved:Connect(function(x, y)
		if mouseClickPosition then
			local translation = Vector2.new(x, y) - mouseClickPosition
			local position = gridPosition + translation
			module.world.Position = UDim2.new(0, position.X, 0, position.Y)
		end
	end)
	local function SetFinalPosition(x, y)
		if mouseClickPosition then
			local translation = Vector2.new(x, y) - mouseClickPosition
			module.SetPosition(gridPosition + translation)
		end
		mouseClickPosition = nil
	end
	module.window.MouseLeave:Connect(SetFinalPosition)
	module.window.MouseButton1Up:Connect(SetFinalPosition)

	spawn(function()
		while true do
			wait(1)
			module.Update()
		end
	end)

	module.sheetFrames = {}
	module.openedSheet = nil
end

function module.EditSheet(sheet)
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to edit.
	)
	if not module.sheetFrames[sheet] then
		local sheetFrame = module.Package.Templates.Container{
			Name = 'NodeContainer',
			ZIndex = 2
		}

		local function AddNode(node)
			local nodeClass = node:GetClassName()
			if nodeToViewMap[nodeClass] then
				local view = nodeToViewMap[nodeClass]:New(sheetFrame, node)
			else
				warn(string.format('Try to insert a node in a sheet, but its class <%s> is not expected.', nodeClass))
			end
		end

		sheet.NodeAdded:Connect(AddNode)

		for id, node in pairs(sheet:GetNodes()) do
			AddNode(node)
		end

		sheetFrame.Parent = module.world
		
		module.sheetFrames[sheet] = sheetFrame
	end

	module.ShowSheetFrame(sheet)
end

function module.GetGridSize(sizeX, sizeY) --\ReturnType: Vector2
	sizeX, sizeY = module.Package.Utils.Tests.GetArguments(
		{'number', sizeX}, -- The size on the x-axis.
		{'number', sizeY} -- This size ont the y-axis.
	)
	local scaleX = math.modf(sizeX / TILE_SIZE) + 2*PADDING_TILE
	local scaleY = math.modf(sizeY / TILE_SIZE) + 2*PADDING_TILE
	return Vector2.new(scaleX * TILE_SIZE, scaleY * TILE_SIZE)
end

function module.ShowSheetFrame(sheet)
	--\Doc: Turns off the currently visible frame and show the given sheet.
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to view.
	)
	if module.openedSheet then
		module.sheetFrames[module.openedSheet].Visible = false
	end
	module.openedSheet = sheet
	module.sheetFrames[sheet].Visible = true
end

function module.GetCorners() --\ReturnType: table
	--\Doc: Returns a list that contains the most top-left corner and the most bottom-right corner from all the nodes. 
	local topLeftX = nil
	local topLeftY = nil
	local bottomRightX = nil
	local bottomRightY = nil
	for _, nodeFrame in ipairs(module.sheetFrames[module.openedSheet]:GetChildren()) do
		if nodeFrame:IsA('GuiObject') then
			topLeftX = math.min(topLeftX or math.huge, nodeFrame.Position.X.Offset)
			topLeftY = math.min(topLeftY or math.huge, nodeFrame.Position.Y.Offset)
			bottomRightX = math.max(bottomRightX or -math.huge, nodeFrame.Position.X.Offset + nodeFrame.Position.X.Offset)
			bottomRightY = math.max(bottomRightY or -math.huge, nodeFrame.Position.Y.Offset + nodeFrame.Position.Y.Offset)
		end
	end
	return {Vector2.new(topLeftX or 0, topLeftY or 0), Vector2.new(bottomRightX or 0, bottomRightY or 0)}
end

function module.Update()
	if module.openedSheet then
		local topLeft, bottomRight = unpack(module.GetCorners())
		local positionX = math.modf(topLeft.X / TILE_SIZE) - PADDING_TILE
		local positionY = math.modf(topLeft.Y / TILE_SIZE) - PADDING_TILE
		local size = module.GetGridSize(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
		module.gridImage.Position = UDim2.new(0, positionX * TILE_SIZE, 0, positionY * TILE_SIZE)
		module.gridImage.Size = UDim2.new(0, size.X, 0, size.Y)
	else
		warn('Grid does not know what to do without a sheet.')
	end
end

function module.SetPosition(position)
	position = module.Package.Utils.Tests.GetArguments(
		{'Vector2', position} -- The position wanted
	)
	local maxX = -module.gridImage.Position.X.Offset
	local minX = maxX + module.window.AbsoluteSize.X - module.gridImage.AbsoluteSize.X
	local maxY = -module.gridImage.Position.Y.Offset
	local minY = maxY + module.window.AbsoluteSize.Y - module.gridImage.AbsoluteSize.Y
	local x = math.clamp(position.X, minX, maxX)
	local y = math.clamp(position.Y, minY, maxY)
	module.world:TweenPosition(UDim2.new(0, x, 0, y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .5, true)
end

return module
