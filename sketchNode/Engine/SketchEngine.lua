local STO = game:GetService("ServerStorage")
local HTTP = game:GetService("HttpService")

local module = {}

function module.Start()
	print("SketchEngine init.")
	module.dataFolder = STO:FindFirstChild(module.Package.Settings.DataFolderName)
	if module.dataFolder then
		-- reload data
	else
		module.Setup()
	end

	module.saving = false
end

function module.Setup()
	module.dataFolder =
		module.Package.Utils.Create"Folder"{
		Name = module.Package.Settings.DataFolderName,
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

function module.Save(comment)
	if not module.saving then
		module.saving = true
		module.version.saved = module.version.saved + 1

		local data =
			module.Package.Utils.Create"StringValue"{
			Name = module.GetVersion(),
			Value = module.Serialize(),
			Parent = module.dataFolder
		}
		module.Package.Utils.Create"IntValue"{
			Name = "Time",
			Value = tick(),
			Parent = data
		}
		module.Package.Utils.Create"IntValue"{
			Name = "UserId",
			Value = plugin:GetStudioUserId(),
			Parent = data
		}
		module.Package.Utils.Create"StringValue"{
			Name = "Comment",
			Value = comment,
			Parent = data
		}
		module.saving = false
		return true
	else
		return false
	end
end

function module.Serialize()
	return HTTP:JSONEncode(
		{
			version = module.version,
			classes = module.Package.SerializeTable(module.classes),
			modules = module.Package.SerializeTable(module.modules)
		}
	)
end

function module.Load(json)
	local data = HTTP:JSONDecode(json)
	module.version = data.version
	module.classes = module.Package.LoadTable(data.classes, module.Package.Classes.Class)
	module.modules = module.Package.LoadTable(data.modules, module.Package.Classes.Module)
end

function module.Compile(flags)
	if flags.Release then
		module.version.released = module.version.released + 1
		module.version.compiled = 0
		module.version.saved = 0
	else
		module.version.compiled = module.version.compiled + 1
		module.version.saved = 0
	end
	-- generate the game files
	-- obfuscate if flags.Obfuscate
end

function module.GetVersion()
	return string.format("%d.%d.%x", module.version.released, module.version.compiled, module.version.saved)
end

return module
