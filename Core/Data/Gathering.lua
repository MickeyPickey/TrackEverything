local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local L = TE.Include('Locale')

local Gathering = TE.Init('Data.Gathering', 'AceEvent-3.0')

local private = {
  [L['Mining']] = {
    LOOKUP = { L['Mining'], L['Requires Mining'], },
    ITEMS = {
      { name = L['Copper Vein'], levelReq = 1, },
      { name = L['Tin Vein'], levelReq = 1, },
      { name = L['Incendicite Mineral Vein'], levelReq = 65, },
      { name = L['Silver Vein'], levelReq = 75, },
      { name = L['Lesser Bloodstone Deposit'], levelReq = 75, },
      { name = L['Ooze Covered Silver Vein'], levelReq = 75, },
      { name = L['Iron Deposit'], levelReq = 100, },
      { name = L['Ooze Covered Iron Deposit'], levelReq = 100, },
      { name = L['Indurium Mineral Vein'], levelReq = 150, },
      { name = L['Gold Vein'], levelReq = 155, },
      { name = L['Ooze Covered Gold Vein'], levelReq = 155, },
      { name = L['Mithril Deposit'], levelReq = 175, },
      { name = L['Ooze Covered Mithril Deposit'], levelReq = 175, },
      { name = L['Rich Thorium Vein'], levelReq = 215, },
      { name = L['Truesilver Deposit'], levelReq = 230, },
      { name = L['Dark Iron Deposit'], levelReq = 230, },
      { name = L['Small Thorium Vein'], levelReq = 245, },
      { name = L['Ooze Covered Thorium Vein'], levelReq = 245, },
      { name = L['Ooze Covered Rich Thorium Vein'], levelReq = 275, },
      { name = L['Hakkari Thorium Vein'], levelReq = 275, },
      { name = L['Small Obsidian Chunk'], levelReq = 305, },
      { name = L['Large Obsidian Chunk'], levelReq = 305, },
      { name = L['Arcanite Lode'], levelReq = 310, },
      { name = L['Ooze Covered Arcanite Lode'], levelReq = 310, },
    },

  },
  [L['Herbalism']] = {
    LOOKUP = { L['Herbalism'], L['Requires Herbalism'], },
    ITEMS = {
      { name = L['Peacebloom'], levelReq = 1, itemId = 2447, },
      { name = L['Silverleaf'], levelReq = 1, itemId = 765, },
      { name = L['Violet Tragan'], levelReq = 1, itemId = 8526, },
      { name = L['Gloom Weed'], levelReq = 1, itemId = 12737, },
      { name = L['Incendia Agave'], levelReq = 1, itemId = 12732, },
      { name = L['Serpentbloom'], levelReq = 1, itemId = 5339, },
      { name = L['Doom Weed'], levelReq = 1, itemId = 13702, },
      { name = L['Earthroot'], levelReq = 15, itemId = 2449, },
      { name = L['Mageroyal'], levelReq = 50, itemId = 785, },
      { name = L['Briarthorn'], levelReq = 70, itemId = 2450, },
      { name = L['Stranglekelp'], levelReq = 85, itemId = 3820, },
      { name = L['Bruiseweed'], levelReq = 100, itemId = 2453, },
      { name = L['Wild Steelbloom'], levelReq = 115, itemId = 3355, },
      { name = L['Grave Moss'], levelReq = 120, itemId = 3369, },
      { name = L['Kingsblood'], levelReq = 125, itemId = 3356, },
      { name = L['Liferoot'], levelReq = 150, itemId = 3357, },
      { name = L['Fadeleaf'], levelReq = 160, itemId = 3818, },
      { name = L['Goldthorn'], levelReq = 170, itemId = 3821, },
      { name = L["Khadgar's Whisker"], levelReq = 185, itemId = 3358, },
      { name = L['Wintersbite'], levelReq = 195, itemId = 3819, },
      { name = L['Firebloom'], levelReq = 205, itemId = 4625, },
      { name = L['Purple Lotus'], levelReq = 210, itemId = 8831, },
      { name = L["Arthas' Tears"], levelReq = 220, itemId = 8836, },
      { name = L['Sungrass'], levelReq = 230, itemId = 8838, },
      { name = L['Blindweed'], levelReq = 235, itemId = 8839, },
      { name = L['Ghost Mushroom'], levelReq = 245, itemId = 8845, },
      { name = L['Gromsblood'], levelReq = 250, itemId = 8846, },
      { name = L['Golden Sansam'], levelReq = 260, itemId = 13464, },
      { name = L['Dreamfoil'], levelReq = 270, itemId = 13463, },
      { name = L['Mountain Silversage'], levelReq = 280, itemId = 13465, },
      { name = L['Plaguebloom'], levelReq = 285, itemId = 13466, },
      { name = L['Icecap'], levelReq = 290, itemId = 13467, },
      { name = L['Black Lotus'], levelReq = 300, itemId = 13468, },
    },
  },
  [L['Skinnable']] = {
    LOOKUP  = { L['Skinnable'], },
  },
}

function Gathering:OnInitialize()
  self:GetHerbsItemInfo()
end

function Gathering:GetDataByKey(key)
  return private[key]
end

function Gathering:GetItemsByKey(key)
  return private[key].ITEMS
end

function Gathering:GetData()
  return private
end

function Gathering:GetLookupValues()
  local lookupValues = nil

  for key, val in pairs(private) do 
    for i, val in ipairs(private[key].LOOKUP) do
      if not lookupValues then lookupValues = {} end
      table.insert(lookupValues, val)
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

function Gathering:GetHerbsItemInfo()
  for i, val in ipairs(private[L['Herbalism']].ITEMS) do
    GetItemInfo(val.itemId)
  end
end