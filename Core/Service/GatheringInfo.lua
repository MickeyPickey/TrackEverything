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
local GetItemInfo = GetItemInfo

local private = {
  Mining = {
    LOOKUP = { L["Mining"], UNIT_SKINNABLE_ROCK},
    NODES = {
      { name = L["Copper Vein"], id = 1731, minLevel = 1, },
      { name = L["Tin Vein"], id = 1732, minLevel = 65, },
      { name = L["Incendicite Mineral Vein"], id = 1610, minLevel = 65, },
      { name = L["Silver Vein"], id = 1733, minLevel = 75, },
      { name = L["Ooze Covered Silver Vein"], id = 73940, minLevel = 75, },
      { name = L["Lesser Bloodstone Deposit"], id = 2653, minLevel = 75, },
      { name = L["Iron Deposit"], id = 1735, minLevel = 125, },
      { name = L["Ooze Covered Iron Deposit"], id = 73939, minLevel = 125, },
      { name = L["Indurium Mineral Vein"], id = 19903, minLevel = 150, },
      { name = L["Gold Vein"], id = 1734, minLevel = 155, },
      { name = L["Ooze Covered Gold Vein"], id = 73941, minLevel = 155, },
      { name = L["Mithril Deposit"], id = 2040, minLevel = 175, },
      { name = L["Ooze Covered Mithril Deposit"], id = 123310, minLevel = 175, },
      { name = L["Truesilver Deposit"], id = 2047, minLevel = 230, },
      { name = L["Ooze Covered Truesilver Deposit"], id = 123309, minLevel = 230, },
      { name = L["Dark Iron Deposit"], id = 165658, minLevel = 230, },
      { name = L["Small Thorium Vein"], id = 324, minLevel = 245, },
      { name = L["Ooze Covered Thorium Vein"], id = 123848, minLevel = 245, },
      { name = L["Rich Thorium Vein"], id = 175404, minLevel = 275, },
      { name = L["Ooze Covered Rich Thorium Vein"], id = 177388, minLevel = 275, },
      { name = L["Hakkari Thorium Vein"], id = 180215, minLevel = 275, },
      { name = L["Small Obsidian Chunk"], id = 181068, minLevel = 305, },
      { name = L["Large Obsidian Chunk"], id = 181069, minLevel = 305, },
      { name = L["Fel Iron Deposit"], id = 181555, minLevel = 300, },
      { name = L["Khorium Vein"], id = 181557, minLevel = 375, },
      { name = L["Adamantite Deposit"], id = 181556, minLevel = 325, },
      { name = L["Rich Adamantite Deposit"], id = 181569, minLevel = 350, },
    },
    UNITS = {
    },
  },
  Herbalism = {
    LOOKUP = { L["Herbalism"], UNIT_SKINNABLE_HERB, },
    NODES = {
      { name = L["Peacebloom"], id = "", itemId = 2447, minLevel = 1, },
      { name = L["Silverleaf"], id = "", itemId = 765, minLevel = 1, },
      { name = L["Earthroot"], id = "", itemId = 2449, minLevel = 15, },
      { name = L["Mageroyal"], id = "", itemId = 785, minLevel = 50, },
      { name = L["Briarthorn"], id = "", itemId = 2450, minLevel = 70, },
      { name = L["Stranglekelp"], id = "", itemId = 3820, minLevel = 85, },
      { name = L["Bruiseweed"], id = "", itemId = 2453, minLevel = 100, },
      { name = L["Wild Steelbloom"], id = "", itemId = 3355, minLevel = 115, },
      { name = L["Grave Moss"], id = "", itemId = 3369, minLevel = 120, },
      { name = L["Kingsblood"], id = "", itemId = 3356, minLevel = 125, },
      { name = L["Liferoot"], id = "", itemId = 3357, minLevel = 150, },
      { name = L["Fadeleaf"], id = "", itemId = 3818, minLevel = 160, },
      { name = L["Goldthorn"], id = "", itemId = 3821, minLevel = 170, },
      { name = L["Khadgar's Whisker"], id = "", itemId = 3358, minLevel = 185, },
      { name = L["Wintersbite"], id = "", itemId = 3819, minLevel = 195, },
      { name = L["Firebloom"], id = "", itemId = 4625, minLevel = 205, },
      { name = L["Purple Lotus"], id = "", itemId = 8831, minLevel = 210, },
      { name = L["Arthas' Tears"], id = "", itemId = 8836, minLevel = 220, },
      { name = L["Sungrass"], id = "", itemId = 8838, minLevel = 230, },
      { name = L["Blindweed"], id = "", itemId = 8839, minLevel = 235, },
      { name = L["Ghost Mushroom"], id = "", itemId = 8845, minLevel = 245, },
      { name = L["Gromsblood"], id = "", itemId = 8846, minLevel = 250, },
      { name = L["Golden Sansam"], id = "", itemId = 13464, minLevel = 260, },
      { name = L["Dreamfoil"], id = "", itemId = 13463, minLevel = 270, },
      { name = L["Mountain Silversage"], id = "", itemId = 13465, minLevel = 280, },
      { name = L["Plaguebloom"], id = "", itemId = 13466, minLevel = 285, },
      { name = L["Icecap"], id = "", itemId = 13467, minLevel = 290, },
      { name = L["Black Lotus"], id = "", itemId = 13468, minLevel = 300, },
      { name = L["Felweed"], id = "", itemId = 22785, minLevel = 300, },
      { name = L["Dreaming Glory"], id = "", itemId = 22786, minLevel = 315, },
      { name = L["Ragveil"], id = "", itemId = 22787, minLevel = 325, },
      { name = L["Terocone"], id = "", itemId = 22789, minLevel = 325, },
      { name = L["Flame Cap"], id = "", itemId = 22788, minLevel = 335, },
      { name = L["Ancient Lichen"], id = "", itemId = 22790, minLevel = 340, },
      { name = L["Netherbloom"], id = "", itemId = 22791, minLevel = 350, },
      { name = L["Nightmare Vine"], id = "", itemId = 22792, minLevel = 365, },
      { name = L["Mana Thistle"], id = "", itemId = 22793, minLevel = 375, },
    },
    UNITS = {
      { name = L["Fungal Giant"], id = 19734, minLevel = 315, },
      { name = L["Bog Lord"], id = 18127, minLevel = 320, },
    },
  },
  Skinning = {
    LOOKUP  = { UNIT_SKINNABLE_LEATHER, },
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
  local minLevel = self:GetProfessionInfoByItemName(itemName, professionName)

  local currentSkill = self:GetPlayerProfessionSkillLevelByProfessionName(professionName)

  -- return RED if no prefession learned
  if not currentSkill then return RED_FONT_COLOR:GetRGB() end

  return LT:GetGatheringSkillColor(minLevel, currentSkill)
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
      if node.name == itemName then return node.minLevel, node.id end
    end

    for _, unit in ipairs(professionTable.UNITS) do
      if unit.name == itemName then return unit.minLevel, unit.id end
    end

    -- =================================================================================
    --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we didn't get
    data from default table--]]
    -- =================================================================================
    for node in LT:IterateMiningNodes() do
      if node.nodeName == itemName then return node.minLevel, node.nodeObjectID end
    end
  elseif professionName == "Herbalism"  then
    for _, node in ipairs(professionTable.NODES) do
      local localizedName = GetItemInfo(node.itemId)
      if localizedName == itemName then return node.minLevel, node.id end
    end

    for _, unit in ipairs(professionTable.UNITS) do
      if unit.name == itemName then return unit.minLevel, unit.id end
    end

    -- =================================================================================
    --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we didn't get
    data from default table--]]
    -- =================================================================================
    for node in LT:IterateHerbs() do
      if node.name == itemName then return node.minLevel, node.itemID end
    end
  elseif professionName == "Skinning" then
    local unitLevel = UnitLevel("mouseover")
    local minLevel = self:CalculateSkinningLevel(unitLevel)
    return minLevel, nil
  end

  -- if nothing found untill this point we return nil and we will see [?] minLevel for this herb.
  return professionName, "?", nil
end

function GatheringInfo:GetProfessionNameByEntryName(name)
  for professionName, tbl in pairs(private) do
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

    for _, unit in ipairs(tbl.UNITS) do
      if unit.name == name then return professionName end
    end
  end


  -- =================================================================================
  --[[ We use LibTouristClassic-1.0 libriary here as backup here in case we didn't get
  data from default table--]]
  -- =================================================================================
  for node in LT:IterateMiningNodes() do
    if node.nodeName == name then return "Mining" end
  end

  for node in LT:IterateHerbs() do
    if node.name == name then return "Herbalism" end
  end

  return nil
end

function GatheringInfo:IsProfessionItemName(name)

  if self:GetProfessionNameByEntryName(name) then return true end

  return false
end

function GatheringInfo:CalculateSkinningLevel(unitLevel)
  if unitLevel <= 10 then
    return 1
  elseif unitLevel <= 20 then
    return (unitLevel-10) * 10
  elseif unitLevel > 20 then
    return unitLevel*5
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