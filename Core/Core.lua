local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local MyLib = TE.Include("Util.MyLib")
ADDON_TABLE.ADDON_NAME_ACRONYM = MyLib.Acronym(ADDON_TABLE.ADDON_NAME)

-- inite core services
TE.Init("Colors")
TE.Init("Log")
TE.Init("Settings", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
TE.Init("Icon", "AceEvent-3.0")
TE.Init("SpellSwitcher", "AceTimer-3.0", "AceConsole-3.0", "AceEvent-3.0")
TE.Init("SlashCommands", "AceConsole-3.0", "AceEvent-3.0")
TE.Init("GatheringInfo", "AceEvent-3.0")
TE.Init("Tooltip", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
