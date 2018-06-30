--\Description: This is the engine of the plugin. It holds all the game infos.

local STO = game:GetService('ServerStorage')
local HTTP = game:GetService('HttpService')

local module = {}

function module.Init()
	module.__signals = {
		ClassAdded = {
			'Class' -- newClass
		},
		ModuleAdded = {
			'Module' -- newModule
        },
        SheetAdded = {
            'SketchSheet' -- newSheet
        }
	}
end

function module.Start()
	module.Package.Utils.Signal.SetSignals(module, module)
	
	module.dataFolder = STO:FindFirstChild(module.Package.EngineSettings.DataFolderName)
	if module.dataFolder then
		-- reload data
	end

	module.saving = false
	module.compiling = false
end

function module.Setup()
	--\Doc: This function setups the place to be able to use this plugin. It creates the necessary folder(s).
	if not module.IsSetup() then
		module.dataFolder = module.Package.Utils.Create'Folder'{
			Name = module.Package.EngineSettings.DataFolderName,
			Parent = STO
		}

		module.version = {
			released = 0,
			compiled = 0,
			saved = 0
		}

		module.classes = {}
        module.modules = {}
		module.sheets = {}
		
		module.AddSheet('MainSheet')
	end
end

function module.IsSetup() --\ReturnType: boolean
	--\Doc: Returns true if the plugin is enabled.
	return module.dataFolder ~= nil
end

function module.Save(comment) --\ReturnType: boolean
	--\Doc: Save the SketchNode project in the data folder. Returns true if the data was saved.
	if not module.saving then
		module.saving = true

		spawn(function()
			local data = module.Package.Utils.Create'StringValue'{
				Name = module.GetVersion(),
				Value = module.Serialize(),
				Parent = module.dataFolder
			}
			module.Package.Utils.Create'IntValue'{
				Name = 'Time',
				Value = tick(),
				Parent = data
			}
			module.Package.Utils.Create'IntValue'{
				Name = 'UserId',
				Value = plugin:GetStudioUserId(),
				Parent = data
			}
			module.Package.Utils.Create'StringValue'{
				Name = 'Comment',
				Value = comment,
				Parent = data
			}

			module.version.saved = module.version.saved + 1
			module.saving = false
		end)
		
		return true
	else
		return false
	end
end

function module.Serialize() --\ReturnType: string
	--\Doc: Packs all the SketchNode project into a json string.
	return HTTP:JSONEncode(
		{
			version = module.version,
			classes = module.Package.SerializeTable(module.classes),
            modules = module.Package.SerializeTable(module.modules),
            sheets = module.Package.SerializeTable(module.sheets)
		}
	)
end

function module.Load(json)
	--\Doc: Loads a SketchNode project from the given json string.
	json = module.Package.Utils.Tests.GetArguments(
        {'string', json} -- The json string with the project data.
	)
	local data = HTTP:JSONDecode(json)
	module.version = data.version
	module.classes = module.Package.LoadTable(data.classes, module.Package.Classes.Class)
    module.modules = module.Package.LoadTable(data.modules, module.Package.Classes.Module)
    module.sheets = module.Package.LoadTable(data.sheets, module.Package.Classes.SketchSheet)

	for _, classObject in ipairs(module.classes) do
		module.ClassAdded:Fire(classObject)
	end
	for _, moduleObject in ipairs(module.modules) do
		module.ModuleAdded:Fire(moduleObject)
	end
	for _, sheet in ipairs(module.sheets) do
		module.SheetAdded:Fire(sheet)
	end
end

function module.Clear()
	--\Doc: Clears all objects created from compiling the project.
	for access, service in pairs(module.Package.EngineSettings.ServiceFromAccess) do
		for sourceType, folder in pairs(module.Package.EngineSettings.FolderFromType) do
			local folder = game:GetService(service):FindFirstChild(access .. sourceType)
			if folder then
				folder:Destroy()
			end
		end
	end
end

function module.Compile(flags)
	--\Doc: Compiles the SketchNode project into the place. Overwrites the actual compiled version.
	flags = module.Package.Utils.Tests.GetArguments(
        {'table', flags} -- Dictionary of flags (Tests, Obfuscate, Release).
	)
	if not module.compiling then
		module.compiling = true
		if not module.IsSetup() then
			module.Setup()
		end

		spawn(function()
			module.Clear() -- clear previous compiled objects

			local folders = {}
			for access, service in pairs(module.Package.EngineSettings.ServiceFromAccess) do
				folders[access] = {}
				for sourceType, folder in pairs(module.Package.EngineSettings.FolderFromType) do
					folders[access][sourceType] = module.Package.Utils.Create'Folder'{
						Name = access .. sourceType,
						Parent = game:GetService(service)
					}
				end
			end

			-- generate default files
			if flags.Tests then
				module.Package.Utils.Create'ModuleScript'{
					Name = module.Package.EngineSettings.TestsScriptName,
					Source = module.Package.Resources.Tests,
					Parent = folders.Shared.Function
				}
			end

			-- generate the game files
			for _, moduleObject in ipairs(module.modules) do
				local source = module.Package.Compiler.CompileModule(moduleObject, flags.Tests)
				if flags.Obfuscate then

				end
				module.Package.Utils.Create'ModuleScript'{
					Name = moduleObject:GetName(),
					Source = source,
					Parent = folders[module:IsServer() and 'Server' or 'Client'].Module
				}
				-- for some functions in modules, create remotes events/functions
			end

			for _, classObject in ipairs(module.classes) do
				if not classObject:IsAbstract() then
					local source = module.Package.Compiler.CompileClass(classObject, flags.Tests)
				end
			end

			-- obfuscate if flags.Obfuscate
			if flags.Release then
				module.version.released = module.version.released + 1
				module.version.compiled = 0
				module.version.saved = 0
			else
				module.version.compiled = module.version.compiled + 1
				module.version.saved = 0
			end
			module.compiling = false
		end)

		return true
	else
		return false
	end
end

function module.GetVersion() --\ReturnType: string
	--\Doc: Returns the version of the saved file.
	return string.format('%d.%d.%x', module.version.released, module.version.compiled, module.version.saved)
end

function module.AddClass(classObject)
	--\Doc: Adds a class to the game project
	table.insert(module.classes, classObject)
	module.ClassAdded:Fire(classObject)
end

function module.AddModule(moduleObject)
	--\Doc: Adds a module to the game project.
	table.insert(module.modules, moduleObject)
	module.ModuleAdded:Fire(moduleObject)
end

function module.AddSheet(sheetName)
    --\Doc: Adds a new sheet to the game project.
	sheetName = module.Package.Utils.Tests.GetArguments(
        {'string', sheetName, 'NewSheet'} -- Name of the sheet to create.
    )
	local sheet = module.Package.Classes.SketchSheet:New(sheetName)
	sheet:CreateNode(module.Package.Classes.ObjectReference:New(game:GetService('RunService'), 'RenderStepped'))
    module.SheetAdded:Fire(sheet)
end

return module
