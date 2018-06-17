local module = {}

function module.Start(plugin, Engine)
    -- build the actual UI
    module.gui = plugin:CreateDockWidgetPluginGui("SketchEngineView", module.Package.ViewSettings.DockWidgetInfo)
    module.gui.Title = "sketchnode"
    module.gui.Name = "sketchnode"
    module.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local pluginToolbar = plugin:CreateToolbar("Sketchnode")
    pluginToolbar:CreateButton("Launch", "Start the Editor", module.Package.ViewSettings.Icons['plugin']).Click:Connect(function()
        module.gui.Enabled = not module.gui.Enabled
    end)

    -- read the current content from the Engine
    module.Package.Grid.Start(module.gui)
    module.Package.ToolBar.Start(module.gui)

    module.Package.ToolBar.CreateButton("save", "save", true, function() end)
    module.Package.ToolBar.CreateButton("build", "build", true, function() end)
    module.Package.ToolBar.CreateButton("bug", "bug", false, function() end)
    module.Package.ToolBar.CreateButton("help", "help", false, function() end)

    local arg1 = Engine.Classes.Argument:New('plutonem', 'Instance', nil, false)
    local arg2 = Engine.Classes.Argument:New('health', 'number', 100, false)
    local arg3 = Engine.Classes.Argument:New('oopsi', 'number', 10, true)
    local tv1 = Engine.Classes.TypedVariable:New('isDead', 'boolean', false)
    local newFunction = Engine.Classes.Function:New("KillPlutonem", {arg1, arg2, arg3}, {tv1})

    module.Package.Classes.FunctionView.New({}, module.Package.Grid.gridImage, newFunction)
    -- connect to events to receive new content

end

return module
