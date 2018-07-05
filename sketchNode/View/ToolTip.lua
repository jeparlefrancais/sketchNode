-- \Description: Module to add a ToolTip.

local module = {}

function module.Init()
end

function module.Start(parent)
	--\Doc: TurnOn
	parent = module.Package.Utils.Tests.GetArguments(
		{'LayerCollector', parent}
	)
    module.ui = module.Package.Utils.Create'ImageLabel'{
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 80, 0, 25),
        Name = 'ToolTip',
        ZIndex = 50,
        Image = "rbxassetid://1858994698",
        ImageTransparency = 0.1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 40, 40),
        Visible = false,
        Parent = parent,

        module.Package.Templates.Container{
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(0, 0, 0, 25),
            Name = "Container",

            module.Package.Templates.IconImage{
                Name = 'Icon',
                Image = module.Package.ViewSettings.Icons.help,
                ImageTransparency = 0.3
            },
    
            module.Package.Templates.MinimalText('ToolTip', {
                LayoutOrder = 2,
                Name = "ToolTipText",
                Font = Enum.Font.SourceSansLight,
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
        }
    }
    module.Package.Templates.ResponsiveList(
        true,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Center, 
		function(outputSize)
			module.ui.Size = UDim2.new(0, outputSize.X + 12, 0, 25)
        end, 
        5,
        module.ui.Container
    )
end

function module.Show(localizationMessageIndex, screenPosition)
	localizationMessageIndex, screenPosition = module.Package.Utils.Tests.GetArguments(
		{'string', localizationMessageIndex},
        {'Vector2', screenPosition}
    )
    module.ui.Position = UDim2.new(0, screenPosition.x, 0, screenPosition.y)
    module.ui.Container.ToolTipText.Text = module.Package.Localization.GetEntry(localizationMessageIndex)
    module.ui.Visible = true
end

function module.Hide()
    module.ui.Visible = false
end

return module