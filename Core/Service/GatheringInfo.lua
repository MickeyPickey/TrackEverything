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

-- WoW Api's
local UnitExists = UnitExists

local private = {
  Mining = {
    LOOKUP = { L["Mining"], UNIT_SKINNABLE_ROCK},
    NODES = {
      { name = L["Copper Vein"], objId = 1731, minSkillLevel = 1, },
      { name = L["Tin Vein"], objId = 1732, minSkillLevel = 65, },
      { name = L["Incendicite Mineral Vein"], objId = 1610, minSkillLevel = 65, },
      { name = L["Silver Vein"], objId = 1733, minSkillLevel = 75, },
      { name = L["Ooze Covered Silver Vein"], objId = 73940, minSkillLevel = 75, },
      { name = L["Lesser Bloodstone Deposit"], objId = 2653, minSkillLevel = 75, },
      { name = L["Iron Deposit"], objId = 1735, minSkillLevel = 125, },
      { name = L["Ooze Covered Iron Deposit"], objId = 73939, minSkillLevel = 125, },
      { name = L["Indurium Mineral Vein"], objId = 19903, minSkillLevel = 150, },
      { name = L["Gold Vein"], objId = 1734, minSkillLevel = 155, },
      { name = L["Ooze Covered Gold Vein"], objId = 73941, minSkillLevel = 155, },
      { name = L["Mithril Deposit"], objId = 2040, minSkillLevel = 175, },
      { name = L["Ooze Covered Mithril Deposit"], objId = 123310, minSkillLevel = 175, },
      { name = L["Truesilver Deposit"], objId = 2047, minSkillLevel = 230, },
      { name = L["Ooze Covered Truesilver Deposit"], objId = 123309, minSkillLevel = 230, },
      { name = L["Dark Iron Deposit"], objId = 165658, minSkillLevel = 230, },
      { name = L["Small Thorium Vein"], objId = 324, minSkillLevel = 245, },
      { name = L["Ooze Covered Thorium Vein"], objId = 123848, minSkillLevel = 245, },
      { name = L["Rich Thorium Vein"], objId = 175404, minSkillLevel = 275, },
      { name = L["Ooze Covered Rich Thorium Vein"], objId = 177388, minSkillLevel = 275, },
      { name = L["Hakkari Thorium Vein"], objId = 180215, minSkillLevel = 275, },
      { name = L["Small ObsobjIdian Chunk"], objId = 181068, minSkillLevel = 305, },
      { name = L["Large ObsobjIdian Chunk"], objId = 181069, minSkillLevel = 305, },
      { name = L["Fel Iron Deposit"], objId = 181555, minSkillLevel = 300, },
      { name = L["Khorium Vein"], objId = 181557, minSkillLevel = 375, },
      { name = L["Adamantite Deposit"], objId = 181556, minSkillLevel = 325, },
      { name = L["Rich Adamantite Deposit"], objId = 181569, minSkillLevel = 350, },
      { name = L["Cobalt Deposit"], objId = 189978, minSkillLevel = 350, },
      { name = L["Rich Cobalt Deposit"], objId = 189979, minSkillLevel = 400, },
      { name = L["Saronite Deposit"], objId = 189980, minSkillLevel = 400, },
      { name = L["Rich Saronite Deposit"], objId = 189981, minSkillLevel = 425, },
      { name = L["Titanium Vein"], objId = 191133, minSkillLevel = 450, },
    },
  },
  Herbalism = {
    LOOKUP = { L["Herbalism"], UNIT_SKINNABLE_HERB, },
    NODES = {
      { name = L["Peacebloom"], objId = "", itemId = 2447, minSkillLevel = 1, },
      { name = L["Silverleaf"], objId = "", itemId = 765, minSkillLevel = 1, },
      { name = L["Earthroot"], objId = "", itemId = 2449, minSkillLevel = 15, },
      { name = L["Mageroyal"], objId = "", itemId = 785, minSkillLevel = 50, },
      { name = L["Briarthorn"], objId = "", itemId = 2450, minSkillLevel = 70, },
      { name = L["Stranglekelp"], objId = "", itemId = 3820, minSkillLevel = 85, },
      { name = L["Bruiseweed"], objId = "", itemId = 2453, minSkillLevel = 100, },
      { name = L["Wild Steelbloom"], objId = "", itemId = 3355, minSkillLevel = 115, },
      { name = L["Grave Moss"], objId = "", itemId = 3369, minSkillLevel = 120, },
      { name = L["Kingsblood"], objId = "", itemId = 3356, minSkillLevel = 125, },
      { name = L["Liferoot"], objId = "", itemId = 3357, minSkillLevel = 150, },
      { name = L["Fadeleaf"], objId = "", itemId = 3818, minSkillLevel = 160, },
      { name = L["Goldthorn"], objId = "", itemId = 3821, minSkillLevel = 170, },
      { name = L["Khadgar's Whisker"], objId = "", itemId = 3358, minSkillLevel = 185, },
      { name = L["Wintersbite"], objId = "", itemId = 3819, minSkillLevel = 195, },
      { name = L["Firebloom"], objId = "", itemId = 4625, minSkillLevel = 205, },
      { name = L["Purple Lotus"], objId = "", itemId = 8831, minSkillLevel = 210, },
      { name = L["Arthas' Tears"], objId = "", itemId = 8836, minSkillLevel = 220, },
      { name = L["Sungrass"], objId = "", itemId = 8838, minSkillLevel = 230, },
      { name = L["Blindweed"], objId = "", itemId = 8839, minSkillLevel = 235, },
      { name = L["Ghost Mushroom"], objId = "", itemId = 8845, minSkillLevel = 245, },
      { name = L["Gromsblood"], objId = "", itemId = 8846, minSkillLevel = 250, },
      { name = L["Golden Sansam"], objId = "", itemId = 13464, minSkillLevel = 260, },
      { name = L["Dreamfoil"], objId = "", itemId = 13463, minSkillLevel = 270, },
      { name = L["Mountain Silversage"], objId = "", itemId = 13465, minSkillLevel = 280, },
      { name = L["Plaguebloom"], objId = "", itemId = 13466, minSkillLevel = 285, },
      { name = L["Icecap"], objId = "", itemId = 13467, minSkillLevel = 290, },
      { name = L["Black Lotus"], objId = "", itemId = 13468, minSkillLevel = 300, },
      { name = L["Felweed"], objId = "", itemId = 22785, minSkillLevel = 300, },
      { name = L["Dreaming Glory"], objId = "", itemId = 22786, minSkillLevel = 315, },
      { name = L["Ragveil"], objId = "", itemId = 22787, minSkillLevel = 325, },
      { name = L["Terocone"], objId = "", itemId = 22789, minSkillLevel = 325, },
      { name = L["Flame Cap"], objId = "", itemId = 22788, minSkillLevel = 335, },
      { name = L["Ancient Lichen"], objId = "", itemId = 22790, minSkillLevel = 340, },
      { name = L["Netherbloom"], objId = "", itemId = 22791, minSkillLevel = 350, },
      { name = L["Nightmare Vine"], objId = "", itemId = 22792, minSkillLevel = 365, },
      { name = L["Mana Thistle"], objId = "", itemId = 22793, minSkillLevel = 375, },
      { name = L["Goldclover"], objId = "", itemId = 36901, minSkillLevel = 350, },
      { name = L["Firethorn"], objId = 191303, itemId = nil, minSkillLevel = 360, },
      { name = L["Tiger Lily"], objId = "", itemId = 36904, minSkillLevel = 375, },
      { name = L["Talandra's Rose"], objId = "", itemId = 36907, minSkillLevel = 385, },
      { name = L["Adder's Tongue"], objId = "", itemId = 36903, minSkillLevel = 400, },
      { name = L["Frozen Herb"], objId = 190173, itemId = nil, zoneMapIDs = {115,}, minSkillLevel = 400, },
      { name = L["Frozen Herb"], objId = 190175, itemId = nil, zoneMapIDs = {121,123}, minSkillLevel = 415, },
      { name = L["Lichbloom"], objId = "", itemId = 36905, minSkillLevel = 425, },
      { name = L["Icethorn"], objId = "", itemId = 36906, minSkillLevel = 435, },
      { name = L["Frost Lotus"], objId = "", itemId = 36908, minSkillLevel = 450, },
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

  -- As herbalism nodes and items uses the same name, we can use this to get all herb items localizations from the server, so we can ise localize node names using item objId.
  for _, val in ipairs(private.Herbalism.NODES) do
    local itemId = val.itemId

    if itemId then
      GetItemInfo(itemId)
    end
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

function GatheringInfo:GetProfessionInfoByItemName(itemName, professionName, zoneMapID)
  assert(itemName and type(itemName) == "string", format("Wrong data type, expected 'string', got %s ", type(itemName)) )
  assert(professionName and type(professionName) == "string", format("Wrong data type, expected 'string', got %s ", type(professionName)) )

  local professionTable = self:GetDataByKey(professionName)

  for _, node in ipairs(professionTable.NODES) do
    local lookupName = node.name

    --Getting Localized name to compare with from itemInfo if possible
    if node.itemId then
      lookupName = GetItemInfo(node.itemId)
    end

    if itemName == lookupName then
      if zoneMapID and node.zoneMapIDs then
        for _, mapID in ipairs(node.zoneMapIDs) do
          if zoneMapID == mapID then
            return node.minSkillLevel, node.objId
          end
        end
      else
        return node.minSkillLevel, node.objId
      end
    end
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
          if node.itemId then
            local localizedName = GetItemInfo(node.itemId)
            if name == localizedName then return professionName end
          elseif node.objId then
            if name == node.name then return professionName end
          end
        end
      else
        for _, node in ipairs(tbl.NODES) do
          if node.name == name then return professionName end
        end
      end
    end
  end

  -- =================================================================================
  --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we dobjIdn't get
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