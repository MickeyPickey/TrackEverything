local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local L = TE.Include("Locale")

local Gathering = TE.Init("Data.Gathering", "AceEvent-3.0")

local private = {
  [L["Mining"]] = {
    LOOKUP = { L["Mining"], UNIT_SKINNABLE_ROCK},
    ITEMS = {
      { name = L["Copper Vein"], difficulty = { 1, 25, 50, 100 }, },
      { name = L["Tin Vein"], difficulty = { 65, 90, 115, 165 }, },
      { name = L["Incendicite Mineral Vein"], difficulty = { 65, 90, 115, 165 }, },
      { name = L["Silver Vein"], difficulty = { 75, 100, 125, 175 }, },
      { name = L["Ooze Covered Silver Vein"], difficulty = { 75, 100, 125, 175 }, },
      { name = L["Lesser Bloodstone Deposit"], difficulty = { 75, 100, 125, 175 }, },
      { name = L["Iron Deposit"], difficulty = { 125, 150, 175, 225 }, },
      { name = L["Ooze Covered Iron Deposit"], difficulty = { 125, 150, 175, 225 }, },
      { name = L["Indurium Mineral Vein"], difficulty = { 150, 175, 200, 250 }, },
      { name = L["Gold Vein"], difficulty = { 155, 180, 205, 225 } },
      { name = L["Ooze Covered Gold Vein"], difficulty = { 155, 180, 205, 225 }, },
      { name = L["Mithril Deposit"], difficulty = { 175, 200, 225, 275 }, },
      { name = L["Ooze Covered Mithril Deposit"], difficulty = { 175, 200, 225, 275 }, },
      { name = L["Truesilver Deposit"], difficulty = { 230, 255, 280, 330 }, },
      { name = L["Ooze Covered Truesilver Deposit"], difficulty = { 230, 255, 280, 330 }, },
      { name = L["Dark Iron Deposit"], difficulty = { 230, 255, 280, 330 }, },
      { name = L["Small Thorium Vein"], difficulty = { 245, 270, 295, 345 }, },
      { name = L["Ooze Covered Thorium Vein"], difficulty = { 245, 270, 295, 345 }, },
      { name = L["Rich Thorium Vein"], difficulty = { 275, 290, 300, 350 }, },
      { name = L["Ooze Covered Rich Thorium Vein"], difficulty = { 275, 290, 300, 350 }, },
      { name = L["Hakkari Thorium Vein"], difficulty = { 275, 290, 300, 350 }, },
      { name = L["Small Obsidian Chunk"], difficulty = { 305, 330, 355, 405 }, },
      { name = L["Large Obsidian Chunk"], difficulty = { 305, 330, 355, 405 }, },
    },
  },
  [L["Herbalism"]] = {
    LOOKUP = { L["Herbalism"], L["Requires Herbalism"], UNIT_SKINNABLE_HERB, },
    ITEMS = {
      { name = L["Peacebloom"], itemId = 2447, difficulty = { 1, 25, 50, 100 }, },
      { name = L["Silverleaf"], itemId = 765, difficulty = { 1, 25, 50, 100 }, },
      { name = L["Earthroot"], itemId = 2449, difficulty = { 15, 40, 65, 115 }, },
      { name = L["Mageroyal"], itemId = 785, difficulty = { 50, 75, 100, 150 }, },
      { name = L["Briarthorn"], itemId = 2450, difficulty = { 70, 95, 120, 170 }, },
      { name = L["Stranglekelp"], itemId = 3820, difficulty = { 85, 110, 135, 185 }, },
      { name = L["Bruiseweed"], itemId = 2453, difficulty = { 100, 125, 150, 200 }, },
      { name = L["Wild Steelbloom"], levelReq = 115, itemId = 3355, difficulty = { 115, 140, 165, 215 }, },
      { name = L["Grave Moss"], itemId = 3369, difficulty = { 120, 145, 170, 220 }, },
      { name = L["Kingsblood"], itemId = 3356, difficulty = { 125, 150, 175, 225 }, },
      { name = L["Liferoot"], itemId = 3357, difficulty = { 150, 175, 200, 250 }, },
      { name = L["Fadeleaf"], itemId = 3818, difficulty = { 160, 185, 210, 260 }, },
      { name = L["Goldthorn"], itemId = 3821, difficulty = { 170, 195, 220, 270 }, },
      { name = L["Khadgar's Whisker"], itemId = 3358, difficulty = { 185, 210, 235, 285 }, },
      { name = L["Wintersbite"], itemId = 3819, difficulty = { 195, 220, 245, 295 }, },
      { name = L["Firebloom"], itemId = 4625, difficulty = { 205, 230, 255, 305 }, },
      { name = L["Purple Lotus"], itemId = 8831, difficulty = { 210, 235, 255, 305 }, },
      { name = L["Arthas' Tears"], itemId = 8836, difficulty = { 220, 245, 270, 320 }, },
      { name = L["Sungrass"], itemId = 8838, difficulty = { 230, 255, 280, 330 }, },
      { name = L["Blindweed"], itemId = 8839, difficulty = { 235, 260, 285, 335 }, },
      { name = L["Ghost Mushroom"], itemId = 8845, difficulty = { 245, 270, 295, 345 }, },
      { name = L["Gromsblood"], itemId = 8846, difficulty = { 250, 275, 300, 350 }, },
      { name = L["Golden Sansam"], itemId = 13464, difficulty = { 260, 285, 310, 360 }, },
      { name = L["Dreamfoil"], itemId = 13463, difficulty = { 270, 295, 320, 370 }, },
      { name = L["Mountain Silversage"], itemId = 13465, difficulty = { 280, 305, 330, 380 }, },
      { name = L["Plaguebloom"], itemId = 13466, difficulty = { 285, 310, 335, 385 }, },
      { name = L["Icecap"], itemId = 13467, difficulty = { 290, 315, 340, 390 }, },
      { name = L["Black Lotus"], itemId = 13468, difficulty = { 300, 325, 350, 400 }, },
    },
  },
  [UNIT_SKINNABLE_LEATHER] = {
    LOOKUP  = { UNIT_SKINNABLE_LEATHER, },
  },
}

function Gathering:OnInitialize()
  self:GetHerbsItemInfoFromServer()
end

function Gathering:GetDataByKey(key)
  return private[key]
end

function Gathering:GetItemsByKey(key)
  return private[key].ITEMS
end

function Gathering:GetItemByName(name)
  assert(name and type(name) == "string", format("Wrong data type, expected "string", got %s ", type(name)) )

  for i, item in ipairs(private[L["Mining"]].ITEMS) do
    if item.name == name then return item end
  end

  for i, item in ipairs(private[L["Herbalism"]].ITEMS) do
    local itemName = GetItemInfo(item.itemId)
    if itemName == name then return item end
  end

  return nil
end

function Gathering:GetItemDifficultyByName(name)
  assert(name and type(name) == "string", format("Wrong data type, expected "string", got %s ", type(name)) )
  local item = self:GetItemByName(name)

  if item then return item.difficulty end

  return nil
end

function Gathering:GetProfessionInfoByItemName(name)
  assert(name and type(name) == "string", format("Wrong data type, expected "string", got %s ", type(name)) )

  local deposits = self:GetItemsByKey(L["Mining"])

  for i, deposit in ipairs(deposits) do
    if name == deposit.name then return L["Mining"], deposit.difficulty end
  end

  local herbs = self:GetItemsByKey(L["Herbalism"])

  for i, herb in ipairs(herbs) do
    local herbNameLocalized = GetItemInfo(herb.itemId)
    if herbNameLocalized == name then return L["Herbalism"], herb.difficulty end
  end

  return nil
end

function Gathering:GetData()
  return private
end

function Gathering:GetLookupValues()
  local lookupValues = {}

  for key, val in pairs(private) do
    for i, val in ipairs(private[key].LOOKUP) do
      if not lookupValues[key] then lookupValues[key] = {} end
      table.insert(lookupValues[key], val)
    end
  end

  return lookupValues
end

function Gathering:GetDataKeyByLookupValue(value)
  for key, val in pairs(private) do 
    for i, val in ipairs(private[key].LOOKUP) do
      if value == val then return key end
    end
  end
end

function Gathering:GetHerbsItemInfoFromServer()
  for i, val in ipairs(private[L["Herbalism"]].ITEMS) do
    GetItemInfo(val.itemId)
  end
end