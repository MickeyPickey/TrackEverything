local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local MyLib = TE.Include("Util.MyLib")
ADDON_TABLE.ADDON_NAME_SHORT = MyLib.Acronym(ADDON_TABLE.ADDON_NAME)

_G.TE = TE
TE.wowVersionString, TE.wowBuild, _, TE.wowTOC = GetBuildInfo()
TE.testBuild = IsTestBuild()
TE.isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
TE.isClassicEra = WOW_PROJECT_ID == (WOW_PROJECT_CLASSIC or 2)
TE.isBCC = WOW_PROJECT_ID == (WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5)
TE.isWrath = WOW_PROJECT_ID == (WOW_PROJECT_WRATH_CLASSIC or 11)
TE.isClassicEraOrBCC = TE.isClassicEra or TE.isBCC

-- inite core services
TE.Init("Colors")
TE.Init("Log")
TE.Init("TrackingInfo")
TE.Init("Settings", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
TE.Init("Icon", "AceEvent-3.0")
TE.Init("SpellSwitcher", "AceTimer-3.0", "AceConsole-3.0", "AceEvent-3.0")
TE.Init("SlashCommands", "AceConsole-3.0", "AceEvent-3.0")
TE.Init("GatheringInfo", "AceEvent-3.0")
TE.Init("Tooltip", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
