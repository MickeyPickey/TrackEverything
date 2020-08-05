local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local Log = TE.Include('Util.Log')
local MyLib = TE.Include('Util.MyLib')
ADDON_TABLE.ADDON_NAME_ACRONYM = MyLib.Acronym(ADDON_TABLE.ADDON_NAME)

-- inite core services
local Settings = TE.Init('Service.Settings', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local Icon = TE.Init('Service.Icon', 'AceEvent-3.0')
local AutoTracker = TE.Init('Service.AutoTracker', 'AceTimer-3.0', 'AceConsole-3.0', 'AceEvent-3.0')
local SlashCommands = TE.Init('Service.SlashCommands', 'AceConsole-3.0', 'AceEvent-3.0')
local GatheringTooltipInfo = TE.Init('Service.GatheringTooltipInfo', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

