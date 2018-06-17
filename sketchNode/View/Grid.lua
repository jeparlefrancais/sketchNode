-- \Description: Module to draw the grid.

local module = {}

function module.Start(parent)
    --\Doc: Setup the grid.
    parent = module.Package.Utils.Tests.GetArguments(
        {'GuiBase', parent}
    )
    local centerPoint = module.Package.Templates.CenterPoint(parent)
    module.gridImage = module.Package.Utils.Create'ImageButton'{
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(49, 49, 49),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Name = "Grid",
        Size = UDim2.new(0, 2048, 0, 2048),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Image = "rbxassetid://1837504812",
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 128, 0, 128),
        Parent = centerPoint
    }
end

return module
