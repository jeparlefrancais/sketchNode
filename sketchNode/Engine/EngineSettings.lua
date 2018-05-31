local module = {}

module.DataFolderName = "SketchEngineGameData"
module.ServiceFromAccess = {
    Shared = 'ReplicatedStorage',
	Client = 'ReplicatedFirst',
	Server = 'ServerStorage'
}
module.FolderFromType = {
    Module = 'Modules',
    Class = 'Classes',
    Function = 'Functions'
}
module.TestsScriptName = 'Tests'

return module
