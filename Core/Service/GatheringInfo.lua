local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local L = TE.Include("Locale")
local GatheringInfo = TE.Include("GatheringInfo")

local LT = LibStub("LibTouristClassic-1.0")

-- Globals
local format = format
local GetNumPrimaryProfessions = GetNumPrimaryProfessions
local GetNumSkillLines = GetNumSkillLines
local GetSkillLineInfo = GetSkillLineInfo

local private = {
  [L["Mining"]] = {
    LOOKUP = { L["Mining"], UNIT_SKINNABLE_ROCK},
    NODES = {
      { name = L["Copper Vein"], id = "", minLevel = 1, },
      { name = L["Tin Vein"], id = "", minLevel = 65, },
      { name = L["Incendicite Mineral Vein"], id = "", minLevel = 65, },
      { name = L["Silver Vein"], id = "", minLevel = 75, },
      { name = L["Ooze Covered Silver Vein"], id = "", minLevel = 75, },
      { name = L["Lesser Bloodstone Deposit"], id = "", minLevel = 75, },
      { name = L["Iron Deposit"], id = "", minLevel = 125, },
      { name = L["Ooze Covered Iron Deposit"], id = "", minLevel = 125, },
      { name = L["Indurium Mineral Vein"], id = "", minLevel = 150, },
      { name = L["Gold Vein"], id = "", minLevel = 155, },
      { name = L["Ooze Covered Gold Vein"], id = "", minLevel = 155, },
      { name = L["Mithril Deposit"], id = "", minLevel = 175, },
      { name = L["Ooze Covered Mithril Deposit"], id = "", minLevel = 175, },
      { name = L["Truesilver Deposit"], id = "", minLevel = 230, },
      { name = L["Ooze Covered Truesilver Deposit"], id = "", minLevel = 230, },
      { name = L["Dark Iron Deposit"], id = "", minLevel = 230, },
      { name = L["Small Thorium Vein"], id = "", minLevel = 245, },
      { name = L["Ooze Covered Thorium Vein"], id = "", minLevel = 245, },
      { name = L["Rich Thorium Vein"], id = "", minLevel = 275, },
      { name = L["Ooze Covered Rich Thorium Vein"], id = "", minLevel = 275, },
      { name = L["Hakkari Thorium Vein"], id = "", minLevel = 275, },
      { name = L["Small Obsidian Chunk"], id = "", minLevel = 305, },
      { name = L["Large Obsidian Chunk"], id = "", minLevel = 305, },
      { name = L["Fel Iron Deposit"], id = "", minLevel = 300, },
      { name = L["Khorium Vein"], id = "", minLevel = 375, },
      { name = L["Adamantite Deposit"], id = "", minLevel = 325, },
      { name = L["Rich Adamantite Deposit"], id = "", minLevel = 350, },
    },
  },
  [L["Herbalism"]] = {
    LOOKUP = { L["Herbalism"], UNIT_SKINNABLE_HERB, },
    ITEMS = {
      { name = L["Peacebloom"], id = 2447, minLevel = 1, },
      { name = L["Silverleaf"], id = 765, minLevel = 1, },
      { name = L["Earthroot"], id = 2449, minLevel = 15, },
      { name = L["Mageroyal"], id = 785, minLevel = 50, },
      { name = L["Briarthorn"], id = 2450, minLevel = 70, },
      { name = L["Stranglekelp"], id = 3820, minLevel = 85, },
      { name = L["Bruiseweed"], id = 2453, minLevel = 100, },
      { name = L["Wild Steelbloom"], id = 3355, minLevel = 115, },
      { name = L["Grave Moss"], id = 3369, minLevel = 120, },
      { name = L["Kingsblood"], id = 3356, minLevel = 125, },
      { name = L["Liferoot"], id = 3357, minLevel = 150, },
      { name = L["Fadeleaf"], id = 3818, minLevel = 160, },
      { name = L["Goldthorn"], id = 3821, minLevel = 170, },
      { name = L["Khadgar's Whisker"], id = 3358, minLevel = 185, },
      { name = L["Wintersbite"], id = 3819, minLevel = 195, },
      { name = L["Firebloom"], id = 4625, minLevel = 205, },
      { name = L["Purple Lotus"], id = 8831, minLevel = 210, },
      { name = L["Arthas' Tears"], id = 8836, minLevel = 220, },
      { name = L["Sungrass"], id = 8838, minLevel = 230, },
      { name = L["Blindweed"], id = 8839, minLevel = 235, },
      { name = L["Ghost Mushroom"], id = 8845, minLevel = 245, },
      { name = L["Gromsblood"], id = 8846, minLevel = 250, },
      { name = L["Golden Sansam"], id = 13464, minLevel = 260, },
      { name = L["Dreamfoil"], id = 13463, minLevel = 270, },
      { name = L["Mountain Silversage"], id = 13465, minLevel = 280, },
      { name = L["Plaguebloom"], id = 13466, minLevel = 285, },
      { name = L["Icecap"], id = 13467, minLevel = 290, },
      { name = L["Black Lotus"], id = 13468, minLevel = 300, },
      { name = L["Felweed"], id = 22785, minLevel = 300, },
      { name = L["Dreaming Glory"], id = 22786, minLevel = 315, },
      { name = L["Ragveil"], id = 22787, minLevel = 325, },
      { name = L["Terocone"], id = 22789, minLevel = 325, },
      { name = L["Flame Cap"], id = 22788, minLevel = 335, },
      { name = L["Ancient Lichen"], id = 22790, minLevel = 340, },
      { name = L["Netherbloom"], id = 22791, minLevel = 350, },
      { name = L["Nightmare Vine"], id = 22792, minLevel = 365, },
      { name = L["Mana Thistle"], id = 22793, minLevel = 375, },
    },
    UNITS = {
      { name = L["Fungal Giant"], id = 19734, minLevel = 315, },
      { name = L["Bog Lord"], id = 18127, minLevel = 320, },
    },
  },
  [UNIT_SKINNABLE_LEATHER] = {
    LOOKUP  = { UNIT_SKINNABLE_LEATHER, },
  },
}

function GatheringInfo:GetDataByKey(key)
  return private[key]
end

function GatheringInfo:GetProfessionRequiredSkillColor(itemName)

  local profName, _, id = self:GetProfessionInfoByItemName(itemName)

  local currentSkill = self:GetPlayerProfessionSkillLevelByProfessionName(profName)

  -- return if no prefession learned
  if not currentSkill then return RED_FONT_COLOR:GetRGBA() end

  if profName == L["Mining"] then
    return LT:GetMiningSkillColor(id, currentSkill)
  elseif profName == L["Herbalism"] then
    return LT:GetHerbSkillColor(id, currentSkill)
  end

  return RED_FONT_COLOR:GetRGBA()
end

function GatheringInfo:GetPlayerProfessionSkillLevelByProfessionName(profName)

  if GetNumPrimaryProfessions() == 0 then return nil end -- no primary professions

  for i = 1, GetNumSkillLines() do
    local skillName, _, _, skillRank = GetSkillLineInfo(i)
    if skillName == profName then return skillRank end
  end

  return nil
end

function GatheringInfo:GetProfessionInfoByItemName(itemName)
  assert(itemName and type(itemName) == "string", format("Wrong data type, expected 'string', got %s ", type(itemName)) )

  -- ITERATE THROUGH MINES
  for mine in LT:IterateMiningNodes() do
    if mine.nodeName == itemName then return L["Mining"], mine.minLevel, mine.nodeObjectID end
  end

  -- ITERATE THROUGH HERBS
  for herb in LT:IterateHerbs() do
    if herb.name == itemName then return L["Herbalism"], herb.minLevel, herb.itemID end
  end

  local herbs = self:GetDataByKey(L["Herbalism"])

  for _, unit in ipairs(herbs.UNITS) do
    if unit.name == itemName then return L["Herbalism"], unit.minLevel[1], unit.id end
  end

  return nil
end

function GatheringInfo:IsProfessionItemName(itemName)

  for mine in LT:IterateMiningNodes() do
    if mine.nodeName == itemName then return true end
  end

  for herb in LT:IterateHerbs() do
    if herb.name == itemName then return true end
  end

  return false
end

function GatheringInfo:GetData()
  return private
end

function GatheringInfo:GetLookupValues()
  local lookupValues = {}

  for key, _ in pairs(private) do
    for _, val in ipairs(private[key].LOOKUP) do
      if not lookupValues[key] then lookupValues[key] = {} end
      table.insert(lookupValues[key], val)
    end
  end

  return lookupValues
end

function GatheringInfo:GetDataKeyByLookupValue(value)
  for key, _ in pairs(private) do
    for _, val in ipairs(private[key].LOOKUP) do
      if value == val then return key end
    end
  end
end