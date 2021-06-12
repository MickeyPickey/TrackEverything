local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local L = TE.Include("Locale")
local GatheringInfo = TE.Include("GatheringInfo")

--local LT = LibStub("LibTouristClassic-1.0")

-- Globals
local format = format
local GetNumPrimaryProfessions = GetNumPrimaryProfessions
local GetNumSkillLines = GetNumSkillLines
local GetSkillLineInfo = GetSkillLineInfo
local GetItemInfo = GetItemInfo

local private = {
  Mining = {
    LOOKUP = { L["Mining"], UNIT_SKINNABLE_ROCK},
    NODES = {
      { name = L["Copper Vein"], id = 1731, minSkillLevel = 1, },
      { name = L["Tin Vein"], id = 1732, minSkillLevel = 65, },
      { name = L["Incendicite Mineral Vein"], id = 1610, minSkillLevel = 65, },
      { name = L["Silver Vein"], id = 1733, minSkillLevel = 75, },
      { name = L["Ooze Covered Silver Vein"], id = 73940, minSkillLevel = 75, },
      { name = L["Lesser Bloodstone Deposit"], id = 2653, minSkillLevel = 75, },
      { name = L["Iron Deposit"], id = 1735, minSkillLevel = 125, },
      { name = L["Ooze Covered Iron Deposit"], id = 73939, minSkillLevel = 125, },
      { name = L["Indurium Mineral Vein"], id = 19903, minSkillLevel = 150, },
      { name = L["Gold Vein"], id = 1734, minSkillLevel = 155, },
      { name = L["Ooze Covered Gold Vein"], id = 73941, minSkillLevel = 155, },
      { name = L["Mithril Deposit"], id = 2040, minSkillLevel = 175, },
      { name = L["Ooze Covered Mithril Deposit"], id = 123310, minSkillLevel = 175, },
      { name = L["Truesilver Deposit"], id = 2047, minSkillLevel = 230, },
      { name = L["Ooze Covered Truesilver Deposit"], id = 123309, minSkillLevel = 230, },
      { name = L["Dark Iron Deposit"], id = 165658, minSkillLevel = 230, },
      { name = L["Small Thorium Vein"], id = 324, minSkillLevel = 245, },
      { name = L["Ooze Covered Thorium Vein"], id = 123848, minSkillLevel = 245, },
      { name = L["Rich Thorium Vein"], id = 175404, minSkillLevel = 275, },
      { name = L["Ooze Covered Rich Thorium Vein"], id = 177388, minSkillLevel = 275, },
      { name = L["Hakkari Thorium Vein"], id = 180215, minSkillLevel = 275, },
      { name = L["Small Obsidian Chunk"], id = 181068, minSkillLevel = 305, },
      { name = L["Large Obsidian Chunk"], id = 181069, minSkillLevel = 305, },
      { name = L["Fel Iron Deposit"], id = 181555, minSkillLevel = 300, },
      { name = L["Khorium Vein"], id = 181557, minSkillLevel = 375, },
      { name = L["Adamantite Deposit"], id = 181556, minSkillLevel = 325, },
      { name = L["Rich Adamantite Deposit"], id = 181569, minSkillLevel = 350, },
    },
  },
  Herbalism = {
    LOOKUP = { L["Herbalism"], UNIT_SKINNABLE_HERB, },
    NODES = {
      { name = L["Peacebloom"], id = "", itemId = 2447, minSkillLevel = 1, },
      { name = L["Silverleaf"], id = "", itemId = 765, minSkillLevel = 1, },
      { name = L["Earthroot"], id = "", itemId = 2449, minSkillLevel = 15, },
      { name = L["Mageroyal"], id = "", itemId = 785, minSkillLevel = 50, },
      { name = L["Briarthorn"], id = "", itemId = 2450, minSkillLevel = 70, },
      { name = L["Stranglekelp"], id = "", itemId = 3820, minSkillLevel = 85, },
      { name = L["Bruiseweed"], id = "", itemId = 2453, minSkillLevel = 100, },
      { name = L["Wild Steelbloom"], id = "", itemId = 3355, minSkillLevel = 115, },
      { name = L["Grave Moss"], id = "", itemId = 3369, minSkillLevel = 120, },
      { name = L["Kingsblood"], id = "", itemId = 3356, minSkillLevel = 125, },
      { name = L["Liferoot"], id = "", itemId = 3357, minSkillLevel = 150, },
      { name = L["Fadeleaf"], id = "", itemId = 3818, minSkillLevel = 160, },
      { name = L["Goldthorn"], id = "", itemId = 3821, minSkillLevel = 170, },
      { name = L["Khadgar's Whisker"], id = "", itemId = 3358, minSkillLevel = 185, },
      { name = L["Wintersbite"], id = "", itemId = 3819, minSkillLevel = 195, },
      { name = L["Firebloom"], id = "", itemId = 4625, minSkillLevel = 205, },
      { name = L["Purple Lotus"], id = "", itemId = 8831, minSkillLevel = 210, },
      { name = L["Arthas' Tears"], id = "", itemId = 8836, minSkillLevel = 220, },
      { name = L["Sungrass"], id = "", itemId = 8838, minSkillLevel = 230, },
      { name = L["Blindweed"], id = "", itemId = 8839, minSkillLevel = 235, },
      { name = L["Ghost Mushroom"], id = "", itemId = 8845, minSkillLevel = 245, },
      { name = L["Gromsblood"], id = "", itemId = 8846, minSkillLevel = 250, },
      { name = L["Golden Sansam"], id = "", itemId = 13464, minSkillLevel = 260, },
      { name = L["Dreamfoil"], id = "", itemId = 13463, minSkillLevel = 270, },
      { name = L["Mountain Silversage"], id = "", itemId = 13465, minSkillLevel = 280, },
      { name = L["Plaguebloom"], id = "", itemId = 13466, minSkillLevel = 285, },
      { name = L["Icecap"], id = "", itemId = 13467, minSkillLevel = 290, },
      { name = L["Black Lotus"], id = "", itemId = 13468, minSkillLevel = 300, },
      { name = L["Felweed"], id = "", itemId = 22785, minSkillLevel = 300, },
      { name = L["Dreaming Glory"], id = "", itemId = 22786, minSkillLevel = 315, },
      { name = L["Ragveil"], id = "", itemId = 22787, minSkillLevel = 325, },
      { name = L["Terocone"], id = "", itemId = 22789, minSkillLevel = 325, },
      { name = L["Flame Cap"], id = "", itemId = 22788, minSkillLevel = 335, },
      { name = L["Ancient Lichen"], id = "", itemId = 22790, minSkillLevel = 340, },
      { name = L["Netherbloom"], id = "", itemId = 22791, minSkillLevel = 350, },
      { name = L["Nightmare Vine"], id = "", itemId = 22792, minSkillLevel = 365, },
      { name = L["Mana Thistle"], id = "", itemId = 22793, minSkillLevel = 375, },
    },
  },
  Skinning = {
    LOOKUP  = { UNIT_SKINNABLE_LEATHER, },
  },
  Engineering = {
    LOOKUP = { UNIT_SKINNABLE_BOLTS },
  },
}

function GatheringInfo:OnInitialize()

  -- As herbalism nodes and items uses the same name, we can use this to get all herb items localizations from the server, so we can ise localize node names using item id.
  for _, val in ipairs(private.Herbalism.NODES) do
    GetItemInfo(val.itemId)
  end
end

function GatheringInfo:GetDataByKey(key)
  return private[key]
end

function GatheringInfo:GetProfessionRequiredSkillColor(itemName)

  local professionName = self:GetProfessionNameByEntryName(itemName)
  local minSkillLevel = self:GetProfessionInfoByItemName(itemName, professionName)

  local currentSkill = self:GetPlayerProfessionSkillLevelByProfessionName(professionName) or 0

  -- return RED if no prefession learned
  --if not currentSkill then return RED_FONT_COLOR:GetRGB() end

  return self:GetGatheringSkillColor(minSkillLevel, currentSkill)
end

function GatheringInfo:GetPlayerProfessionSkillLevelByProfessionName(professionName)

  if GetNumPrimaryProfessions() == 0 then return nil end -- no primary professions

  for i = 1, GetNumSkillLines() do
    local skillName, _, _, skillRank = GetSkillLineInfo(i)
    if skillName == professionName then return skillRank end
  end

  return nil
end

function GatheringInfo:GetProfessionInfoByItemName(itemName, professionName)
  assert(itemName and type(itemName) == "string", format("Wrong data type, expected 'string', got %s ", type(itemName)) )
  assert(professionName and type(professionName) == "string", format("Wrong data type, expected 'string', got %s ", type(professionName)) )

  local professionTable = self:GetDataByKey(professionName)

  if professionName == "Mining" then
    for _, node in ipairs(professionTable.NODES) do
      if node.name == itemName then return node.minSkillLevel, node.id end
    end
    -- =================================================================================
    --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we didn't get
    data from default table--]]
    -- =================================================================================
    -- for node in LT:IterateMiningNodes() do
    --   if node.nodeName == itemName then return node.minLevel, node.nodeObjectID end
    -- end
  elseif professionName == "Herbalism"  then
    for _, node in ipairs(professionTable.NODES) do
      local localizedName = GetItemInfo(node.itemId)
      if localizedName == itemName then return node.minSkillLevel, node.id end
    end
    -- =================================================================================
    --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we didn't get
    data from default table--]]
    -- =================================================================================
    -- for node in LT:IterateHerbs() do
    --   if node.name == itemName then return node.minLevel, node.itemID end
    -- end
  end

  if UnitExists("mouseover") then
    local unitLevel = UnitLevel("mouseover")
    local minSkillLevel = self:CalculateDifficultyByUnitLevel(unitLevel)
    return minSkillLevel, nil
  end

  -- if nothing found untill this point we return nil and we will see [?] minSkillLevel for this herb.
  return "?", nil
end

function GatheringInfo:GetProfessionNameByEntryName(name)
  for professionName, tbl in pairs(private) do
    if tbl.NODES then
      if professionName == "Herbalism" then
        for _, node in ipairs(tbl.NODES) do
          local localizedName = GetItemInfo(node.itemId)
          if localizedName == name then return professionName end
        end
      else
        for _, node in ipairs(tbl.NODES) do
          if node.name == name then return professionName end
        end
      end
    end
  end

  -- =================================================================================
  --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we didn't get
  data from default table--]]
  -- =================================================================================
  -- for node in LT:IterateMiningNodes() do
  --   if node.nodeName == name then return "Mining" end
  -- end

  -- for node in LT:IterateHerbs() do
  --   if node.name == name then return "Herbalism" end
  -- end

  return nil
end

function GatheringInfo:IsProfessionItemName(name)

  if self:GetProfessionNameByEntryName(name) then return true end

  return false
end

function GatheringInfo:CalculateDifficultyByUnitLevel(unitLevel)
  if unitLevel <= 10 then
    return 1
  elseif unitLevel <= 20 then
    return (unitLevel-10) * 10
  elseif unitLevel > 20 then
    return unitLevel*5
  end
end

function GatheringInfo:GetGatheringSkillColor(minLevel, currentSkill)
  local lvl1Corr = 0
  if minLevel == 1 then
    lvl1Corr = -1
  end

  if currentSkill < minLevel then
    -- Red
    return self.GetRGBColorsFromQuestDifficulty("impossible")
  elseif currentSkill < minLevel + 25 + lvl1Corr then
    -- Orange
    return self.GetRGBColorsFromQuestDifficulty("verydifficult")
  elseif currentSkill < minLevel + 50 + lvl1Corr then
    -- Yellow
    return self.GetRGBColorsFromQuestDifficulty("difficult")
  elseif currentSkill < minLevel + 100 + lvl1Corr then
    -- Green
    return self.GetRGBColorsFromQuestDifficulty("standard")
  else
    -- Gray
    return self.GetRGBColorsFromQuestDifficulty("trivial")
  end
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

function GatheringInfo.GetRGBColorsFromQuestDifficulty(difficulty)

-- QuestDifficultyColors = {
--   ["impossible"]    = { r = 1.00, g = 0.10, b = 0.10, font = "QuestDifficulty_Impossible" }; -- red
--   ["verydifficult"] = { r = 1.00, g = 0.50, b = 0.25, font = "QuestDifficulty_VeryDifficult" }; -- orange
--   ["difficult"]   = { r = 1.00, g = 1.00, b = 0.00, font = "QuestDifficulty_Difficult" }; -- yellow
--   ["standard"]    = { r = 0.25, g = 0.75, b = 0.25, font = "QuestDifficulty_Standard" }; -- dim green
--   ["trivial"]     = { r = 0.50, g = 0.50, b = 0.50, font = "QuestDifficulty_Trivial" }; -- gray
-- };

  return QuestDifficultyColors[difficulty].r, QuestDifficultyColors[difficulty].g, QuestDifficultyColors[difficulty].b
end