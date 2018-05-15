--\Description: This is the engine of the plugin. It holds all the game infos.

local STO = game:GetService('ServerStorage')
local HTTP = game:GetService('HttpService')

local module = {}

function module.Start()
	print('SketchEngine init.')
	module.dataFolder = STO:FindFirstChild(module.Package.EngineSettings.DataFolderName)
	if module.dataFolder then
		-- reload data
	end

	module.saving = false
end

function module.Setup()
	--\Doc: This function setups the place to be able to use this plugin. It creates the necessary folder(s).
	module.dataFolder =
		module.Package.Utils.Create'Folder'{
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

function module.Save(comment) --\ReturnType: boolean
	--\Doc: Save the SketchNode project in the data folder. Returns true if the data was saved.
	if not module.saving then
		module.saving = true

		local data =
			module.Package.Utils.Create'StringValue'{
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
	json = class.Package.Utils.Tests.GetArguments(
        {'string', json} -- The json string with the project data.
	)
	local data = HTTP:JSONDecode(json)
	module.version = data.version
	module.classes = module.Package.LoadTable(data.classes, module.Package.Classes.Class)
	module.modules = module.Package.LoadTable(data.modules, module.Package.Classes.Module)
end

function module.Compile(flags)
	--\Doc: Compiles the SketchNode project into the place. Overwrites the actual compiled version.
	flags = class.Package.Utils.Tests.GetArguments(
        {'table', flags} -- Dictionary of flags.
	)
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
end

function module.GetVersion() --\ReturnType: string
	--\Doc: Returns the version of the saved file.
	return string.format('%d.%d.%x', module.version.released, module.version.compiled, module.version.saved)
end

return module
