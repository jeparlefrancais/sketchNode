local module = {}

function module.Start(plugin, Engine)
    -- build the actual UI
    module.gui = plugin:CreateDockWidgetPluginGui("SketchEngineView", module.Package.Settings.DockWidgetInfo)

    -- read the current content from the Engine

    -- connect to events to receive new content
end

return module
