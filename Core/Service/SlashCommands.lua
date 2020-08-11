local FOLDER_NAME, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local SlashCommands = TE.Include("Service.SlashCommands")
local Colors = TE.Include("Data.Colors")
local GatheringData = TE.Include("Data.Gathering")
local Settings = TE.Include("Service.Settings")
local AutoTracker = TE.Include("Service.AutoTracker")
local Icon = TE.Include("Service.Icon")
local Log = TE.Include("Util.Log")
local MyLib = TE.Include("Util.MyLib")
local L = TE.Include("Locale")

local ENABLED_COLOR = Colors:GetColorByName("GREEN2")
local DISABLED_COLOR = Colors:GetColorByName("RED")
local COMMAND_COLOR = Colors:GetColorByName("KHAKI")

local COMMANDS = {
  [string.lower(FOLDER_NAME)] = {
    callback = "ChatCommand"
  },
  ["te"] = {
    callback = "ChatCommand"
  },
} 

local SLASH_COMMAND_ARGUMENTS = {
  {
    name = "toggle",
    desc = L["Enable/disable addon"],
    print = function() return L["addon is [%s]"], SlashCommands:GetColoredAddonState() end,
    hidden = false,
    callback = function() Settings:Toggle() end,
    order = 1,
  },
  {
    name = "enable",
    desc = L["Enable addon"],
    print = function() return L["addon is [%s]"], SlashCommands:GetColoredAddonState() end,
    hidden = false,
    callback = function() Settings:Enable() end,
    order = 2,
  },
  {
    name = "disable",
    desc = L["Disable addon"],
    print = function() return L["addon is [%s]"], SlashCommands:GetColoredAddonState() end,
    hidden = false,
    callback = function() Settings:Disable() end,
    order = 3,
  },
  {
    name = "onmove",
    desc = L["Enable/disable only while moving mode"],
    print = function() return L["Only while moving is [%s]"], SlashCommands:GetColoredOnMoveState() end,
    hidden = false,
    callback = function() Settings:ToggleOnMove() end,
    order = 4,
  },
  {
    name = "mute",
    desc = L["Mute spell use sound"],
    print = function() return L["Mute spell use sound is [%s]"], SlashCommands:GetColoredMuteState() end,
    hidden = false,
    callback = function() TE.db.profile.general.muteSpellUseSound = not TE.db.profile.general.muteSpellUseSound end,
    order = 5,
  },
  {
    name = "tooltip world",
    desc = L["Enable/disable required profession level on World tooltips"],
    print = function() return L["Required profession level on World tooltips is [%s]"], SlashCommands:GetColoredToggleState(TE.db.profile.tooltip.requiredProfessionLevel.enableWorld) end,
    hidden = false,
    callback = function() TE.db.profile.tooltip.requiredProfessionLevel.enableWorld = not TE.db.profile.tooltip.requiredProfessionLevel.enableWorld end,
    order = 5,
  },
  {
    name = "tooltip minimap",
    desc = L["Enable/disable required profession level on Minimap tooltips"],
    print = function() return L["Required profession level on Minimap tooltips is [%s]"], SlashCommands:GetColoredToggleState(TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap) end,
    hidden = false,
    callback = function() TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap = not TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap end,
    order = 5,
  },
  {
    name = "tooltip worldmap",
    desc = L["Enable/disable required profession level on World Map tooltips"],
    print = function() return L["Required profession level on World Map tooltips sis [%s]"], SlashCommands:GetColoredToggleState(TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap) end,
    hidden = false,
    callback = function() TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap = not TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap end,
    order = 5,
  },
  {
    name = "settings",
    desc = L["Open settings"],
    callback = function() Settings:OpenOptionsFrame() end,
    hidden = false,
    order = 6,
  },
  {
    name = "help",
    desc = L["Show this description"],
    hidden = false,
    callback = function() SlashCommands:PrintCommands() end,
    order = 97,
  },
  {
    name = "reset",
    desc = L["Reset settings to defaults"],
    print = L["Settings was reset to defaults"],
    hidden = false,
    callback = function() Settings:ResetProfile() end,
    order = 98,
  },
  { 
    name = "colors",
    hidden = true,
    callback = function() Log:Print(Colors:GetStrColors()) end,
    order = 99,
  },
  { 
    name = "getTooltipInfo",
    hidden = true,
    callback = function() 
      if GameTooltip:IsShown() then
        for i = 1, GameTooltip:NumLines() do
          local line = _G["GameTooltipTextLeft"..i]
          local fontName, fontHeight, fontFlags = line:GetFont()
          local fontObject = line:GetFontObject()
          local fontObjectName = ""
          if fontObject then fontObjectName = fontObject:GetName() end
          local r, g, b, a = line:GetTextColor()

          Log:Print("Line", i, ":", "(", line:GetText() ,")")
          Log:PrintRaw("fontObjectName:", Colors:GetColorByName("MAGENTA")..fontObjectName.."|r")
          Log:PrintRaw("fontName:", fontName)
          Log:PrintRaw("fontHeight:", Colors:GetColorByName("RED")..fontHeight.."|r", "fontFlags:", fontFlags)
          Log:PrintRaw("Colors: ", r, g, b, a)
        end
      end
    end,
    order = 99,
  },
  {
    name = "test",
    hidden = true,
    callback = function() SlashCommands:Test() end,
    order = 100,
  },
}

function SlashCommands:OnInitialize()
  self:RegisterChatCommands(COMMANDS)
end

function SlashCommands:OnEnable()
  Log:Printf(L[" %s. Type %s to see all chat commands. Have a nice game! :)"], self:GetColoredAddonState(),  self:GetChatCommands())
end

function SlashCommands:ChatCommand(input)
  local args = MyLib.splitString(input:trim(), " ")
  local option = nil

  if #args == 1 then
    option = self:GetOptionByName(args[1])
  elseif #args == 2 then
    option = self:GetOptionByName(args[1].." "..args[2])
  end

  if option then
    option.callback()
    if option.print then
      Log:Printf(option.print())
    end
  else
    self:PrintCommands()
  end
end

function SlashCommands:PrintCommands()
  Log:Printf(L["Arguments to %s :"], self:GetChatCommands())

  table.sort(SLASH_COMMAND_ARGUMENTS, function(a,b) return a.order < b.order end)

  for i, option in ipairs(SLASH_COMMAND_ARGUMENTS) do
    if not option.hidden then
      Log:PrintfRaw("  %s%s|r - %s", COMMAND_COLOR, option.name, option.desc)
    end
  end
end

function SlashCommands:RegisterChatCommands(commandTable)
  for name, func in pairs(commandTable) do
    self:RegisterChatCommand(name, commandTable[name].callback)
  end
end

function SlashCommands:GetColoredAddonState()
  if TE.db.profile.general.enable then return ENABLED_COLOR..L["enabled"].."|r" else return DISABLED_COLOR..L["disabled"].."|r" end
end

function SlashCommands:GetColoredOnMoveState()
  if TE.db.profile.general.onmove then return ENABLED_COLOR..L["enabled"].."|r" else return DISABLED_COLOR..L["disabled"].."|r" end
end

function SlashCommands:GetColoredMuteState()
  if TE.db.profile.general.muteSpellUseSound then return ENABLED_COLOR..L["enabled"].."|r" else return DISABLED_COLOR..L["disabled"].."|r" end
end

function SlashCommands:GetColoredMuteState()
  if TE.db.profile.general.muteSpellUseSound then return ENABLED_COLOR..L["enabled"].."|r" else return DISABLED_COLOR..L["disabled"].."|r" end
end

function SlashCommands:GetColoredToggleState(dbSetting)
  if dbSetting then return ENABLED_COLOR..L["enabled"].."|r" else return DISABLED_COLOR..L["disabled"].."|r" end 
end



function SlashCommands:GetChatCommands()
  local strTable = {}
  for k, v in pairs(COMMANDS) do
    table.insert(strTable, COMMAND_COLOR.."/"..k.."|r")
  end

  return table.concat(strTable, L[" or "])
end

function SlashCommands:GetOptionByName(name)
  assert(name and type(name) == "string" or name == nil, format("Wrong name type. Awaited 'string', got '%s'", type(name)))
  if name == nil then return nil end

  for i, option in ipairs(SLASH_COMMAND_ARGUMENTS) do
    if option.name == name then return option end
  end

  return nil
end

function SlashCommands:Test()
  local dataEnum = Enum.MineNodes
  print(dataEnum)
end