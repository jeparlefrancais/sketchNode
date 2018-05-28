local module = {}

function module.SetPlugin(plugin)
    module.plugin = plugin
end

function module.OpenScript(scriptObject, line)
	scriptObject, line = module.Package.Utils.Tests.GetArguments(
        {'LuaSourceContainer', scriptObject},
        {'number', line, 1}
    )
    module.plugin:OpenScript(scriptObject, line)
end

return module
