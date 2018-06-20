-- \Description: No description yet

local module = {}

function module.Start(parent)
    --\Doc: Starts the Grid module
    parent = module.Package.Utils.Tests.GetArguments(
        {'GuiObject', parent}
	)
	module.Package.Templates.HorizontalList(0, false).Parent = parent
    module.panel = module.Package.Templates.Container{
		Name = 'Panel',
		Size = UDim2.new(0, 0, 1, 0),
		Parent = parent
	}
	module.gridContainer = module.Package.Templates.Container{
		Name = 'GridContainer',
		Size = UDim2.new(1, 0, 1, 0),
		Parent = parent
	}
	module.Package.Grid.Start(module.gridContainer)
end

return module
