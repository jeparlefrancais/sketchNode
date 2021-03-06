local function LoadPackage(folder, topPackage, initFunctions)
	local init = false
	if initFunctions == nil then
		init = true
		initFunctions = {}
	end
	local package = {}
	for _, child in ipairs(folder:GetChildren()) do
		local success = pcall(function()
			package[child.Name] = child:IsA('ModuleScript') and require(child) or LoadPackage(child, topPackage or package, initFunctions)
		end)
		
		if not success then
			error(string.format('Error loading module script "%s"', child:GetFullName()))
		end
		
		if type(package[child.Name]) == 'table' then
			if type(package[child.Name].Init) == 'function' then
				table.insert(initFunctions, package[child.Name].Init)
			end
			if package[child.Name].Package == nil then
				package[child.Name].Package = topPackage or package
			else
				warn(string.format('Package named %s override the <Package> table.', child.Name))
			end
		end
	end
	if init then
		for _, f in ipairs(initFunctions) do f() end
	end
	return package
end

local Utils = LoadPackage(script.Parent:WaitForChild('Utils'))
local Engine = LoadPackage(script.Parent:WaitForChild('Engine'))
Engine.Utils = Utils
local View = LoadPackage(script.Parent:WaitForChild('View'))
View.Utils = Utils

Engine.ScriptEditor.SetPlugin(plugin)
Engine.LuaMetadata.Start()
Engine.SketchEngine.Start()
View.Main.Start(plugin, Engine.SketchEngine)
