local FOLDER_NAME, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local TE = ADDON_TABLE.Addon
local Colors = TE.Include('Data.Colors')
local Icon = TE.Include('Service.Icon')
local Settings = TE.Include('Service.Settings')
local AutoTracker = TE.Include('Service.AutoTracker')
local MyLib = TE.Include('Util.MyLib')
local L = TE.Include('Locale')

local private = {
  embeded = false,
  ldb = nil,
  icon = nil,
  GAME_EVENTS = {
    ['MINIMAP_UPDATE_TRACKING'] = true,
  },
  USER_EVENTS = {
    ['MINIMAP_ICON_DISPLAY_TYPE_CHANGE'] = true,
    ['OPTIONS_RESET'] = true,
  },
}

local NO_TRACK_ICON = "Interface\\AddOns\\"..FOLDER_NAME.."\\Media\\Logo64x64.blp" -- 136235
local ENABLED_COLOR = Colors:GetColorByName('GREEN2')
local DISABLED_COLOR = Colors:GetColorByName('RED')
local PAUSED_COLOR = Colors:GetColorByName('GRAY')
local COMMAND_COLOR = Colors:GetColorByName('LIGHTYELLOW')


function Icon:OnInitialize()
  private.ldb = LibStub('LibDataBroker-1.1'):NewDataObject(ADDON_NAME, {
    type = 'data source',
    text = ADDON_NAME,
    icon = self:GetIconTexture(),
    OnTooltipShow = function(tooltip)
      local tooltip = private.CreateTooltip(_, tooltip)
      local cs = COMMAND_COLOR
      local ce = '|r'
      tooltip:AddLine(format(L['%sDrag%s to move icon'], cs, ce))
      tooltip:Show()
    end,
    OnClick = function(self, button)
      Icon:OnClick(self, button)
    end,
  })

  private.icon = LibStub('LibDBIcon-1.0')
  private.icon:Register(ADDON_NAME, private.ldb, TE.db.profile.minimap)

  private.minimapButton = private.icon:GetMinimapButton(ADDON_NAME)

  self:RegisterEvents(private.GAME_EVENTS, 'EventHandler')
  self:RegisterUserEvents(private.USER_EVENTS, 'EventHandler')

end

function Icon:OnEnable()
  self:EmbedInDefaultTrackingFrame()
end

function Icon:EmbedInDefaultTrackingFrame()

  if Settings:GetPlayerTrackingSpells() then

    if not GetTrackingTexture() then MiniMapTrackingIcon:SetTexture(NO_TRACK_ICON) end
    MiniMapTrackingFrame:Show()

    MiniMapTrackingFrame:HookScript('OnHide', function()
      MiniMapTrackingIcon:SetTexture(NO_TRACK_ICON)
      if Settings:GetPlayerTrackingSpells() then 
        MiniMapTrackingFrame:Show()
      end
    end)

    local ghostButton = CreateFrame('Button', ADDON_NAME, MiniMapTrackingFrame)

    ghostButton:SetAllPoints()

    ghostButton:SetScript('OnMouseDown', function(self, button)
      Icon:OnClick(self, button)
    end)
    ghostButton:SetScript('OnEnter', function(self)
      local tooltip = private.CreateTooltip(self)
      tooltip:Show()
    end)
    ghostButton:SetScript('OnLeave', function(self) 
      local tooltip = private.CreateTooltip(self)
      tooltip:Hide()
    end)

    private.embeded = true
  end

  Icon:RegisterEvent('SPELLS_CHANGED', 'EventHandler')
end


function Icon:Refresh()
  private.icon:Refresh(ADDON_NAME, TE.db.profile.minimap)
end

function Icon:UpdateIcon()
  private.ldb.icon = Icon:GetIconTexture()
  Icon:Refresh()
end

function Icon:CancelTrackingBuff(self)
  CancelTrackingBuff()
end

function Icon:GetNextSpellIcon()
  local nextSpellID = AutoTracker:GetNextSpellID()
  local icon = GetSpellTexture(nextSpellID)
  
  if not icon then return NO_TRACK_ICON end
  
  return icon
end

function Icon:GetIconTexture()
  if TE.db.profile.minimap.displayType == 'CURRENT_SPELL' then 
    return GetTrackingTexture() or NO_TRACK_ICON
  elseif TE.db.profile.minimap.displayType == 'NEXT_SPELL' then
    return self:GetNextSpellIcon()
  else 
    return NO_TRACK_ICON
  end
end

function Icon:OnClick(self, button)
  local alt_key = IsAltKeyDown()
  local shift_key = IsShiftKeyDown()
  local control_key = IsControlKeyDown()

  if button == 'LeftButton' then
    if shift_key then
      Settings:Toggle()
    else
      Icon:DropDownMenu_Open(self, -150)
    end
  elseif button == 'RightButton' then
    if shift_key then
      Settings:OpenOptionsFrame()
    else
      Icon:CancelTrackingBuff()
    end
  else
    Settings:OpenOptionsFrame()
  end
end

function Icon:DropDownMenu_Open(anchor, x, y)
  local anchor = anchor or 'cursor'
  local x = x or -138
  local y = y or 3

  local menuList = {
    isNotRadio = true,
    {
      text = ADDON_NAME,
      isTitle = true,
      notCheckable = true,
    },
    {
      text = 'None',
      checked = function(self)
        if not GetTrackingTexture() then return true end
        return false
      end,
      func = function()
        self:CancelTrackingBuff()
      end
    },
  }

  local resources = Settings:GetPlayerTrackingSpells('resources') or {}
  local units = Settings:GetPlayerTrackingSpells('units') or {}
  local spells = MyLib.ConcatTwoTables(resources, units)

    for id, name in pairs(spells) do
        table.insert(menuList, {
          text = name,
          icon = GetSpellTexture(id),
          checked = function(self)
            if self.icon == GetTrackingTexture() then return true end
            return false
          end,
          func = function(self, arg1, arg2, checked)
            CastSpellByID(id)
          end,
        })
    end

  local menuFrame = CreateFrame('Frame', FOLDER_NAME..'Menu', UIParent, 'UIDropDownMenuTemplate')
  EasyMenu(menuList, menuFrame, anchor, x, y, 'MENU');
end

function Icon:GetAddonState()
  if TE.db.profile.general.enable then
    if AutoTracker:isPaused() then
      return PAUSED_COLOR..L['paused']..'|r'
    else 
      return ENABLED_COLOR..L['enabled']..'|r'
    end
  else 
    return DISABLED_COLOR..L['disabled']..'|r'
  end
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================

function Icon:EventHandler(...)
  local event, arg1, arg2, arg3 = ...

  if private.GAME_EVENTS[event] then
    if event == 'MINIMAP_UPDATE_TRACKING' then
      self:UpdateIcon()
    end
  elseif event == 'SPELLS_CHANGED' then
    if not private.embeded then
      self:EmbedInDefaultTrackingFrame()
    else
      if Settings:GetPlayerTrackingSpells() then 
        MiniMapTrackingFrame:Show() 
      else
        MiniMapTrackingFrame:Hide()
      end
    end
  elseif private.USER_EVENTS[event] then
    if event == 'MINIMAP_ICON_DISPLAY_TYPE_CHANGE' then
      self:UpdateIcon()
    elseif event == 'OPTIONS_RESET' then
      self:Refresh()
    end
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

    tooltip = self.tooltip or CreateFrame('GameTooltip', ADDON_NAME..'tooltip', UIParent, "GameTooltipTemplate")
    self.tooltip = tooltip

    function getAnchors(frame)
      local x, y = frame:GetCenter()
      if not x or not y then return 'CENTER' end
      local hhalf = (x > UIParent:GetWidth()*2/3) and 'RIGHT' or (x < UIParent:GetWidth()/3) and "LEFT" or ""
      local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
      return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
    end

    tooltip:SetOwner(self, 'ANCHOR_NONE')
    tooltip:SetPoint(getAnchors(self))
  else
    tooltip = dummyTooltip
  end

    local cs = COMMAND_COLOR
    local ce = '|r'
    tooltip:SetText(ADDON_NAME..' ['..Icon:GetAddonState()..']')
    tooltip:AddLine(format(L['%sLeft-click%s to manualy select tracking spell'], cs, ce))
    tooltip:AddLine(format(L['%sRight-click%s to cancel current tracking spell'], cs, ce))
    tooltip:AddLine(format(L['%sShift+Left-click%s to enable/disable auto switching'], cs, ce))
    tooltip:AddLine(format(L['%sShift+Right-click%s to open settings'], cs, ce))
    
    return tooltip
end


-- =================================================================================
--                                     Other
-- =================================================================================

-- FIX BLIZZARD BUG WHEN TRACKING ICON DON'T SHOW AFTER RELOAD

do

  if GetTrackingTexture() then
    MiniMapTrackingIcon:SetTexture(GetTrackingTexture())
    MiniMapTrackingFrame:Show()
  end

end