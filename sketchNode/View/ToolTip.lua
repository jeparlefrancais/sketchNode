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

function module.Show(localizationMessageIndex, x, y)
	localizationMessageIndex, screenPosition = module.Package.Utils.Tests.GetArguments(
		{'string', localizationMessageIndex}, -- The entry in the localization table.
		{'number', x}, -- The position on the x-axis.
		{'number', y} -- The position on the y-axis.
	)
	module.ui.Position = UDim2.new(0, x, 0, y)
	module.ui.Container.ToolTipText.Text = module.Package.Localization.GetEntry(localizationMessageIndex)
	module.ui.Visible = true
	module.skipHide = true
	wait(module.Package.ViewSettings.ToolTipMinimumTime)
	module.skipHide = false
end

function module.Hide()
	if not module.skipHide then
		module.ui.Visible = false
	end
end

function module.Bind(guiObject, localizationMessageIndex)
	guiObject, localizationMessageIndex = module.Package.Utils.Tests.GetArguments(
		{'GuiObject', guiObject}, -- The entry in the localization table.
		{'string', localizationMessageIndex} -- The entry in the localization table.
	)
	local enteredId = 0
	guiObject.MouseEnter(function(x, y)
		enteredId = enteredId + 1
		local current = enteredId
		wait(module.Package.ViewSettings.ToolTipWaitTime)
		if current == enteredId then
			module.Show(localizationMessageIndex, x, y)
		end
	end)
	guiObject.MouseLeave:Connect(function()
		enteredId = enteredId + 1
	end)
end

return module