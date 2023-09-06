local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local TrackingInfo = TE.Include("TrackingInfo")
local Log = TE.Include("Log")

local private = {
  spellInfo = {
    minerals = {
      type = "resources",
      iconId = 136025,
      spellId = 2580,
    },
    herbs = {
      type = "resources",
      iconId = 133939,
      spellId = 2383,
    },
    treasure = {
      type = "resources",
      iconId = 135725,
      spellId = 2481,
    },
    hidden = {
      type = "units",
      iconId = 132320,
      spellId = 19885,
    },
    beasts = {
      type = "units",
      iconId = 132328,
      spellId = 1494,
    },
    dragonkin = {
      type = "units",
      iconId = 134153,
      spellId = 19879,
    },
    elementals = {
      type = "units",
      iconId = 135861,
      spellId = 19880,
    },
    undead = {
      type = "units",
      iconId = 136142,
      spellId = 19884,
    },
    demons = {
      type = "units",
      iconId = 136217,
      spellId = 19878,
    },
    demons_warlock = {
      type = "units",
      iconId = 136172,
      spellId = 5500,
    },
    giants = {
      type = "units",
      iconId = 132275,
      spellId = 19882,
    },
    humanoids = {
      type = "units",
      iconId = 135942,
      spellId = 19883,
    },
    humanoids_druid = {
      type = "units",
      iconId = 132328,
      spellId = 5225,
    },
  },
}

function TrackingInfo:GetDataByKey(key)
  return private[key]
end

function TrackingInfo:GetCurrentTrackingSpellID()
  if TE.isClassicEraOrBCC then
    local spellInfo = private.spellInfo
    local currentTrackingIconId = GetTrackingTexture()
    local _, playerClass = UnitClass("player")

    if playerClass == "DRUID" and currentTrackingIconId == spellInfo["humanoids_druid"].iconId then
      return spellInfo["humanoids_druid"].spellId
    end

    if currentTrackingIconId then
      for key, entry in pairs(spellInfo) do
        if entry.iconId == currentTrackingIconId then
          return entry.spellId
        end
      end
    end
  else
    for i = 1, C_Minimap.GetNumTrackingTypes() do
      local _, _, active, category, _, spellId = C_Minimap.GetTrackingInfo(i);
      if category == "spell" and active == true then return spellId end
    end
  end
end

function TrackingInfo:GetPlayerTrackingSpells()
  local playerTrackingInfo = {}

  if TE.isClassicEraOrBCC then
    for k, entry in pairs(private.spellInfo) do
      if IsSpellKnown(entry.spellId) then
        table.insert(playerTrackingInfo, {
          spellId = entry.spellId,
          name = GetSpellInfo(entry.spellId),
          texture = GetSpellTexture(entry.spellId),
          type = entry.type,
        })
      end
    end
  else
    for i = 1, C_Minimap.GetNumTrackingTypes() do
      local name, texture, _, category, _, spellId = C_Minimap.GetTrackingInfo(i);
      if category == "spell" then
        table.insert(playerTrackingInfo, {
          spellId = spellId,
          name = name,
          texture = texture,
        })
      end
    end

    -- if no names found return nil
    if #playerTrackingInfo < 1 then return nil end
  end

  return playerTrackingInfo
end

function TrackingInfo:GetTrackingIDs()
  local spells = self:GetPlayerTrackingSpells() or {}
  local trackingSpells = {}

  for i = 1, #spells do
    if TE.db.profile.spellSwitcher.trackingSpells.spells[i] == true then
      table.insert(trackingSpells, spells[i].spellId)
    end
  end

  -- if no spells to track
  if #trackingSpells < 1 then return nil end

  Log:PrintD("trackingSpells = ", #trackingSpells)

  return trackingSpells
end