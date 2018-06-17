-- \Description: Module to draw a Game Editor sheet

local module = {}

function module.Start(parent)
    --\Doc: Setup the grid.
    parent = module.Package.Utils.Tests.GetArguments(
        {'GuiBase', parent}
    )
    
end

return module
