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
	end
end

function module.IsSetup()
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
			modules = module.Package.SerializeTable(module.modules)
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

	for _, classObject in ipairs(module.classes) do
		module.ClassAdded:Fire(classObject)
	end
	for _, moduleObject in ipairs(module.modules) do
		module.ModuleAdded:Fire(moduleObject)
	end
end

function module.Compile(flags)
	--\Doc: Compiles the SketchNode project into the place. Overwrites the actual compiled version.
	flags = module.Package.Utils.Tests.GetArguments(
        {'table', flags} -- Dictionary of flags.
	)
	if not module.compiling then
		module.compiling = true

		spawn(function()
			-- generate the game files
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
	--Doc: Adds a module to the game project
	table.insert(module.modules, moduleObject)
	module.ModuleAdded:Fire(moduleObject)
end

return module
