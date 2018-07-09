-- \Description: Module to draw the grid.

local TILE_SIZE = 128
local PADDING_TILE = 2
local GRID_SNAP = 16

local module = {}

local nodeToViewMap = nil

function module.Init()
	nodeToViewMap = {
		FunctionNode = module.Package.Classes.FunctionView,
		EventNode = module.Package.Classes.EventView,
		ValueNode = module.Package.Classes.ValueView
	}
end

function module.Start(parent)
	--\Doc: Setup the grid.
	parent = module.Package.Utils.Tests.GetArguments(
		{'GuiObject', parent}
	)
	module.openingSheet = false
	module.noSheet = module.Package.Utils.Create'TextButton'{
		Name = 'NoSheet',
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(49, 49, 49),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 2,
		Font = Enum.Font.SourceSansItalic,
		TextSize = 48,
		TextColor3 = Color3.fromRGB(98, 98, 98),
		Parent = parent
	}
	module.Package.Localization.Bind(module.noSheet, 'NoSheetOpenedMessage')
	module.window = module.Package.Utils.Create'TextButton'{
		Name = 'MouseInput',
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(49, 49, 49),
		Size = UDim2.new(1, 0, 1, 0),
		Text = '',
		Parent = parent
	}
	module.Package.Themes.Bind(module.noSheet, 'BackgroundColor3', 'GridColor')
	module.Package.Themes.Bind(module.window, 'BackgroundColor3', 'GridColor') 
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

	module.window.MouseButton1Down:Connect(function(x, y)
		module.gridClickPosition = Vector2.new(x, y)
		module.gridPosition = Vector2.new(module.world.Position.X.Offset, module.world.Position.Y.Offset)
	end)
	module.window.MouseMoved:Connect(module.MouseMove)
	module.window.MouseLeave:Connect(module.SendMouseUp)
	module.window.MouseButton1Up:Connect(module.SendMouseUp)

	module.sheetFrames = {}
	module.openedSheet = nil
end

function module.StartNodeMovement(node, x, y)
	node, x, y = module.Package.Utils.Tests.GetArguments(
		{'Node', node}, -- The node to move.
		{'number', x}, --The position of the mouse click on the x-axis.
		{'number', y} -- The position of the mouse click on the y-axis.
	)
	module.nodeToMove = node
	module.nodePosition = node:GetPosition()
	module.nodeToMoveClickPosition = Vector2.new(x, y)
end

function module.StartConnection(node, index, isInput, x, y)
	node, index, isInput, x, y = module.Package.Utils.Tests.GetArguments(
		{'Node', node}, -- The node to move.
		{'number', index}, -- The index of the connector.
		{'boolean', isInput}, -- If the connector is an input.
		{'number', x}, --The position of the mouse click on the x-axis.
		{'number', y} -- The position of the mouse click on the y-axis.
	)
	module.nodeToConnect = node
	module.nodeToConnectIndex = index
	module.nodeToConnectIsInput = isInput
end

function module.VerifyConnection(node, index, isInput) --\ReturnType: string
	--\Doc: Return 'Success' if the connection can be made, or an entry in the localization table that explains what is wrong with the connection.
	node, index, isInput = module.Package.Utils.Tests.GetArguments(
		{'Node', node}, -- The node to move.
		{'number', index}, -- The index of the connector.
		{'boolean', isInput} -- If the connector is an input.
	)
	local warning
	if module.nodeToConnect then
		if module.nodeToConnect ~= node then
			if module.nodeToConnectIsInput ~= isInput then
				if module.nodeToConnectIndex == 0 then
					if index == 0 then
						return 'Success'
					else
						warning = 'TriggerToOther'
					end
				else
					if index == 0 then
						warning = 'TriggerToOther'
					else
						-- check if type matches
						warning = 'WrongTypes'
					end
				end
			else
				warning = isInput and 'BothInputs' or 'BothOutputs'
			end
		else
			warning = 'SameNode'
		end
	else
		warning = 'FirstNodeMissing'
	end
	return string.format('ConnectionWarnings.%s', warning)
end

function module.EndConnection(node, index, isInput)
	if module.nodeToConnect then
		if isInput ~= module.nodeToConnectIsInput then

		else

		end
	end
	module.SendMouseUp(0, 0)
end

function module.SendMouseUp(x, y)
	if module.nodeToMove then
		local translation = Vector2.new(x, y) - module.nodeToMoveClickPosition
		local position = module.nodePosition + translation
		module.nodeToMove:SetPosition(position.X, position.Y)
		module.Update()
	else
		if module.gridClickPosition then
			local translation = Vector2.new(x, y) - module.gridClickPosition
			module.SetPosition(module.gridPosition + translation)
		end
	end
	module.nodeToMove = nil
	module.nodeToConnect = nil
	module.gridClickPosition = nil
end

function module.MouseMove(x, y)
	if module.nodeToMove then
		local translation = Vector2.new(x, y) - module.nodeToMoveClickPosition
		local position = module.nodePosition + translation
		module.nodeToMove:SetPosition(position.X, position.Y)
	else
		if module.gridClickPosition then
			local translation = Vector2.new(x, y) - module.gridClickPosition
			local position = module.gridPosition + translation
			module.world.Position = UDim2.new(0, position.X, 0, position.Y)	
		end
	end
end

function module.EditSheet(sheet) --\ReturnType: boolean
	--\Doc: Opens a sheet in the editor grid.
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to edit.
	)
	if not module.openingSheet then
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
		return true
	else
		return false
	end
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
	module.Update()
end

function module.RemoveSheetFrame(sheet)
	--\Removes the frame linked with the sheet. Closes the frame if the sheet is currently opened.
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to view.
	)
	if module.sheetFrames[module.openedSheet] then
		module.sheetFrames[module.openedSheet]:Destroy()
	end
	if module.openedSheet == sheet then
		module.openedSheet = nil
		module.noSheet.Visible = true
	end
end

function module.GetCorners() --\ReturnType: table
	--\Doc: Returns a list that contains the most top-left corner and the most bottom-right corner from all the nodes. 
	local topLeftX = nil
	local topLeftY = nil
	local bottomRightX = nil
	local bottomRightY = nil
	for _, nodeFrame in ipairs(module.sheetFrames[module.openedSheet]:GetChildren()) do
		if nodeFrame:IsA('GuiObject') then
			local x = nodeFrame.Position.X.Offset
			local y = nodeFrame.Position.Y.Offset
			topLeftX = math.min(topLeftX or math.huge, x)
			topLeftY = math.min(topLeftY or math.huge, y)
			bottomRightX = math.max(bottomRightX or -math.huge, x + nodeFrame.AbsoluteSize.X)
			bottomRightY = math.max(bottomRightY or -math.huge, y + nodeFrame.AbsoluteSize.Y)
		end
	end
	return {Vector2.new(topLeftX or 0, topLeftY or 0), Vector2.new(bottomRightX or 0, bottomRightY or 0)}
end

function module.Update()
	if module.openedSheet then
		module.noSheet.Visible = false
		local topLeft, bottomRight = unpack(module.GetCorners())
		local positionX = math.modf(topLeft.X / TILE_SIZE) - PADDING_TILE
		local positionY = math.modf(topLeft.Y / TILE_SIZE) - PADDING_TILE
		local size = module.GetGridSize(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
		module.gridImage.Position = UDim2.new(0, positionX * TILE_SIZE, 0, positionY * TILE_SIZE)
		module.gridImage.Size = UDim2.new(0, size.X, 0, size.Y)
		module.SetPosition(Vector2.new(module.world.Position.X.Offset, module.world.Position.Y.Offset))
	else
		module.noSheet.Visible = true
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
	module.world:TweenPosition(UDim2.new(0, x, 0, y), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .1, true)
end

function module.CreateNode(reference, x, y)
	reference, x, y = module.Package.Utils.Tests.GetArguments(
        {'BaseReference', reference}, -- The reference to the function
        {'number', x, 0}, -- The position on the x-axis of the node to create
        {'number', y, 0} -- The position on the y-axis of the node to create
	)
	if module.openedSheet then
		module.openedSheet:CreateNode(reference, x, y)
		module.Update()
	end
end

return module
