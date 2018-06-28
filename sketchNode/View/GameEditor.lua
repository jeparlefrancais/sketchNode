-- \Description: No description yet

local module = {}

function module.Start(parent)
    --\Doc: Starts the Grid module
    parent = module.Package.Utils.Tests.GetArguments(
        {'GuiObject', parent}
	)
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

	module.gameSheets = module.Package.Classes.SectionView:New(module.panel, 'Game Sheets')

	module.Package.Grid.Start(module.gridContainer)
end

function module:AddGameSheetButton(sheet)
	sheet = module.Package.Utils.Tests.GetArguments(
		{'SketchSheet', sheet} -- The sheet to edit.
	)
	module.gameSheets:AddElement(sheet:GetName(), sheet:GetName())
end

function module:CreatePanelSection(name)

end

return module
