--\Description: No description yet.

local module = {
	bindings = {},
	multiBindings = {},
	currentTheme = nil
}

local Default = {
	-- Basic
	ToolBarColor = Color3.fromRGB(30, 30, 30),
	ToolBarTextColor = Color3.new(1, 1, 1),
	ToolBarSpacerColor = Color3.fromRGB(50, 50, 50),
	GridImage = "rbxassetid://1837504812",
	ButtonImage = "rbxassetid://1858994698",
	ContainerColor = Color3.fromRGB(38, 38, 38),
	ContainerBorderColor = Color3.fromRGB(30, 30, 30),
	TextColor = Color3.fromRGB(249, 249, 249),
	-- Node
	NodeImage = "rbxassetid://1840836042",
	NodeTitleImage = "rbxassetid://1840881064",
	NodeTitleTextColor = Color3.new(1, 1, 1),
	TriggerColor = Color3.fromRGB(56, 56, 56),
	ConnectorStrokeColor = Color3.fromRGB(39, 39, 39),
	ConnectorTypeColor = Color3.fromRGB(150, 150, 150),
	ConnectorValueColor = Color3.fromRGB(240, 240, 240),
}

local ThemesData = {
	Light = {
		ToolBarColor = Color3.fromRGB(214, 214, 214),
		ToolBarTextColor = Color3.fromRGB(130, 130, 130),
		ToolBarSpacerColor = Color3.fromRGB(170, 170, 170),
		GridColor = Color3.fromRGB(249, 249, 249),
		GridImage = "rbxassetid://2001453925",
		ButtonImage = "rbxassetid://2002071217",
		ContainerColor = Color3.fromRGB(217, 217, 217),
		ContainerBorderColor = Color3.fromRGB(185, 185, 185),
		TextColor = Color3.fromRGB(70, 70, 70),
		-- Node
		NodeImage = "rbxassetid://2002072726",
		NodeTitleImage = "rbxassetid://2002073241",
		TriggerColor = Color3.fromRGB(240, 240, 240),
		ConnectorStrokeColor = Color3.fromRGB(214, 214, 214),
		ConnectorValueColor = Color3.fromRGB(106, 106, 106),
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
	end
	for _, data in ipairs(module.multiBindings) do
		local instance, propertiesEntryMap = unpack(data)
		for property, entry in pairs(propertiesEntryMap) do
			instance[property] = module.GetEntry(entry)
		end
	end
end

return module
