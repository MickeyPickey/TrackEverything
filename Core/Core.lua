local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon

-- inite core services
local Log = TE.Init('Util.Log')
local Settings = TE.Init('Service.Settings', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0')
local Icon = TE.Init('Service.Icon', 'AceEvent-3.0')
local AutoTracker = TE.Init('Service.AutoTracker', 'AceTimer-3.0', 'AceConsole-3.0', 'AceEvent-3.0')
local SlashCommands = TE.Init('Service.SlashCommands', 'AceConsole-3.0', 'AceEvent-3.0')