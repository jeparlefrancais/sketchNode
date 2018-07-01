-- \Description: Module to prompt a Dialog.

local module = {}

function module.Init()
end

function module.Start(parent)
	--\Doc: TurnOn
	parent = module.Package.Utils.Tests.GetArguments(
		{'LayerCollector', parent}
	)
	module.dialog = module.Package.Utils.Create'TextButton'{
		Name = 'PromptScreen',
		AutoButtonColor = false,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		Text = '',
		ZIndex = 200,
		Parent = parent,
		
		module.Package.Utils.Create'ImageLabel' {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Name = 'Window',
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 300, 0, 160),
			Image = 'rbxassetid://1840836042',
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(16, 16, 48, 48),

			module.Package.Templates.Container{
				AnchorPoint = Vector2.new(0.5, 0),
				Name = 'Content',
				Position = UDim2.new(0.5, 0, 0, 40),
				Size = UDim2.new(1, -20, 0, 30),
				module.Package.Templates.VerticalList(0, 'VerticalListLayout'),

				module.Package.Utils.Create'TextLabel'{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 60),
					Name = 'Message',
					Font = Enum.Font.SourceSans,
					Text = message,
					TextSize = 18,
					TextColor3 = Color3.new(1,1,1),
					TextWrapped = true
				},

				module.Package.Utils.Create'Frame'{
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Name = 'Buttons',
					Size = UDim2.new(1, 0, 0, 40),

					module.Package.Templates.ClickButton('DialogYesButton', {
						Name = 'YesButton',
						Position = UDim2.new(0.25, 0, 0, 0)
					}),
					module.Package.Templates.ClickButton('DialogNoButton', {
						Name = 'NoButton',
						Position = UDim2.new(0.75, 0, 0, 0)
					})
				}
			},

			module.Package.Utils.Create'ImageLabel'{ 
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				Name = 'TitleBar',
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, 64),
				ZIndex = 20,
				Image = 'rbxassetid://1840881064',
				ImageColor3 = Color3.fromRGB(200, 75, 75);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(16, 16, 48, 48),

				module.Package.Utils.Create'TextLabel'{
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Name = 'DialogTitle',
					Position = UDim2.new(0.5, 0, 0, 8),
					Size = UDim2.new(0.9, -16, 1, -40),
					ZIndex = 30,
					Font = Enum.Font.SourceSansSemibold,
					Text = title,
					TextColor3 = Color3.new(1,1,1),
					TextSize = 28,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = nodeTitle
				}
			}
		}
	}
	module.bin = Instance.new("BindableEvent")

	module.dialog.Window.Content.Buttons.YesButton.MouseButton1Click:Connect(function()
		module.bin:Fire(true)
	end)
	module.dialog.Window.Content.Buttons.NoButton.MouseButton1Click:Connect(function()
		module.bin:Fire(false)
	end)
end

function module.Prompt(title, message)
	title, message = module.Package.Utils.Tests.GetArguments(
		{'string', title},
		{'string', message}
	)
	module.dialog.Window.TitleBar.DialogTitle.Text = title
	module.dialog.Window.Content.Message.Text = message
	module.dialog.Visible = true
	-- wait until event is fied
	local result = module.bin.Event:Wait()
	module.dialog.Visible = false
	return result
end

return module