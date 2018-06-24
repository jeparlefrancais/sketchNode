--\Description: No description yet.

local module = {
	bindings = {},
	multiBindings = {},
	currentTheme = nil
}

local Default = {
	GridBackgroundColor = Color3.fromRGB(255, 255, 255)
}

local ThemesData = {
	Light = {
		GridBackgroundColor = Color3.fromRGB(187, 244, 255)
	}
}

local fallbackDefault = {__index = Default}
for themeName, data in pairs(ThemesData) do
	setmetatable(data, fallbackDefault)
end

function module.Init()
	module.currentTheme = Default
end

function module.Bind(instance, property, entry)
	--\Doc: Add the instance to list to update it whenever the theme changes. For example, Themes.Bind(textLabel, 'BackgroundColor3', 'Primary')
	instance, property, entry = module.Package.Utils.Tests.GetArguments(
		{'Instance', instance}, -- The object used to bind the property to the entry. 
		{'string', property}, -- The property of the object used.
		{'string', entry} -- The entry from the theme data.
	)
	table.insert(module.bindings, {instance, property, entry})
	instance[property] = module.GetEntry(entry)
end

function module.BindMultiple(instance, propertiesEntryMap)
	--\Doc: Similar to Themes.Bind, except you can bind multiple propertes. For example, Themes.BindMultiple(textLabel, {BackgroundColor3 = 'Primary', TextColor3 = 'TitleColor'})
	instance, propertiesEntryMap = module.Package.Utils.Tests.GetArguments(
		{'Instance', instance}, -- The object used to bind the properties to the entry. 
		{'table', propertiesEntryMap} -- The keys are properties and values its theme entry.
	)
	table.insert(module.multiBindings, {instance, propertiesEntryMap})
	for property, entry in pairs(propertiesEntryMap) do
		instance[property] = module.GetEntry(entry)
	end
end

function module.GetEntry(entry) --ReturnType: any
	--\Doc: Returns the given value stored at the given entry.
	if module.currentTheme[entry] == nil then
		warn(string.format('Entry <%s> does not exist in Themes.', entry))
	else
		return module.currentTheme[entry]
	end
end

function module.SetTheme(themeName)
	print('Set theme', themeName)
	if themeName == 'Default' then
		module.currentTheme = Default
		module.ApplyTheme()
	else
		if ThemesData[themeName] == nil then
			warn(string.format('Theme named <%s> does not exist.', themeName))
		else
			module.currentTheme = ThemesData[themeName]
			module.ApplyTheme()
		end
	end
end

function module.ApplyTheme()
	for _, data in ipairs(module.bindings) do
		local instance, member, entry = unpack(data)
		instance[member] = module.GetEntry(entry)
		print('set entry', instance, entry)
	end
	for _, data in ipairs(module.multiBindings) do
		local instance, propertiesEntryMap = unpack(data)
		for property, entry in pairs(propertiesEntryMap) do
			instance[property] = module.GetEntry(entry)
		end
	end
end

return module
