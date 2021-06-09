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
      { name = L["Copper Vein"], id = "", difficulty = { 1, 25, 50, 100 }, },
      { name = L["Tin Vein"], id = "", difficulty = { 65, 90, 115, 165 }, },
      { name = L["Incendicite Mineral Vein"], id = "", difficulty = { 65, 90, 115, 165 }, },
      { name = L["Silver Vein"], id = "", difficulty = { 75, 100, 125, 175 }, },
      { name = L["Ooze Covered Silver Vein"], id = "", difficulty = { 75, 100, 125, 175 }, },
      { name = L["Lesser Bloodstone Deposit"], id = "", difficulty = { 75, 100, 125, 175 }, },
      { name = L["Iron Deposit"], id = "", difficulty = { 125, 150, 175, 225 }, },
      { name = L["Ooze Covered Iron Deposit"], id = "", difficulty = { 125, 150, 175, 225 }, },
      { name = L["Indurium Mineral Vein"], id = "", difficulty = { 150, 175, 200, 250 }, },
      { name = L["Gold Vein"], id = "", difficulty = { 155, 180, 205, 225 } },
      { name = L["Ooze Covered Gold Vein"], id = "", difficulty = { 155, 180, 205, 225 }, },
      { name = L["Mithril Deposit"], id = "", difficulty = { 175, 200, 225, 275 }, },
      { name = L["Ooze Covered Mithril Deposit"], id = "", difficulty = { 175, 200, 225, 275 }, },
      { name = L["Truesilver Deposit"], id = "", difficulty = { 230, 255, 280, 330 }, },
      { name = L["Ooze Covered Truesilver Deposit"], id = "", difficulty = { 230, 255, 280, 330 }, },
      { name = L["Dark Iron Deposit"], id = "", difficulty = { 230, 255, 280, 330 }, },
      { name = L["Small Thorium Vein"], id = "", difficulty = { 245, 270, 295, 345 }, },
      { name = L["Ooze Covered Thorium Vein"], id = "", difficulty = { 245, 270, 295, 345 }, },
      { name = L["Rich Thorium Vein"], id = "", difficulty = { 275, 290, 300, 350 }, },
      { name = L["Ooze Covered Rich Thorium Vein"], id = "", difficulty = { 275, 290, 300, 350 }, },
      { name = L["Hakkari Thorium Vein"], id = "", difficulty = { 275, 290, 300, 350 }, },
      { name = L["Small Obsidian Chunk"], id = "", difficulty = { 305, 330, 355, 405 }, },
      { name = L["Large Obsidian Chunk"], id = "", difficulty = { 305, 330, 355, 405 }, },
      { name = L["Fel Iron Deposit"], id = "", difficulty = { 300, 325, 350, 400 }, },
      { name = L["Khorium Vein"], id = "", difficulty = { 375, 400, 425, 475 }, },
      { name = L["Adamantite Deposit"], id = "", difficulty = { 325, 350, 375, 425 }, },
      { name = L["Rich Adamantite Deposit"], id = "", difficulty = { 350, 375, 400, 450 }, },
    },
  },
  [L["Herbalism"]] = {
    LOOKUP = { L["Herbalism"], L["Requires Herbalism"], UNIT_SKINNABLE_HERB, },
    ITEMS = {
      { name = L["Peacebloom"], id = 2447, difficulty = { 1, 25, 50, 100 }, },
      { name = L["Silverleaf"], id = 765, difficulty = { 1, 25, 50, 100 }, },
      { name = L["Earthroot"], id = 2449, difficulty = { 15, 40, 65, 115 }, },
      { name = L["Mageroyal"], id = 785, difficulty = { 50, 75, 100, 150 }, },
      { name = L["Briarthorn"], id = 2450, difficulty = { 70, 95, 120, 170 }, },
      { name = L["Stranglekelp"], id = 3820, difficulty = { 85, 110, 135, 185 }, },
      { name = L["Bruiseweed"], id = 2453, difficulty = { 100, 125, 150, 200 }, },
      { name = L["Wild Steelbloom"], id = 3355, difficulty = { 115, 140, 165, 215 }, },
      { name = L["Grave Moss"], id = 3369, difficulty = { 120, 145, 170, 220 }, },
      { name = L["Kingsblood"], id = 3356, difficulty = { 125, 150, 175, 225 }, },
      { name = L["Liferoot"], id = 3357, difficulty = { 150, 175, 200, 250 }, },
      { name = L["Fadeleaf"], id = 3818, difficulty = { 160, 185, 210, 260 }, },
      { name = L["Goldthorn"], id = 3821, difficulty = { 170, 195, 220, 270 }, },
      { name = L["Khadgar's Whisker"], id = 3358, difficulty = { 185, 210, 235, 285 }, },
      { name = L["Wintersbite"], id = 3819, difficulty = { 195, 220, 245, 295 }, },
      { name = L["Firebloom"], id = 4625, difficulty = { 205, 230, 255, 305 }, },
      { name = L["Purple Lotus"], id = 8831, difficulty = { 210, 235, 255, 305 }, },
      { name = L["Arthas' Tears"], id = 8836, difficulty = { 220, 245, 270, 320 }, },
      { name = L["Sungrass"], id = 8838, difficulty = { 230, 255, 280, 330 }, },
      { name = L["Blindweed"], id = 8839, difficulty = { 235, 260, 285, 335 }, },
      { name = L["Ghost Mushroom"], id = 8845, difficulty = { 245, 270, 295, 345 }, },
      { name = L["Gromsblood"], id = 8846, difficulty = { 250, 275, 300, 350 }, },
      { name = L["Golden Sansam"], id = 13464, difficulty = { 260, 285, 310, 360 }, },
      { name = L["Dreamfoil"], id = 13463, difficulty = { 270, 295, 320, 370 }, },
      { name = L["Mountain Silversage"], id = 13465, difficulty = { 280, 305, 330, 380 }, },
      { name = L["Plaguebloom"], id = 13466, difficulty = { 285, 310, 335, 385 }, },
      { name = L["Icecap"], id = 13467, difficulty = { 290, 315, 340, 390 }, },
      { name = L["Black Lotus"], id = 13468, difficulty = { 300, 325, 350, 400 }, },
      { name = L["Felweed"], id = 22785, difficulty = { 300, 325, 350, 400 }, },
      { name = L["Dreaming Glory"], id = 22786, difficulty = { 315, 340, 365, 415 }, },
      { name = L["Ragveil"], id = 22787, difficulty = { 325, 350, 375, 425 }, },
      { name = L["Terocone"], id = 22789, difficulty = { 325, 350, 375, 425 }, },
      { name = L["Flame Cap"], id = 22788, difficulty = { 335, 360, 385, 435 }, },
      { name = L["Ancient Lichen"], id = 22790, difficulty = { 340, 365, 390, 440 }, },
      { name = L["Netherbloom"], id = 22791, difficulty = { 350, 375, 400, 450 }, },
      { name = L["Nightmare Vine"], id = 22792, difficulty = { 365, 390, 415, 465 }, },
      { name = L["Mana Thistle"], id = 22793, difficulty = { 375, 400, 425, 475 }, },
    },
    UNITS = {
      { name = L["Fungal Giant"], id = 19734, difficulty = { 315, 340, 365, 415 }, },
      { name = L["Bog Lord"], id = 18127, difficulty = { 320, 345, 370, 420 }, },
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
    if unit.name == itemName then return L["Herbalism"], unit.difficulty[1], unit.id end
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