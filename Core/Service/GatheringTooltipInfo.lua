local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local GatheringData = TE.Include("Data.Gathering")
local Colors = TE.Include("Data.Colors")
local GatheringTooltipInfo = TE.Include("Service.GatheringTooltipInfo")
local Log = TE.Include("Util.Log")
local MyLib = TE.Include("Util.MyLib")
local L = TE.Include("Locale")

local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local ADDON_NAME_COLOR = ADDON_TABLE.ADDON_NAME_COLOR
local ADDON_NAME_ACRONYM = ADDON_TABLE.ADDON_NAME_ACRONYM

-- =====================================================================================================
--                                   GAME CONSTANT DEFAULT COLORS RGB
-- =====================================================================================================
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR -- Blizzard yellow default text color ( eg. Tooltip Title)
local RED_FONT_COLOR = RED_FONT_COLOR
local ORANGE_FONT_COLOR = ORANGE_FONT_COLOR
local YELLOW_FONT_COLOR = YELLOW_FONT_COLOR
-- local GREEN_FONT_COLOR = GREEN_FONT_COLOR
local GREEN_FONT_COLOR = {0.25097984075546, 0.75293952226639, 0.25097984075546, 0.99999779462814}
local GRAY_FONT_COLOR = GRAY_FONT_COLOR
-- =====================================================================================================

local private = {
  MINIMAP_TOOLTIP_REDRAWN = false,
  TOOLTIP_DEFAULTS_CHANGED = false,
}

-- do not change tooltip if owner is blacklisted. Need to fix it in more smart way later
private.TooltipOwnersBL = {
  "QuestieFrame",
}

function GatheringTooltipInfo:OnInitialize()
  GameTooltip:SetScript("OnShow", function()

    if self:CanUpdateWorldTooltip() then self:ModifyTooltip() end
    if self:CanUpdateMinimapTooltip() or self:CanUpdateWorldMapTooltip() then self:RedrawTooltip() end

  end)

  GameTooltip:HookScript("OnHide", function() -- reseting GameTooltip becouse his default formating changing in RedrawTooltip() function
    if private.TOOLTIP_DEFAULTS_CHANGED then
      self:ResetGameTooltipDefaults(GameTooltip)
      private.TOOLTIP_DEFAULTS_CHANGED = false
    end
  end)

  GameTooltip:HookScript("OnTooltipCleared", function() --handle GameTooltip updates. OnTooltipCleared event fires every time GameTooltip redrawn
    if self:CanUpdateMinimapTooltip() and private.MINIMAP_TOOLTIP_REDRAWN then
      self:RedrawTooltip()
    end

    if self:CanUpdateWorldMapTooltip() and private.MINIMAP_TOOLTIP_REDRAWN then
      self:RedrawTooltip()
    end

    if self:CanUpdateWorldTooltip() then
      self:ScheduleTimer(function() self:ModifyTooltip() end, 0,00000001) -- need to wait before new GameTooltip drawn, becouse it apears not instantly after OnTooltipCleared event
    end
  end)
end

function GatheringTooltipInfo:OnEnable()
  -- self:ScheduleRepeatingTimer(function() 
  --   MyLib.PrintMouseoverInfo() 
  --   if GameTooltip:IsShown() then
  --     print("GameTooltip parent:", GameTooltip:GetOwner():GetName())
  --   end
  -- end, 1)
end

function GatheringTooltipInfo:CanUpdateWorldTooltip()
  return TE.db.profile.tooltip.requiredProfessionLevel.enableWorld and GameTooltip:IsShown() and MouseIsOver(WorldFrame) and GameTooltip:GetOwner():GetName() == "UIParent"
end

function GatheringTooltipInfo:CanUpdateMinimapTooltip()
  return TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap and GameTooltip:IsShown() and MouseIsOver(Minimap) and Minimap:IsVisible() 
end

function GatheringTooltipInfo:CanUpdateWorldMapTooltip()
  return TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap and GameTooltip:IsShown() and WorldMapFrame:IsVisible() and MouseIsOver(WorldMapFrame) 
end

function GatheringTooltipInfo:ModifyTooltip()
  if not self:IsProfessionInTooltip() then return end

  local profession, lookup, rowNum = self:GetTooltipProfession()

  local levelReq = "?"

  if profession == UNIT_SKINNABLE_LEATHER then
    local unitLevel = UnitLevel("mouseover")
    levelReq = self:CalculateSkinningLevel(unitLevel)
  else
    local tooltipItemName = GameTooltipTextLeft1:GetText()
    local _, difficulty = GatheringData:GetProfessionInfoByItemName(tooltipItemName)
    levelReq = difficulty[1]
  end

  _G["GameTooltipTextLeft"..rowNum]:SetText(self:GetTooltipStr(lookup, levelReq))

  GameTooltip:Show()
end

function GatheringTooltipInfo:RedrawTooltip()
  local owner = GameTooltip:GetOwner():GetName()
  local excludeOwners = private.TooltipOwnersBL

  -- do not change tooltip if owner is blacklisted. Need to fix it in more smart way later
  for i, j in ipairs(excludeOwners) do
    if owner and string.find(owner, "^" .. j) then return end
  end

  private.MINIMAP_TOOLTIP_REDRAWN = false

  local gameTooltipRows = {}
  local newTooltipRows = {}

  for i = 1, GameTooltip:NumLines() do
    table.insert(gameTooltipRows, { 
      lineNum = i, 
      text = _G["GameTooltipTextLeft"..i]:GetText()
    })
  end

  for i, row in ipairs(gameTooltipRows) do
    local rowWords = {}

    for word in row.text:gmatch("[^\n]+") do
      table.insert(rowWords, word)
    end

    for i, word in ipairs(rowWords) do
      table.insert(newTooltipRows, { type = "title", text = word ,})
    end

    for i, title in ipairs(newTooltipRows) do
      local titleNameUnescaped = MyLib.UnescapeStr(title.text)
      if self:IsProfessionItemInTooltip(titleNameUnescaped) then
        local profName, difficulty = GatheringData:GetProfessionInfoByItemName(titleNameUnescaped)
        local levelReq = difficulty[1]
        table.insert(newTooltipRows, i + 1, { type = "info", text = self:GetTooltipStr(profName, levelReq)})
      end
    end
  end

  GameTooltip:ClearLines()

  for i, row in ipairs(newTooltipRows) do
    GameTooltip:AddLine(row.text)
    local targetRow = _G["GameTooltipTextLeft"..i]
    local infoRowColor = nil
    if row.type == "title" then
      targetRow:SetFontObject(GameTooltipHeaderText)
      targetRow:SetTextColor(NORMAL_FONT_COLOR:GetRGBA())
    elseif row.type == "info" then
      targetRow:SetFontObject(GameTooltipText)
      local itemName = MyLib.UnescapeStr(_G["GameTooltipTextLeft"..i-1]:GetText())
      targetRow:SetTextColor(self:GetProfessionRequiredSkillColor(itemName))
    end
  end

  GameTooltip:Show()

  private.MINIMAP_TOOLTIP_REDRAWN = true
  private.TOOLTIP_DEFAULTS_CHANGED = true
end

function GatheringTooltipInfo:CalculateSkinningLevel(unitLevel)
  if unitLevel <= 10 then 
    return 1 
  elseif unitLevel <= 20 then
    return (unitLevel-10) * 10
  elseif unitLevel > 20 then
    return unitLevel*5
  end
end

function GatheringTooltipInfo:GetTooltipProfession(profName)

  if not profName then -- if no profName passed, checking all professions from GatheringData
    local professionLookups = GatheringData:GetLookupValues()
    for profession, lookups in pairs(professionLookups) do
        for index, lookup in ipairs(lookups) do
          for i = 1, GameTooltip:NumLines() do
            if _G["GameTooltipTextLeft"..i]:GetText() == lookup then return profession, lookup, i end
          end
        end
    end

    return nil
  end

  for i = 1, GameTooltip:NumLines() do
    if _G["GameTooltipTextLeft"..i]:GetText() == profName then return profName, profName, i end
  end

  return nil
end

function GatheringTooltipInfo:IsProfessionInTooltip()
  local professionLookups = GatheringData:GetLookupValues()

  for profession, lookups in pairs(professionLookups) do
    for index, lookup in ipairs(lookups) do
      for i = 1, GameTooltip:NumLines() do
        if _G["GameTooltipTextLeft"..i]:GetText() == lookup then return true end
      end
    end
  end

  return false
end

function GatheringTooltipInfo:IsProfessionItemInTooltip(itemName)
  local deposits = GatheringData:GetItemsByKey(L["Mining"])

  for i, deposit in ipairs(deposits) do
    if itemName == deposit.name then return true end
  end

  local herbs = GatheringData:GetItemsByKey(L["Herbalism"])

  for i, herb in ipairs(herbs) do
    local herbNameLocalized = GetItemInfo(herb.itemId)
    if itemName == herbNameLocalized then return true end
  end

  return false
end

function GatheringTooltipInfo:GetProfessionRequiredSkillColor(itemName)

  local profName, difficulty = GatheringData:GetProfessionInfoByItemName(itemName)

  local currentLevel = self:GetPlayerProfessionSkillLevelByProfessionName(profName)

  if not currentLevel then return RED_FONT_COLOR:GetRGBA() end

  local orangeLevel, yellowLevel, greenLevel, grayLevel = unpack(difficulty)

  if currentLevel < orangeLevel then 
    return RED_FONT_COLOR:GetRGBA()
  elseif currentLevel >= orangeLevel and currentLevel < yellowLevel then
    return ORANGE_FONT_COLOR:GetRGBA()
  elseif currentLevel >= yellowLevel and currentLevel < greenLevel then
    return YELLOW_FONT_COLOR:GetRGBA()
  elseif currentLevel >= greenLevel and currentLevel < grayLevel then
    -- return GREEN_FONT_COLOR:GetRGBA()
    return unpack(GREEN_FONT_COLOR)
  elseif currentLevel >= grayLevel then
    return GRAY_FONT_COLOR:GetRGBA()
  end

  return RED_FONT_COLOR:GetRGBA()
end

function GatheringTooltipInfo:GetPlayerProfessionSkillLevelByProfessionName(profName)

  if GetNumPrimaryProfessions() == 0 then return nil end -- no primary professions

  for i = 1, GetNumSkillLines() do
    local skillName, _, _, skillRank = GetSkillLineInfo(i)
    if skillName == profName then return skillRank end
  end

  return nil
end

function GatheringTooltipInfo:GetTooltipStr(profName, levelReq)
  return "["..ADDON_NAME_COLOR..ADDON_NAME_ACRONYM.."|r".."] "..profName.." ["..levelReq.."]"
end

function GatheringTooltipInfo:ResetGameTooltipDefaults(tooltip)
  for i = 1, select("#", tooltip:GetRegions()) do
    local region = select(i, tooltip:GetRegions())
    if region and region:GetObjectType() == "FontString" then
      region:SetFontObject(GameTooltipText)
    end
  end
  GameTooltipTextLeft1:SetFontObject(GameTooltipHeaderText)
end