--\Description: No description yet.

local function Append(...)
	local list = {unpack((select(1, ...)))}
	local total = select('#', ...)
	for i=2, total do
		for _, element in ipairs(select(i, ...)) do
			table.insert(list, element)
		end
	end
	return list
end

local module = {}

function module.Start(parent)
	--\Doc: Creates the Game panel.
	parent = module.Package.Utils.Tests.GetArguments(
		{'GuiObject', parent}
	)
	module.engine = module.Package.Main:GetEngine()

	local library = module.Package.Templates.Container{
		Name = 'Library',
		Size = UDim2.new(1, 0, 0.3, 0),
		module.Package.Templates.VerticalList(2, false),
		Parent = parent,
		module.Package.Utils.Create'Frame'{
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Name = 'Title',
			Size = UDim2.new(1, 0, 0, 30),
			module.Package.Utils.Create'TextLabel'{
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Name = 'TitleLabel',
				Position = UDim2.new(0, 20, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 30),
				Font = Enum.Font.SourceSansBold,
				Text = 'Library',
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 18,
				TextXAlignment = Enum.TextXAlignment.Left
			}
		}
	}
	local nodes = module.Package.Templates.ScrollingContainer{
		Name = 'Nodes',
		Position = UDim2.new(0, 0, 0.3, -10),
		Size = UDim2.new(1, 0, 0.7, 0),
		module.Package.Templates.VerticalList(2, false),
		Parent = parent,
		module.Package.Utils.Create'Frame'{
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Name = 'Title',
			Size = UDim2.new(1, 0, 0, 30),
			module.Package.Utils.Create'TextLabel'{
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Name = 'TitleLabel',
				Position = UDim2.new(0, 20, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 30),
				Font = Enum.Font.SourceSansBold,
				Text = 'Nodes',
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 18,
				TextXAlignment = Enum.TextXAlignment.Left
			}
		}
	}
	
	module.Package.Localization.Bind(library.Title.TitleLabel, 'LibraryPanel')
	module.Package.Localization.Bind(nodes.Title.TitleLabel, 'NodesPanel')
	nodes.VerticalListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		nodes.CanvasSize = UDim2.new(0, 0, 0, nodes.VerticalListLayout.AbsoluteContentSize.Y)
	end)

	module.gameSheets = module.Package.Classes.SectionView:New(library, 'Game Sheets', true)
	local addSheetTextbox = module.Package.Utils.Create'TextBox'{
		BackgroundTransparency = 1,
		Name = 'CreateSheetButton',
		Position = UDim2.new(0, 18, 0, 0),
		Size = UDim2.new(1, -30, 0, 18),
		Font = Enum.Font.SourceSansItalic,
		PlaceholderColor3 = Color3.fromRGB(193, 193, 193),
		Text = '',
		TextColor3 = Color3.fromRGB(193, 193, 193),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left
	}
	module.Package.Localization.BindProperty(addSheetTextbox, 'PlaceholderText', 'AddSheetPlaceholderText')
	addSheetTextbox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local sheetName = addSheetTextbox.Text
			if string.len(sheetName) > 0 then
				local sheet = module.engine.AddSheet(sheetName)
				module.Package.Grid.EditSheet(sheet)
			end
		end
		addSheetTextbox.Text = ''
	end)
	module.gameSheets:AddFooter(addSheetTextbox)

	local nodeSections = {
		services = module.Package.Classes.SectionView:New(nodes, 'Services', false),
		math = module.Package.Classes.SectionView:New(nodes, 'math', true),
		string = module.Package.Classes.SectionView:New(nodes, 'string', true),
		os = module.Package.Classes.SectionView:New(nodes, 'os', true),
		table = module.Package.Classes.SectionView:New(nodes, 'table', true),
		global = module.Package.Classes.SectionView:New(nodes, 'global', true),
		inputs = module.Package.Classes.SectionView:New(nodes, 'inputs', false)
	}

	local luaReferenceNames = module.engine.GetLuaReferenceNames()
	for _, referenceName in pairs(luaReferenceNames) do
		local sectionName =  referenceName:match('(%w+)%.%w+') or 'global'
		local nodeButton = module.Package.Templates.SectionButton{
			Name = string.lower(referenceName),
			Text = referenceName,
			module.Package.Templates.HorizontalList(4, true, true)
		}
		
		local favorited = false
		local favoriteButton = module.Package.Templates.IconButton{
			Image = module.Package.ViewSettings.Icons['favorite'],
			ImageTransparency = 1,
			Parent = nodeButton
		}
		favoriteButton.MouseButton1Click:connect(function()
			favorited = not favorited
			favoriteButton.Image = favorited and module.Package.ViewSettings.Icons['favorited'] or module.Package.ViewSettings.Icons['favorite']
		end)
		favoriteButton.MouseEnter:connect(function()
			favoriteButton.ImageColor3 = Color3.fromRGB(255, 255, 102)
		end)
		favoriteButton.MouseLeave:connect(function()
			favoriteButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
		end)
		nodeButton.MouseEnter:connect(function()
			favoriteButton.ImageTransparency = 0
		end)
		nodeButton.MouseLeave:connect(function()
			favoriteButton.ImageTransparency = favorited and 0.9 or 1
		end)
		nodeButton.MouseButton1Click:connect(function()
			module.Package.Grid.CreateNode(module.engine.GetLuaReference(referenceName), 0, 0)
		end)
		nodeSections[sectionName]:AddElement(nodeButton)
	end

	for _, service in ipairs(module.Package.ViewSettings.NodesFolderServices) do
		local serviceSection = module.Package.Classes.SectionView:New(nodeSections.services:GetContainerInstance(), service, true)
		local members = module.engine.GetClassMembers(service)
		for _, member in ipairs(Append(members.Properties, members.Functions, members.Events)) do
			local nodeButton = module.Package.Templates.SectionButton{
				Name = string.lower(member),
				Text = member
			}
			nodeButton.MouseButton1Click:Connect(function()
				module.Package.Grid.CreateNode(module.engine.GetObjectReference(game:GetService(service), member))
			end)
			serviceSection:AddElement(nodeButton)
		end
	end
	for _, inputType in ipairs(module.Package.ViewSettings.NodesFolderInputs) do
		local nodeButton = module.Package.Templates.SectionButton{
			Name = inputType,
			Text = inputType
		}
		nodeButton.MouseButton1Click:Connect(function()
			module.Package.Grid.CreateNode(module.engine.GetInputReference(inputType))
		end)
		nodeSections.inputs:AddElement(nodeButton)
	end

	module.sheetButtons = {}
end

local selectedSheetButton = nil

function module.AddSketchSheetButton(sheet)
	--\Doc: Creates a button in the Game panel to be able to open that sheet.
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to create a button for.
	)
	local sheetButton = module.Package.Templates.SectionButton{
		Name = string.lower(sheet:GetName()),
		Text = sheet:GetName(),
		module.Package.Templates.HorizontalList(4, true, true)
	}
	local labelButton = module.Package.Templates.IconButton{
		Image = module.Package.ViewSettings.Icons['label'],
		LayoutOrder = 1,
		Visible = false,
		Parent = sheetButton
	}
	local deleteButton = module.Package.Templates.IconButton{
		Image = module.Package.ViewSettings.Icons['delete'],
		LayoutOrder = 2,
		Visible = false,
		Parent = sheetButton
	}
	sheetButton.MouseEnter:Connect(function()
		labelButton.Visible = true
		deleteButton.Visible = true
	end)
	sheetButton.MouseLeave:Connect(function()
		labelButton.Visible = false
		deleteButton.Visible = false
	end)
	sheetButton.MouseButton1Click:Connect(function()
		if selectedSheetButton then
			selectedSheetButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		end
		module.Package.Grid.EditSheet(sheet)
		selectedSheetButton = sheetButton
		sheetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	labelButton.MouseEnter:connect(function()
		labelButton.ImageColor3 = Color3.fromRGB(102, 102, 255)
	end)
	labelButton.MouseLeave:connect(function()
		labelButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	end)
	deleteButton.MouseEnter:connect(function()
		deleteButton.ImageColor3 = Color3.fromRGB(255, 102, 102)
	end)
	deleteButton.MouseLeave:connect(function()
		deleteButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	end)
	deleteButton.MouseButton1Click:connect(function()
		if module.Package.Dialog.Prompt('DeleteSheetPromptTitle', 'DeleteSheetPromptMessage') then
			module.engine.DeleteSheet(sheet)
		end
	end)
	sheet.NameChanged:Connect(function(name)
		sheetButton.Name = string.lower(name)
		sheetButton.Text = name
	end)
	module.gameSheets:AddElement(sheetButton)
	module.sheetButtons[sheet] = sheetButton
end

function module.RemoveSketchSheetButton(sheet)
	--\Doc: Removes the button linked to that sheet.
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to create a button for.
	)
	if module.sheetButtons[sheet] then
		module.sheetButtons[sheet]:Destroy()
	else
		warn('Trying to remove a button that is not linked to a sheet.')
	end
end

return module
