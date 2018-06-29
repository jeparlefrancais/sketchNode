-- \Description: No description yet

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
	}
	module.Package.Themes.Bind(module.panel, 'BackgroundColor3', 'ContainerColor')
	module.Package.Themes.Bind(module.panel, 'BorderColor3', 'ContainerBorderColor')

	module.gridContainer = module.Package.Templates.Container{
		Name = 'GridContainer',
		Size = UDim2.new(1, -200, 1, 0),
		LayoutOrder = 2,
		Parent = parent
	}

	module.gameSheets = module.Package.Classes.SectionView:New(module.panel, 'Game Sheets', true)
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

function module:CreatePanelSection(name)

end

return module
