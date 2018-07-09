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
    ['plugin'] = 'rbxassetid://1915732154',
    ['save'] = 'rbxassetid://1915730780',
    ['build'] = 'rbxassetid://1915732154',
    ['preferences'] = 'rbxassetid://1915731493',
    ['bug'] = 'rbxassetid://1917695734',
    ['help'] = 'rbxassetid://1917290667',
    ['delete'] = 'rbxassetid://2023767449',
    ['label'] = 'rbxassetid://2023778246',
    ['favorite'] = 'rbxassetid://2023776605',
    ['favorited'] = 'rbxassetid://2023777394',
}

module.NodesFolderInputs = {
	'boolean',
	'string',
	'number'
}

module.NodesFolderServices = {
	'Lighting',
	'ReplicatedFirst',
	'ReplicatedStorage',
	'RunService',
	'ServerStorage',
	'Workspace'
}

module.ToolTipWaitTime = 1
module.ToolTipMinimumTime = .5

return module
