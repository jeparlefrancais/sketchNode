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
	
	local editorContainer = module.Package.Templates.Container{
		Position = UDim2.new(0, 0, 0, module.Package.ToolBar.GetHeight()),
		Size = UDim2.new(1, 0, 1, -module.Package.ToolBar.GetHeight()),
		Parent = module.gui
	}
	module.Package.GameEditor.Start(editorContainer)

	Engine.SketchEngine.SheetAdded:Connect(module.AddSheetView)

	Engine.SketchEngine.AddSheet('Main')
end

function module.AddSheetView(sheet)
	module.Package.Grid.EditSheet(sheet)
end

return module
