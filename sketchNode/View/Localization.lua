local English = {
	__langage = 'English',
	['tooltiptest'] = 'whatisthisbro',
	['NewProjectPromptTitle'] = 'New Project',
	['NewProjectPromptMessage'] = 'Would you like to start a new SketchNode project?',
	['NoSheetOpenedMessage'] = 'Open or Create a Sheet in\nLibrary > Game Sheets',
	['DialogYesButton'] = 'Yes',
	['DialogNoButton'] = 'No',
	['SaveButton'] = 'SAVE',
	['BuildButton'] = 'BUILD',
	['PreferencesButton'] = 'PREFERENCES',
	['BugButton'] = 'BUG',
	['HelpButton'] = 'HELP',
	['LibraryPanel'] = 'Library',
	['NodesPanel'] = 'Nodes',
	['AddSheetPlaceholderText'] = 'Add new Sheet..',
	['DeleteSheetPromptTitle'] = 'Delete Sheet?',
	['DeleteSheetPromptMessage'] = 'Are you sure you want to delete this sheet?'
}

local Translations = {
	['fr-fr'] = {
		__langage = 'French',
		['tooltiptest'] = 'thats pretty kewl',
		['NewProjectPromptTitle'] = 'Nouveau Projet',
		['NewProjectPromptMessage'] = 'Voulez-vous créer un projet SketchNode?',
		['NoSheetOpenedMessage'] = 'Ouvre ou crée une nouvelle Sheet\nLibrairie > Game Sheets',
		['DialogYesButton'] = 'Oui',
		['DialogNoButton'] = 'Non',
		['SaveButton'] = 'SAUVEGARDER',
		['BuildButton'] = 'COMPILER',
		['PreferencesButton'] = 'PRÉFERENCES',
		['BugButton'] = 'ERREUR',
		['HelpButton'] = 'AIDE',
		['LibraryPanel'] = 'Librairie',
		['NodesPanel'] = 'Nodes',
		['AddSheetPlaceholderText'] = 'Ajouter une Sheet..',
		['DeleteSheetPromptTitle'] = 'Supprimer la Sheet?',
		['DeleteSheetPromptMessage'] = 'Êtes-vous certain de vouloir supprimer la Sheet?'
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
	bindings = {},
	propertyBindings = {}
}

function module.Init()
	module.currentLangage = Translations['fr-fr']--English
end

function module.Bind(instance, entry)
	--\Doc: Add the instance to list to update it whenever the language changes. For example; Localization.Bind(welcomeText, 'WelcomeMessage')
	instance, entry = module.Package.Utils.Tests.GetArguments(
		{'Instance', instance}, -- The object used to bind the property to the entry.
		{'string', entry} -- The entry from the language data.
	)
	table.insert(module.bindings, {instance, entry})
	instance.Text = module.GetEntry(entry)
end

function module.BindProperty(instance, property, entry)
	--\Doc: Add the instance to list to update it whenever the theme changes. For example, Themes.Bind(textLabel, 'BackgroundColor3', 'Primary')
	instance, property, entry = module.Package.Utils.Tests.GetArguments(
		{'Instance', instance}, -- The object used to bind the property to the entry.
		{'string', property}, -- The property to bind.
		{'string', entry} -- The entry from the theme data.
	)
	table.insert(module.propertyBindings, {instance, property, entry})
	instance[property] = module.GetEntry(entry)
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
	for _, data in ipairs(module.propertyBindings) do
		local instance, property, entry = unpack(data)
		instance[property] = module.GetEntry(entry)
	end
end

return module
