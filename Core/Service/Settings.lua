local FOLDER_NAME, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local ADDON_VERSION = ADDON_TABLE.ADDON_VERSION
local ADDON_AUTHOR = ADDON_TABLE.ADDON_AUTHOR
local TE = ADDON_TABLE.Addon
local Settings = TE.Include("Service.Settings")
local MyLib = TE.Include("Util.MyLib")
local Log = TE.Include("Util.Log")
local private = {}

local MINIMAP_ICON_DISPLAY_TYPES = {
  DEFAULT = L["Default"],
  CURRENT_SPELL = L["Current tracking"],
  NEXT_SPELL = L["Next tracking spell"],
}

local options = {
  name = ADDON_NAME,
  handler = Settings,
  type = "group",
  set = "OptSetter",
  get = "OptGetter",
  args = {
    about = {
      name = L["Version"]..":"..ADDON_VERSION.." by "..ADDON_AUTHOR.."\n\n",
      type = "description",
      order = 0,
    },
    autoTracking = {
      name = L["Auto tracking"],
      type = "group",
      inline = true,
      order = 1,
      args = {
        spellSwitcher = {
          name = L["Auto spell switching"],
          type = "group",
          inline = true,
          order = 2,
          args = {
            enabled = {
              name = L["Enabled"],
              desc = L["Toggle auto spell switching"],
              type = "toggle",
              order = 0,
            },
            onmove = {
              name = L["Only while moving"],
              desc = L["Enable to switch only while character is moving"],
              type = "toggle",
              order = 1,
            },
            forceInCombat = {
              name = L["Force in combat"],
              desc = L["Switch spells even if player in combat"],
              type = "toggle",
              order = 2,
            },
            trackingSpells = {
              name = L["Tracking spells"],
              type = "group",
              hidden = function() 
                local valueTable = Settings:GetPlayerTrackingSpells()
                if not valueTable then return true end
              end,
              args = {
                spells = {
                  name = L["Spells"],
                  desc = L["Select to include in auto switching"],
                  type = "multiselect",
                  values = function()
                    local spellTable = Settings:GetPlayerTrackingSpells()
                    local tempTable = {}

                    for i = 1 , #spellTable do
                      table.insert(tempTable, spellTable[i].name)
                    end

                    return tempTable or {}
                  end,
                  hidden = function() 
                    local valueTable = Settings:GetPlayerTrackingSpells()
                    if not valueTable then return true end
                  end,
                  cmdHidden = true,
                },
              }
            },
            interval = {
              name = L["Cast interval"],
              desc = L["Time in seconds between spell casts while auto switching"],
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
        general = {
          name = L["General"],
          type = "group",
          order = 3,
          args = {
            muteSpellUseSound = {
              name = L["Mute spell use sound"],
              desc = L["Mute spell use sound while auto tracking"],
              type = "toggle",
              order = 1,
            },
          },
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
              desc = L["Check to show required profession level on world map tooltips. Requires GatherMate2 addon."],
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
      func = "test",
      hidden = true,
    },
  },
}

local defaults = {
  profile  = {
    autoTracking = {
      spellSwitcher = {
        enabled = true,
        onmove = true,
        forceInCombat = false,
        interval = 2,
        trackingSpells = {
          spells = {
            --["*"] = true,
          },
        },
      },
      general = {
        muteSpellUseSound = true,
      },
    },
    minimap = { 
      hide = true,
      hideDefaultTrackingIcon = false,
      displayType = "CURRENT_SPELL",
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
end

function Settings:OnEnable()
  self:ToggleDefaultTrackingIcon()
end

function Settings:ToggleDefaultTrackingIcon()
  if TE.db.profile.minimap.hideDefaultTrackingIcon then MiniMapTracking:Hide() else MiniMapTracking:Show() end
end

function Settings:ResetProfile()
  TE.db:ResetProfile()
  self:ToggleDefaultTrackingIcon()
  self:SendMessage("MINIMAP_ICON_DISPLAY_TYPE_CHANGE")
  self:SendMessage("OPTIONS_RESET")
end

function Settings:GetPlayerTrackingSpells(trackingType)
  local playerTrackingSpells = {}

  for i = 1, GetNumTrackingTypes() do 
    local name, texture, active, category, _, spellId = GetTrackingInfo(i);
    if category == "spell" then
      table.insert(playerTrackingSpells, {spellId = spellId, name = name} )
    end
  end

  -- if no names found return nil
  if #playerTrackingSpells < 1 then return nil end

  return playerTrackingSpells
end

function Settings:GetSpellsToTrack()
  local spells = self:GetPlayerTrackingSpells() or {}
  local trackingSpells = {}

  for i = 1, #spells do
    if TE.db.profile.autoTracking.spellSwitcher.trackingSpells.spells[i] == true then
      table.insert(trackingSpells, spells[i].spellId)
    end
  end
  
  -- if no spells to track
  if #trackingSpells < 1 then return nil end

  Log:PrintD("trackingSpells = ", #trackingSpells)

  return trackingSpells
end

function Settings:GetCastInterval()
  return TE.db.profile.autoTracking.spellSwitcher.interval
end

function Settings:OpenOptionsFrame()
  InterfaceOptionsFrame_OpenToCategory(Settings.optionsFrame)
end

function Settings:test()
  print("FolderName:", FOLDER_NAME)
  print(GetAddOnMetadata(FOLDER_NAME, "Version"))
end

function Settings:CallbackHandler(...)
  local scope, key, subKey, val, scopeString = ...

  if scope == TE.db.profile.autoTracking.spellSwitcher then
    if key == "enabled" then
      self:SendMessage("SPELL_SWITCHER_TOGGLED")
    elseif key == "onmove" then
      self:SendMessage("SPELL_SWITCHER_MODE_TOGGLED")
    elseif key == "forceInCombat" then
      self:SendMessage("SPELL_SWITCHER_FORCE_IN_COMBAT_TOGGLED")
    elseif key == "interval" then
      self:SendMessage("SPELL_SWITCHER_INTERVAL_CHANGED")
    end
  elseif scope == TE.db.profile.autoTracking.spellSwitcher.trackingSpells then
    if key == "spells" then
      self:SendMessage("SPELL_SWITCHER_TRACKING_TYPES_CHANGED")
    end
  elseif scope == TE.db.profile.minimap then
    if key == "hide" then
      self:SendMessage("MINIMAP_ICON_HIDE")
    elseif key == "hideDefaultTrackingIcon" then
      self:ToggleDefaultTrackingIcon()
    elseif key == "displayType" then
      self:SendMessage("MINIMAP_ICON_DISPLAY_TYPE_CHANGE")
    end
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
  local scope = private.GetDBScopeForInfo(TE.db.profile, info)

  local key = info[#info]
  local subKey = nil
  local val = arg2
  
  if arg3 ~= nil then
    local subKey = arg2
    val = arg3
    scope[key][subKey] = val
  else
    scope[key] = val
  end

  local scopeString = 'TE.db.profile'
  for i=1, #info do
    scopeString = scopeString.."."..info[i]
  end

  self:CallbackHandler(scope, key, subKey, val, scopeString)
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