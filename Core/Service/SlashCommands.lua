local FOLDER_NAME, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local ADDON_AUTHOR_GAME_INFO = ADDON_TABLE.ADDON_AUTHOR_GAME_INFO
local SlashCommands = TE.Include("SlashCommands")
local Colors = TE.Include("Colors")
local Settings = TE.Include("Settings")
local SpellSwitcher = TE.Include("SpellSwitcher")
local Log = TE.Include("Log")
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
    name = "switcher toggle",
    desc = L["Enable/disable auto spell switching"],
    print = function() return L["Spell switching is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.spellSwitcher.enabled) end,
    hidden = false,
    callback = function()
      TE.db.profile.spellSwitcher.enabled = not TE.db.profile.spellSwitcher.enabled
      SlashCommands:SendMessage("SPELL_SWITCHER_TOGGLED")
    end,
    order = 1,
  },
  {
    name = "switcher enable",
    desc = L["Enable auto spell switching"],
    print = function() return L["Spell switching is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.spellSwitcher.enabled) end,
    hidden = true,
    callback = function()
      TE.db.profile.spellSwitcher.enabled = true
      SlashCommands:SendMessage("SPELL_SWITCHER_TOGGLED")
    end,
    order = 2,
  },
  {
    name = "switcher disable",
    desc = L["Disable auto spell switching"],
    print = function() return L["Spell switching is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.spellSwitcher.enabled) end,
    hidden = true,
    callback = function()
      TE.db.profile.spellSwitcher.enabled = false
      SlashCommands:SendMessage("SPELL_SWITCHER_TOGGLED")
    end,
    order = 3,
  },
  {
    name = "switcher onmove",
    desc = L["Enable/disable spell switching only while moving mode"],
    print = function() return L["Spell switching only while moving is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.spellSwitcher.onmove) end,
    hidden = false,
    callback = function()
      TE.db.profile.spellSwitcher.onmove = not TE.db.profile.spellSwitcher.onmove
      SlashCommands:SendMessage("SPELL_SWITCHER_MODE_TOGGLED")
    end,
    order = 4,
  },
  {
    name = "mute",
    desc = L["Mute spell use sound"],
    print = function() return L["Mute spell use sound is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.spellSwitcher.muteSpellSwitchSound) end,
    hidden = false,
    callback = function() TE.db.profile.spellSwitcher.muteSpellSwitchSound = not TE.db.profile.spellSwitcher.muteSpellSwitchSound end,
    order = 5,
  },
  {
    name = "tooltip world",
    desc = L["Enable/disable required profession level on World tooltips"],
    print = function() return L["Required profession level on World tooltips is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.tooltip.requiredProfessionLevel.enableWorld) end,
    hidden = false,
    callback = function() TE.db.profile.tooltip.requiredProfessionLevel.enableWorld = not TE.db.profile.tooltip.requiredProfessionLevel.enableWorld end,
    order = 6,
  },
  {
    name = "tooltip minimap",
    desc = L["Enable/disable required profession level on Minimap tooltips"],
    print = function() return L["Required profession level on Minimap tooltips is [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap) end,
    hidden = false,
    callback = function() TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap = not TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap end,
    order = 6,
  },
  {
    name = "tooltip worldmap",
    desc = L["Enable/disable required profession level on World Map tooltips"],
    print = function() return L["Required profession level on World Map tooltips sis [%s]"], SlashCommands:GetColoredSettingState(TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap) end,
    hidden = false,
    callback = function() TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap = not TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap end,
    order = 6,
  },
  {
    name = "settings",
    desc = L["Open settings"],
    callback = function() Settings:OpenOptionsFrame() end,
    hidden = false,
    order = 7,
  },
  {
    name = "help",
    desc = QUEST_DESCRIPTION,
    hidden = false,
    callback = function() SlashCommands:PrintCommands() end,
    order = 97,
  },
  {
    name = "reset",
    desc = RESET_TO_DEFAULT,
    print = function() return L["Settings have been reset to default"] end,
    hidden = false,
    callback = function() Settings:ResetProfile() end,
    order = 98,
  },
  {
    name = "author",
    desc = L["Print information about Author"],
    print = function() return ADDON_AUTHOR_GAME_INFO end,
    hidden = false,
    callback = function() end,
    order = 99,
  },
  {
    name = "debug",
    desc = "",
    print = function() return "Debug is [%s]", SlashCommands:GetColoredSettingState(Log:GetDubugState()) end,
    hidden = true,
    callback = function() Log:DebugToggle() end,
    order = 99,
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
    callback = function() SpellSwitcher:IsFlyingForm() end,
    order = 100,
  },
}

function SlashCommands:OnInitialize()
  self:RegisterChatCommands(COMMANDS)
end

function SlashCommands:OnEnable()
  Log:Printf(L[" Spell switching: %s, Type %s to see all chat commands. Have a nice day! :)"], self:GetColoredSettingState(TE.db.profile.spellSwitcher.enabled), self:GetChatCommands())
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

  for _, option in ipairs(SLASH_COMMAND_ARGUMENTS) do
    if not option.hidden then
      Log:PrintfRaw("  %s%s|r - %s", COMMAND_COLOR, option.name, option.desc)
    end
  end
end

function SlashCommands:RegisterChatCommands(commandTable)
  for name in pairs(commandTable) do
    self:RegisterChatCommand(name, commandTable[name].callback)
  end
end

function SlashCommands:GetColoredSettingState(dbSetting)
  if dbSetting then return ENABLED_COLOR..VIDEO_OPTIONS_ENABLED.."|r" else return DISABLED_COLOR..ADDON_DISABLED.."|r" end
end

function SlashCommands:GetChatCommands()
  local strTable = {}
  for k in pairs(COMMANDS) do
    table.insert(strTable, COMMAND_COLOR.."/"..k.."|r")
  end

  return table.concat(strTable, " "..OR_CAPS:lower().." ")
end

function SlashCommands:GetOptionByName(name)
  assert(name and type(name) == "string" or name == nil, format("Wrong name type. Awaited 'string', got '%s'", type(name)))
  if name == nil then return nil end

  for _, option in ipairs(SLASH_COMMAND_ARGUMENTS) do
    if option.name == name then return option end
  end

  return nil
end

function SlashCommands:Test()

end