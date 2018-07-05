-- \Description: No description yet

local services = {
	'Lighting',
	'ReplicatedFirst',
	'ReplicatedStorage',
	'RunService',
	'ServerStorage',
	'Workspace'
}

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
    --\Doc: Starts the Grid module
    parent = module.Package.Utils.Tests.GetArguments(
        {'GuiObject', parent}
	)
	module.engine = module.Package.Main:GetEngine()
	
	module.Package.Templates.HorizontalList(2, false).Parent = parent
    module.panel = module.Package.Templates.Container{
		BackgroundTransparency = 0,
		BorderSizePixel = 3,
		Name = 'Panel',
		Size = UDim2.new(0, 200, 1, 0),
		ZIndex = 2,
		Parent = parent,

		module.Package.Templates.Container{
			Name = 'Library',
			Size = UDim2.new(1, 0, 0.3, 0),
			module.Package.Templates.VerticalList(2, false),

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
		},
		
		module.Package.Templates.ScrollingContainer{
			Name = 'Nodes',
			Position = UDim2.new(0, 0, 0.3, -10),
			Size = UDim2.new(1, 0, 0.7, 0),
			module.Package.Templates.VerticalList(2, false),

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
	}
	module.Package.Themes.Bind(module.panel, 'BackgroundColor3', 'ContainerColor')
	module.Package.Themes.Bind(module.panel, 'BorderColor3', 'ContainerBorderColor')

	module.panel.Nodes.VerticalListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		module.panel.Nodes.CanvasSize = UDim2.new(0, 0, 0, module.panel.Nodes.VerticalListLayout.AbsoluteContentSize.Y)
	end)

	module.gridContainer = module.Package.Templates.Container{
		Name = 'GridContainer',
		Size = UDim2.new(1, -200, 1, 0),
		LayoutOrder = 2,
		Parent = parent
	}

	module.gameSheets = module.Package.Classes.SectionView:New(module.panel.Library, 'Game Sheets', true)
	local addSheetTextbox = module.Package.Utils.Create'TextBox'{
		BackgroundTransparency = 1,
		Name = 'CreateSheetButton',
		Position = UDim2.new(0, 18, 0, 0),
		Size = UDim2.new(1, -30, 0, 18),
		Font = Enum.Font.SourceSansItalic,
		PlaceholderText = 'Add new Sheet..',
		PlaceholderColor3 = Color3.fromRGB(193, 193, 193),
		Text = '',
		TextColor3 = Color3.fromRGB(193, 193, 193),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = foldable
	}
	addSheetTextbox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local sheetName = addSheetTextbox.Text
			if string.len(sheetName) > 0 then
				module.engine.AddSheet(sheetName)
			end
		end
		addSheetTextbox.Text = ''
	end)
	module.gameSheets:AddFooter(addSheetTextbox)

	local nodeSections = {
		services = module.Package.Classes.SectionView:New(module.panel.Nodes, 'Services', false),
		math = module.Package.Classes.SectionView:New(module.panel.Nodes, 'math', true),
		string = module.Package.Classes.SectionView:New(module.panel.Nodes, 'string', true),
		os = module.Package.Classes.SectionView:New(module.panel.Nodes, 'os', true),
		table = module.Package.Classes.SectionView:New(module.panel.Nodes, 'table', true),
		global = module.Package.Classes.SectionView:New(module.panel.Nodes, 'global', true),
	}
	local luaReferenceNames = module.engine.GetLuaReferenceNames()
	for _, referenceName in pairs(luaReferenceNames) do
		local sectionName =  referenceName:match('(%w+)%.%w+') or 'global'
		local nodeButton = module.Package.Templates.SectionButton{
			Name = string.lower(referenceName),
			Text = referenceName
		}
		nodeButton.MouseButton1Click:Connect(function()
			module.Package.Grid.CreateNode(module.engine.GetLuaReference(referenceName), 0, 0)
		end)
		nodeSections[sectionName]:AddElement(nodeButton)
	end
	for _, service in ipairs(services) do
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

	module.Package.Grid.Start(module.gridContainer)
end

function module:AddSketchSheet(sheet)
	--\Doc: Creates the view to access the sheet. This includes a button in the left panel 
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to add.
	)
	local sheetButton = module.Package.Templates.SectionButton{
		Name = string.lower(sheet:GetName()),
		Text = sheet:GetName()
	}
	sheetButton.MouseButton1Click:Connect(function()
		module.Package.Grid.EditSheet(sheet)
	end)
	sheet.NameChanged:Connect(function(name)
		sheetButton.Name = string.lower(name)
		sheetButton.Text = name
	end)
	module.gameSheets:AddElement(sheetButton)
end

return module