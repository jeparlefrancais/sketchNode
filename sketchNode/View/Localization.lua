local English = {
	__langage = 'English',
	['NoSheetOpenedMessage'] = 'Open or Create a Sheet in\nLibrary > Game Sheets',
	['DialogYesButton'] = 'Yes',
	['DialogNoButton'] = 'No'
}

local Translations = {
	['fr-fr'] = {
		__langage = 'French',
		['NoSheetOpenedMessage'] = 'Ouvre ou crée une nouvelle Sheet\nLibrarie > Game Sheets',
		['DialogYesButton'] = 'Oui',
		['DialogNoButton'] = 'No'
	}
}

local fallbackDefault = {__index = function(t, key)
		warn(string.format('Entry <%s> is not localized in %s', key, t.__langage or 'Unknown'))
		return English[key]
	end
}
for langage, data in pairs(Translations) do
	setmetatable(data, fallbackDefault)
end

local module = {
	bindings = {}
}

function module.Init()
	module.currentLangage = Translations['fr-fr']--English
end

function module.Bind(instance, entry)
	--\Doc: Add the instance to list to update it whenever the theme changes. For example, Themes.Bind(textLabel, 'BackgroundColor3', 'Primary')
	instance, entry = module.Package.Utils.Tests.GetArguments(
		{'Instance', instance}, -- The object used to bind the property to the entry.
		{'string', entry} -- The entry from the theme data.
	)
	table.insert(module.bindings, {instance, entry})
	instance.Text = module.GetEntry(entry)
end

function module.GetEntry(entry) --ReturnType: string
	--\Doc: Returns the value stored at the given entry.
	if module.currentLangage[entry] == nil then
		warn(string.format('Entry <%s> does not exist in Localization.', entry))
	else
		return module.currentLangage[entry]
	end
end

function module.SetLangage(localeId)
	if localeId == 'en-us' then
		module.currentLangage = English
		module.Translate()
	else
		if Translations[localeId] == nil then
			warn(string.format('Translation in langage <%s> does not exist.', localeId))
		else
			module.currentLangage = Translations[localeId]
			module.Translate()
		end
	end
end

function module.Translate()
	for _, data in ipairs(module.bindings) do
		local instance, entry = unpack(data)
		instance.Text = module.GetEntry(entry)
	end
end

return module
