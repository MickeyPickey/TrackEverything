local FOLDER_NAME, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local TE = ADDON_TABLE.Addon
local Colors = TE.Include("Data.Colors")
local Icon = TE.Include("Service.Icon")
local Settings = TE.Include("Service.Settings")
local SpellSwitcher = TE.Include("Service.SpellSwitcher")
local L = TE.Include("Locale")

local private = {
  embeded = false,
  ldb = nil,
  icon = nil,
  GAME_EVENTS = {
    ["MINIMAP_UPDATE_TRACKING"] = true,
  },
  USER_EVENTS = {
    ["SPELL_SWITCHER_TOGGLED"] = true,
    ["SPELL_SWITCHER_TRACKING_TYPES_CHANGED"] = true,
    ["MINIMAP_ICON_DISPLAY_TYPE_CHANGE"] = true,
    ["MINIMAP_ICON_HIDE"] = true,
    ["OPTIONS_RESET"] = true,
  },
}

local NO_TRACK_ICON = "Interface\\AddOns\\"..FOLDER_NAME.."\\Media\\Logo64x64.blp" -- 136235
local ENABLED_COLOR = Colors:GetColorByName("GREEN2")
local DISABLED_COLOR = Colors:GetColorByName("RED")
local PAUSED_COLOR = Colors:GetColorByName("GRAY")
local COMMAND_COLOR = Colors:GetColorByName("LIGHTYELLOW")


function Icon:OnInitialize()
  private.ldb = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
    type = "data source",
    text = ADDON_NAME,
    icon = self:GetIconTexture(),
    OnTooltipShow = function(_self)
      local tt = private.CreateTooltip(_self, _self)
      local cs = COMMAND_COLOR
      local ce = "|r"
      tt:AddLine(format(L["%sDrag%s to move icon"], cs, ce))
      tt:Show()
    end,
    OnClick = function(self, button)
      Icon:OnClick(self, button)
    end,
  })

  private.icon = LibStub("LibDBIcon-1.0")
  private.icon:Register(ADDON_NAME, private.ldb, TE.db.profile.minimap)

  private.minimapButton = private.icon:GetMinimapButton(ADDON_NAME)

  self:RegisterEvents(private.GAME_EVENTS, "EventHandler")
  self:RegisterUserEvents(private.USER_EVENTS, "EventHandler")

end

function Icon:OnEnable()
  MiniMapTracking:HookScript("OnHide", function()
    if not TE.db.profile.minimap.hideDefaultTrackingIcon and Settings:GetPlayerTrackingSpells() then
      MiniMapTrackingIcon:SetTexture(NO_TRACK_ICON)
      MiniMapTracking:Show()
    end
  end)

  MiniMapTracking:HookScript("OnShow", function()
    if TE.db.profile.minimap.hideDefaultTrackingIcon then
      MiniMapTracking:Hide()
    end
  end)

  self:EmbedInDefaultTrackingFrame()
end

function Icon:EmbedInDefaultTrackingFrame()

  if Settings:GetPlayerTrackingSpells() then

    MiniMapTrackingIcon:SetTexture(self:GetIconTexture())

    local ghostButton = CreateFrame("Button", ADDON_NAME.." Minimap ghostButton", MiniMapTracking)

    ghostButton:SetAllPoints()

    ghostButton:SetScript("OnMouseDown", function(_self, button)
      Icon:OnClick(_self, button)
    end)
    ghostButton:SetScript("OnEnter", function(_self)
      local tooltip = private.CreateTooltip(_self)
      tooltip:Show()
    end)
    ghostButton:SetScript("OnLeave", function(_self)
      local tooltip = private.CreateTooltip(_self)
      tooltip:Hide()
    end)

    private.embeded = true
  end

  Icon:RegisterEvent("SPELLS_CHANGED", "EventHandler")
end


function Icon:Refresh()
  private.icon:Refresh(ADDON_NAME, TE.db.profile.minimap)
end

function Icon:UpdateIcon()
  private.ldb.icon = self:GetIconTexture()
  MiniMapTrackingIcon:SetTexture(self:GetIconTexture())
  Icon:Refresh()
end

function Icon:GetNextSpellIcon()
  local currentSpellId = SpellSwitcher:GetCurrentTrackingSpellID()
  local nextSpellID = SpellSwitcher:GetNextSpellID(currentSpellId)
  local icon = GetSpellTexture(nextSpellID)

  if not icon then return NO_TRACK_ICON end

  return icon
end

function Icon:GetIconTexture()
  if TE.db.profile.minimap.displayType == "CURRENT_SPELL" then
    local currentTrackingIcon = MiniMapTrackingIcon:GetTexture()
    if string.find(currentTrackingIcon, "\\None$") then currentTrackingIcon = nil end

    return currentTrackingIcon or NO_TRACK_ICON
  elseif TE.db.profile.minimap.displayType == "NEXT_SPELL" then
    return self:GetNextSpellIcon()
  else
    return NO_TRACK_ICON
  end
end

function Icon:OnClick(_self, button)
  local alt_key = IsAltKeyDown()
  local shift_key = IsShiftKeyDown()
  local control_key = IsControlKeyDown()

  if button == "LeftButton" then
    if shift_key then
      TE.db.profile.autoTracking.spellSwitcher.enabled = not TE.db.profile.autoTracking.spellSwitcher.enabled
      Icon:SendMessage("SPELL_SWITCHER_TOGGLED")
    else
      ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, _self, 0, 0)
    end
  elseif button == "RightButton" then
    if shift_key then
      Settings:OpenOptionsFrame()
    else
      CancelTrackingBuff()
    end
  else
    Settings:OpenOptionsFrame()
  end
end

function Icon:GetAddonState()
  if TE.db.profile.autoTracking.spellSwitcher.enabled then
    if SpellSwitcher:isPaused() then
      return PAUSED_COLOR..L["paused"].."|r"
    else 
      return ENABLED_COLOR..L["enabled"].."|r"
    end
  else 
    return DISABLED_COLOR..L["disabled"].."|r"
  end
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================

function Icon:EventHandler(...)
  local event, arg1, arg2, arg3 = ...

  if event == "MINIMAP_UPDATE_TRACKING" or event == "SPELL_SWITCHER_TOGGLED" or event == "MINIMAP_ICON_DISPLAY_TYPE_CHANGE" or event == "SPELL_SWITCHER_TRACKING_TYPES_CHANGED" then
    self:UpdateIcon()
  elseif event == "OPTIONS_RESET" or event == "MINIMAP_ICON_HIDE" then
    self:Refresh()
  end
end

function Icon:RegisterEvents(eventTable, func)

  for key, val in pairs(eventTable) do
    if val then
      self:RegisterEvent(key, func)
    end
  end

end

function Icon:RegisterUserEvents(eventTable, func)
  for key, val in pairs(eventTable) do
    if val then
      self:RegisterMessage(key, func)
    end
  end
end

-- =================================================================================
--                                     Module private function
-- =================================================================================

function private.CreateTooltip(self, dummyTooltip)

  local tooltip = nil

  if not dummyTooltip then

    tooltip = self.tooltip or CreateFrame("GameTooltip", ADDON_NAME.."tooltip", UIParent, "GameTooltipTemplate")
    self.tooltip = tooltip

    function getAnchors(frame)
      local x, y = frame:GetCenter()
      if not x or not y then return "CENTER" end
      local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
      local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
      return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
    end

    tooltip:SetOwner(self, "ANCHOR_NONE")
    tooltip:SetPoint(getAnchors(self))
  else
    tooltip = dummyTooltip
  end

    local cs = COMMAND_COLOR
    local ce = "|r"
    tooltip:SetText(ADDON_NAME.." ["..Icon:GetAddonState().."]")
    tooltip:AddLine(format(L["%sLeft-click%s to manualy select tracking spell"], cs, ce))
    tooltip:AddLine(format(L["%sRight-click%s to cancel current tracking spell"], cs, ce))
    tooltip:AddLine(format(L["%sShift+Left-click%s to enable/disable auto switching"], cs, ce))
    tooltip:AddLine(format(L["%sShift+Right-click%s to open settings"], cs, ce))
    
    return tooltip
end

function private.GetDropdownMenu(name, parent)
  local kids = { parent:GetChildren() }
  for _, child in ipairs(kids) do
    if child:GetName() == name then 
      return child
    end
  end

  return CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
end

-- =================================================================================
--                                     Other
-- =================================================================================