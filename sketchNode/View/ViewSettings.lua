local module = {}

module.DockWidgetInfo = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    true,
    false,
    600,
    400,
    500,
    400
)

module.Icons = {
    ["plugin"] = "rbxassetid://1915732154",
    ["save"] = "rbxassetid://1915730780",
    ["build"] = "rbxassetid://1915732154",
    ["preferences"] = "rbxassetid://1915731493",
    ["bug"] = "rbxassetid://1917695734",
    ["help"] = "rbxassetid://1917290667",
}

return module
