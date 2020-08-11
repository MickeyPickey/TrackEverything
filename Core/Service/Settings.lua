local FOLDER_NAME, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local TE = ADDON_TABLE.Addon
local Settings = TE.Include("Service.Settings")
local AutoTracker = TE.Include("Service.AutoTracker")
local Icon = TE.Include("Service.Icon")
local TrackingSpells = TE.Include("Data.TrackingSpells")
local MyLib = TE.Include("Util.MyLib")
local Log = TE.Include("Util.Log")
local L = TE.Include("Locale")
local private = {
  GAME_EVENTS = {
    ["MINIMAP_UPDATE_TRACKING"] = true,
  },
}

local MINIMAP_ICON_DISPLAY_TYPES = {
  DEFAULT = L["Default"],
  CURRENT_SPELL = L["Current tracking spell"],
  NEXT_SPELL = L["Next tracking spell"],
}

local options = {
  name = ADDON_NAME,
  handler = Settings,
  type = "group",
  set = "OptSetter",
  get = "OptGetter",
  args = {
    general = {
      name = L["Auto tracking"],
      type = "group",
      inline = true,
      order = 1,
      args = {
        enable = {
          name = L["Enabled"],
          desc = L["Toggle the addon"],
          type = "toggle",
          order = 0,
        },
        onmove = {
          name = L["Only while moving"],
          desc = L["Enable to track only while character is moving"],
          type = "toggle",
          order = 1,
        },
        muteSpellUseSound = {
          name = L["Mute spell use sound"],
          desc = L["Mute spell use sound while auto switching"],
          type = "toggle",
          order = 2,
        },
        autoTracking = {
          name = L["Tracking spells"],
          type = "group",
          hidden = function (info) 
            local valueTable = Settings:GetPlayerTrackingSpells()
            if not valueTable then return true end
          end,
          args = {
            resources = {
              name = L["Resources"],
              desc = L["Select to include in auto tracking"],
              type = "multiselect",
              values = function(info) return Settings:GetPlayerTrackingSpells(info[#info]) or {} end,
              hidden = function (info) 
                local valueTable = Settings:GetPlayerTrackingSpells(info[#info])
                if not valueTable then return true end
              end,
              cmdHidden = true,
            },
            units = {
              name = L["Units"],
              desc = L["Select to include in auto tracking"],
              type = "multiselect",
              values = function(info) return Settings:GetPlayerTrackingSpells(info[#info]) or {} end,
              hidden = function (info)
                local valueTable = Settings:GetPlayerTrackingSpells(info[#info])
                if not valueTable then return true end
              end,
              cmdHidden = true,
            },
          }
        },
        interval = {
          name = L["Cast interval"],
          desc = L["Time in seconds between spell casts while auto tracking"],
          type = "range",
          min = 2,
          max = 45,
          step = 1,
          width = "full"
        },
        settings = {
          type = "execute",
          name = L["Open settings"],
          desc = L["Open settings"],
          func = "OpenOptionsFrame",
          guiHidden = true,
        },
      },
    },
    minimap = {
      name = L["Minimap"],
      type = "group",
      inline = true,
      order = 1,
      args = {
        hide = {
          name = L["Hide addon icon"],
          desc = L["Check to hide addon minimap icon"],
          type = "toggle",
          order = 0,
        },
        hideDefaultTrackingIcon = {
          name = L["Hide default tracking icon"],
          desc = L["Check if you want to hide default minimap tracking icon"],
          type = "toggle",
          order = 1,
        },
        br1 = { type = "description", name = ""},
        displayType = {
          name = L["Icon display mode"],
          desc = L["Select what to display inside icon"],
          type = "select",
          style = "dropdown",
          values = MINIMAP_ICON_DISPLAY_TYPES,
          sorting = function(self) return private.GetSortingTable(self.option.values) end,
          order = 100,
        },
      },
    },
    tooltip = {
      name = L["Tooltip"],
      type = "group",
      inline = true,
      order = 2,
      args = {
        requiredProfessionLevel = {
          name = L["Show required profession level"],
          type = "group",
          inline = true,
          order = 1,
          args = {
            enableWorld = {
              name = L["World tooltips"],
              desc = L["Check to show required profession level on world object tooltips"],
              type = "toggle",
              order = 0,
            },
            enableMinimap = {
              name = L["Minimap tooltips"],
              desc = L["Check to show required profession level on minimap tooltips"],
              type = "toggle",
              order = 1,
            },
            enableWorldMap = {
              name = L["World Map tooltips"],
              desc = L["Check to show required profession level on world map tooltips"],
              type = "toggle",
              order = 2,
            },
          },
        },
      },
    },
    reset = {
      type = "execute",
      name = L["Reset"],
      desc = L["Reset settings to defaults"],
      func = "ResetProfile",
      order = 100,
    },
    test = {
      type = "execute",
      name = L["test"],
      func = L["test"],
      hidden = true,
    },
  },
}

local defaults = {
  profile  = {
    general = {
      enable = true,
      onmove = true,
      muteSpellUseSound = true,
      interval = 2,
      autoTracking = {
        resources = {
          ["*"] = true,
        },
        units = {
          ["*"] = true,
        },
      },
    },
    minimap = { 
      hide = true,
      hideDefaultTrackingIcon = false,
      displayType = "DEFAULT",
    },
    tooltip = {
      requiredProfessionLevel = {
        ["*"] = true
      },
    },
  }
}
  

function Settings:OnInitialize()
  TE.db = LibStub("AceDB-3.0"):New(FOLDER_NAME.."CharDB", defaults)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, options, {"tetest",})
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME, ADDON_NAME)

  self:RegisterEvents(private.GAME_EVENTS, "EventHandler")
end

function Settings:OnEnable()
  self:ToggleDefaultTrackingIcon()
end

function Settings:Toggle()
  TE.db.profile.general.enable = not TE.db.profile.general.enable
  self:SendMessage("ADDON_TOGGLED")
end

function Settings:Enable()
  TE.db.profile.general.enable = true
  self:SendMessage("ADDON_TOGGLED")
end

function Settings:Disable()
  TE.db.profile.general.enable = false
  self:SendMessage("ADDON_TOGGLED")
end

function Settings:ToggleOnMove()
  TE.db.profile.general.onmove = not TE.db.profile.general.onmove
  self:SendMessage("MODE_TOGGLED")
end

function Settings:ToggleDefaultTrackingIcon()
  if TE.db.profile.minimap.hideDefaultTrackingIcon then MiniMapTrackingFrame:SetScale(0.001) else MiniMapTrackingFrame:SetScale(1) end
end

function Settings:ResetProfile()
  TE.db:ResetProfile()
  self:ToggleDefaultTrackingIcon()
  self:SendMessage("MINIMAP_ICON_DISPLAY_TYPES_CHANGE")
  self:SendMessage("OPTIONS_RESET")
end

function Settings:GetPlayerTrackingSpells(trackingType)

  local spellInfo = TrackingSpells.GetDataByKey("spellInfo")
  local trackingSpellNames = nil
  local playerTrackingSpells = nil

  if not trackingType then
    for key, val in pairs(spellInfo) do
      if IsSpellKnown(val["spellId"]) then
          if trackingSpellNames == nil then trackingSpellNames = {} end
          local spellName = GetSpellInfo(val["spellId"])
          table.insert(trackingSpellNames, spellName)
      end
    end
    if not trackingSpellNames then return end
  else
    for key, val in pairs(spellInfo) do
      if IsSpellKnown(val["spellId"]) and val["type"] == trackingType then
          if trackingSpellNames == nil then trackingSpellNames = {} end
          local spellName = GetSpellInfo(val["spellId"])
          table.insert(trackingSpellNames, spellName)
      end
    end
  end

  -- if no names found return nil
  if not trackingSpellNames then return nil end

  playerTrackingSpells = {}

  table.sort(trackingSpellNames)

  for i, val in ipairs(trackingSpellNames) do
    local name, _, _, _, _, _, spellId = GetSpellInfo(val)
    playerTrackingSpells[spellId] = val
  end

  return playerTrackingSpells
end

function Settings:GetSpellsToTrack()
  local resources = Settings:GetPlayerTrackingSpells("resources") or {}
  local units = Settings:GetPlayerTrackingSpells("units") or {}
  local trackingSpells = nil

  for key, val in pairs(resources) do
    if TE.db.profile["general"]["autoTracking"]["resources"][key] == true then
      if not trackingSpells then trackingSpells = {} end
      table.insert(trackingSpells, key)
    end
  end

  for key, val in pairs(units) do
    if TE.db.profile["general"]["autoTracking"]["units"][key] == true then
      if not trackingSpells then trackingSpells = {} end
      table.insert(trackingSpells, key)
    end
  end

  return trackingSpells
end

function Settings:GetCastInterval()
  return TE.db.profile["general"]["interval"]
end

function Settings:OpenOptionsFrame()
  InterfaceOptionsFrame_OpenToCategory(Settings.optionsFrame)
end

function Settings:test()

end

function Settings:CallbackHandler(...)
  local key, subKey, val = ...

  if key == "enable" then
    self:SendMessage("ADDON_TOGGLED")
    Icon:UpdateIcon()
  elseif key == "onmove" then
    self:SendMessage("MODE_TOGGLED")
  elseif key == "interval" then
    self:SendMessage("INTERVAL_CHANGED")
  elseif key == "resources" or key == "units" then
    self:SendMessage("TRACKING_TYPES_CHANGED")
    Icon:UpdateIcon()
  elseif key == "hide" then
    Icon:Refresh()
  elseif key == "hideDefaultTrackingIcon" then
    self:ToggleDefaultTrackingIcon()
  elseif key == "displayType" then
    self:SendMessage("MINIMAP_ICON_DISPLAY_TYPES_CHANGE")
  end
end

-- =================================================================================
--                            Settings get/set functions
-- =================================================================================

function Settings:OptGetter(...)
  local info, subKey = ...
  local infoScope = private.GetDBScopeForInfo(TE.db.profile, info)
  local key = info[#info]

  if subKey then
    return infoScope[key][subKey]
  end

  return infoScope[key]
end

function Settings:OptSetter(...)
  local info, arg2, arg3 = ...
  local infoScope = private.GetDBScopeForInfo(TE.db.profile, info)
  local key = info[#info]
  local subKey = nil
  local val = arg2
  
  if arg3 ~= nil then
    local subKey = arg2
    val = arg3
    infoScope[key][subKey] = val
  else
    infoScope[key] = val
  end

  self:CallbackHandler(key, subKey, val)

end

-- =================================================================================
--                              Module private functions
-- =================================================================================

function private.GetDBScopeForInfo(db, info)
  assert(db and info and type(info) == "table" and type(db) == "table")

  local scope = db

  for i = 1, #info-1 do
    scope = scope[info[i]]
  end

  return scope
end

function private.GetSortingTable(tbl)
  if not tbl then return nil end

  local tempTable = {}
  local isDefault = false

  for key, val in pairs(tbl) do
    if key ~= "DEFAULT" then 
      table.insert(tempTable, key) 
    else 
      isDefault = true
    end
  end

  table.sort(tempTable)

  if isDefault then
    table.insert(tempTable, 1, "DEFAULT")
  end

  return tempTable
end

-- =================================================================================
--                              Event handl functions
-- =================================================================================

function Settings:EventHandler(...)
  local event, arg1, arg2, arg3 = ...
  -- print(event)

  if private.GAME_EVENTS[event] then
    if event == "MINIMAP_UPDATE_TRACKING" then
      self:ScheduleTimer(function() if not GetTrackingTexture() and not UnitIsDeadOrGhost("player") then self:Disable() end end, 1) -- MINIMAP_UPDATE_TRACKING event fires before player is dead, that"s why we need to wait 1 sec to get player dead info. No need to disable addon if tracking was canceled becouse of death
    end
  end

end

function Settings:RegisterEvents(eventTable, func)

  for key, val in pairs(eventTable) do
    if val then
      self:RegisterEvent(key, func)
    end
  end

end

function Settings:RegisterUserEvents(eventTable, func)

  for key, val in pairs(eventTable) do
    if val then
      self:RegisterMessage(key, func)
    end
  end

end

-- =================================================================================
--                                     Other
-- =================================================================================

-- FIX BLIZZARD BUG ADDON OPTIONS DON"T OPENS
do
  local function get_panel_name(panel)
    local tp = type(panel)
    local cat = INTERFACEOPTIONS_ADDONCATEGORIES
    if tp == "string" then
      for i = 1, #cat do
        local p = cat[i]
        if p.name == panel then
          if p.parent then
            return get_panel_name(p.parent)
          else
            return panel
          end
        end
      end
    elseif tp == "table" then
      for i = 1, #cat do
        local p = cat[i]
        if p == panel then
          if p.parent then
            return get_panel_name(p.parent)
          else
            return panel.name
          end
        end
      end
    end
end

local function InterfaceOptionsFrame_OpenToCategory_Fix(panel)
  if doNotRun or InCombatLockdown() then return end
    local panelName = get_panel_name(panel)
    if not panelName then return end -- if its not part of our list return early
    local noncollapsedHeaders = {}
    local shownpanels = 0
    local mypanel
    local t = {}
    local cat = INTERFACEOPTIONS_ADDONCATEGORIES
    for i = 1, #cat do
      local panel = cat[i]
      if not panel.parent or noncollapsedHeaders[panel.parent] then
        if panel.name == panelName then
          panel.collapsed = true
          t.element = panel
          InterfaceOptionsListButton_ToggleSubCategories(t)
          noncollapsedHeaders[panel.name] = true
          mypanel = shownpanels + 1
        end
        if not panel.collapsed then
          noncollapsedHeaders[panel.name] = true
        end
        shownpanels = shownpanels + 1
      end
    end
    local Smin, Smax = InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues()
    if shownpanels > 15 and Smin < Smax then
      local val = (Smax/(shownpanels-15))*(mypanel-2)
      InterfaceOptionsFrameAddOnsListScrollBar:SetValue(val)
    end
    doNotRun = true
    InterfaceOptionsFrame_OpenToCategory(panel)
    doNotRun = false
  end

  hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", InterfaceOptionsFrame_OpenToCategory_Fix)
end