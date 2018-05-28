local module = {}

function module.Start(plugin, Engine)
    -- build the actual UI
    module.gui = plugin:CreateDockWidgetPluginGui("SketchEngineView", module.Package.ViewSettings.DockWidgetInfo)
    module.gui.Title = "sketchnode"
    module.gui.Name = "sketchnode"

    -- read the current content from the Engine
    module.Package.Grid.Start(module.gui)
    -- connect to events to receive new content
end

return module
