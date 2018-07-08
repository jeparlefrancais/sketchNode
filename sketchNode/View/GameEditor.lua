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
		Parent = parent
	}
	module.Package.Themes.Bind(module.panel, 'BackgroundColor3', 'ContainerColor')
	module.Package.Themes.Bind(module.panel, 'BorderColor3', 'ContainerBorderColor')

	module.gridContainer = module.Package.Templates.Container{
		Name = 'GridContainer',
		Size = UDim2.new(1, -200, 1, 0),
		LayoutOrder = 2,
		Parent = parent
	}

	module.Package.Panels.GamePanel.Start(module.panel)

	module.Package.Grid.Start(module.gridContainer)
end

return module
