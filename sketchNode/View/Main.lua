local module = {}

function module.Start(plugin, Engine)
	module.engine = Engine
	-- build the actual UI
	module.gui = plugin:CreateDockWidgetPluginGui("SketchEngineView", module.Package.ViewSettings.DockWidgetInfo)
	module.gui.Title = "sketchnode"
	module.gui.Name = "sketchnode"
	module.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	local pluginToolbar = plugin:CreateToolbar("Sketchnode")
	pluginToolbar:CreateButton("Launch", "Start the Editor", module.Package.ViewSettings.Icons['plugin']).Click:Connect(function()
		module.gui.Enabled = not module.gui.Enabled
	end)

	module.Package.ToolBar.Start(module.gui)
	module.Package.ToolBar.CreateButton("save", "save", true, function() end)
	module.Package.ToolBar.CreateButton("build", "build", true, function() end)
	module.Package.ToolBar.CreateButton("bug", "bug", false, function() end)
	module.Package.ToolBar.CreateButton("help", "help", false, function() end)

	module.Package.Dialog.Start(module.gui)
	
	local editorContainer = module.Package.Templates.Container{
		Position = UDim2.new(0, 0, 0, module.Package.ToolBar.GetHeight()),
		Size = UDim2.new(1, 0, 1, -module.Package.ToolBar.GetHeight()),
		Parent = module.gui
	}
	module.Package.GameEditor.Start(editorContainer)

	Engine.SheetAdded:Connect(module.AddSheetView)

	if not Engine.IsSetup() then
		local startPlugin = false
		repeat
			startPlugin = module.Package.Dialog.Prompt('New Project', 'Would you like to start a new SketchNode project?')
			if not startPlugin then
				module.gui.Enabled = false
			end
		until startPlugin
		Engine.Setup()
	end
end

function module.AddGameSheetButton(sheet)
	module.Package.GameEditor:AddSketchSheet(sheet)
end

return module
