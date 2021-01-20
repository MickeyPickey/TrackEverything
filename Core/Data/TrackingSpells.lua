local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon


local TrackingSpells = TE.Init("Data.TrackingSpells")

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

function TrackingSpells:GetDataByKey(key)
  return private[key]
end

function TrackingSpells:GetCurrentTrackingSpellID()
  local spellInfo = private.spellInfo
  local currentTrackingIconId = GetTrackingTexture()
  local currentTrackingSpellId = nil
  local _, playerClass = UnitClass("player")

  if playerClass == "DRUID" and currentTrackingIconId == spellInfo["humanoids_druid"].iconId then
    return spellInfo["humanoids_druid"].spellId
  end

  if currentTrackingIconId then
    for key, val in pairs(spellInfo) do
      if spellInfo[key].iconId == currentTrackingIconId then
        currentTrackingSpellId = spellInfo[key].spellId
        return currentTrackingSpellId
      end
    end
  end

  return currentTrackingSpellId
end