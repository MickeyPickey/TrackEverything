local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local GatheringInfo = TE.Include("GatheringInfo")
local Tooltip = TE.Include("Tooltip")
local MyLib = TE.Include("Util.MyLib")
local L = TE.Include("Locale")

local ADDON_NAME_COLOR = ADDON_TABLE.ADDON_NAME_COLOR
local ADDON_NAME_ACRONYM = ADDON_TABLE.ADDON_NAME_ACRONYM

-- WoW API's
local MouseIsOver = MouseIsOver

-- =====================================================================================================
--                                   GAME CONSTANT DEFAULT COLORS RGB
-- =====================================================================================================
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR -- Blizzard yellow default text color ( eg. Tooltip Title)

-- -- *************** proly we don't need this anymore ****************
-- local RED_FONT_COLOR = RED_FONT_COLOR
-- local ORANGE_FONT_COLOR = ORANGE_FONT_COLOR
-- local YELLOW_FONT_COLOR = YELLOW_FONT_COLOR
-- local GREEN_FONT_COLOR = GREEN_FONT_COLOR
-- local GRAY_FONT_COLOR = GRAY_FONT_COLOR
-- -- *************** proly we don't need this anymore ****************
-- =====================================================================================================

local private = {
  MINIMAP_TOOLTIP_REDRAWN = false,
  TOOLTIP_DEFAULTS_CHANGED = false,
}

function Tooltip:OnInitialize()

  GameTooltip:SetScript("OnShow", function()
    if self:CanUpdateWorldObjectTooltip() then self:UpdateWorldObjTooltip() end
    if self:CanUpdateMinimapObjectTooltip() then self:RedrawTooltip(C_Map.GetBestMapForUnit("player")) end
    if self:CanUpdateMapObjectTooltip() then self:RedrawTooltip(WorldMapFrame:GetMapID()) end
  end)

  GameTooltip:HookScript("OnHide", function() -- reseting GameTooltip becouse his default formating changing in RedrawTooltip() function
    if private.TOOLTIP_DEFAULTS_CHANGED then
      self:ResetGameTooltipDefaults(GameTooltip)
      private.TOOLTIP_DEFAULTS_CHANGED = false
    end
  end)

  GameTooltip:HookScript("OnTooltipCleared", function() --handle GameTooltip updates. OnTooltipCleared event fires every time GameTooltip redrawn
    if self:CanUpdateMinimapObjectTooltip() and private.MINIMAP_TOOLTIP_REDRAWN then
      self:RedrawTooltip(C_Map.GetBestMapForUnit("player"))
    end

    if self:CanUpdateMapObjectTooltip() and private.MINIMAP_TOOLTIP_REDRAWN then
      self:RedrawTooltip(WorldMapFrame:GetMapID())
    end

    if self:CanUpdateWorldObjectTooltip() then
      self:ScheduleTimer(function() self:UpdateWorldObjTooltip() end, 0,00000001) -- need to wait before new GameTooltip drawn, becouse it apears not instantly after OnTooltipCleared event
    end
  end)
end

function Tooltip:CanUpdateWorldObjectTooltip()
  return TE.db.profile.tooltip.requiredProfessionLevel.enableWorld and GameTooltip:IsShown() and MouseIsOver(WorldFrame) and GameTooltip:GetOwner():GetName() == "UIParent"
end

function Tooltip:CanUpdateMinimapObjectTooltip()
  return TE.db.profile.tooltip.requiredProfessionLevel.enableMinimap and GameTooltip:IsShown() and MouseIsOver(Minimap) and Minimap:IsVisible()
end

function Tooltip:CanUpdateMapObjectTooltip()
  return TE.db.profile.tooltip.requiredProfessionLevel.enableWorldMap and GameTooltip:IsShown() and MouseIsOver(WorldMapFrame) and WorldMapFrame:IsVisible() 
end

function Tooltip:UpdateWorldObjTooltip()
  -- if no professions found in tooltip then nothing to modify.
  if not self:IsProfessionInTooltip() then return end

  local professionName, tooltipProfessinString, rowNum = self:GetTooltipProfession()
  local tooltipTitleText = MyLib.UnescapeStr(GameTooltipTextLeft1:GetText())
  local minSkillLevel = GatheringInfo:GetProfessionInfoByItemName(tooltipTitleText, professionName, C_Map.GetBestMapForUnit("player"))

  _G["GameTooltipTextLeft"..rowNum]:SetText(self:GetTooltipStr(tooltipProfessinString, minSkillLevel))

  GameTooltip:Show()
end

function Tooltip:RedrawTooltip(zoneMapID)
  if self:HasMatches() then
    private.MINIMAP_TOOLTIP_REDRAWN = false

    local gameTooltipRows = {}
    local newTooltipRows = {}

    for i = 1, GameTooltip:NumLines() do
      table.insert(gameTooltipRows, {
        lineNum = i,
        text = _G["GameTooltipTextLeft"..i]:GetText()
      })
    end

    for _, row in ipairs(gameTooltipRows) do
      local rowWords = {}

      for word in row.text:gmatch("[^\n]+") do
        table.insert(rowWords, word)
      end

      for _, word in ipairs(rowWords) do
        table.insert(newTooltipRows, { type = "title", text = word ,})
      end

      for i, title in ipairs(newTooltipRows) do
        local titleTextUnescaped = MyLib.UnescapeStr(title.text)
        if GatheringInfo:IsProfessionItemName(titleTextUnescaped) then
          local professionName = GatheringInfo:GetProfessionNameByEntryName(titleTextUnescaped)
          local minSkillLevel = GatheringInfo:GetProfessionInfoByItemName(titleTextUnescaped, professionName, zoneMapID)
          table.insert(newTooltipRows, i + 1, { type = "info", text = self:GetTooltipStr(professionName, minSkillLevel)})
        end
      end
    end

    GameTooltip:ClearLines()

    for i, row in ipairs(newTooltipRows) do
      GameTooltip:AddLine(row.text)
      local targetRow = _G["GameTooltipTextLeft"..i]

      if row.type == "title" then
        targetRow:SetFontObject(GameTooltipHeaderText)
        targetRow:SetTextColor(NORMAL_FONT_COLOR:GetRGBA())
      elseif row.type == "info" then
        targetRow:SetFontObject(GameTooltipText)
        local itemName = MyLib.UnescapeStr(_G["GameTooltipTextLeft"..i-1]:GetText())
        targetRow:SetTextColor(GatheringInfo:GetProfessionRequiredSkillColor(itemName))
      end
    end

    GameTooltip:Show()

    private.MINIMAP_TOOLTIP_REDRAWN = true
    private.TOOLTIP_DEFAULTS_CHANGED = true
  end
end

function Tooltip:GetTooltipProfession()

  local professionLookups = GatheringInfo:GetLookupValues()
  for profession, lookups in pairs(professionLookups) do
      for _, lookup in ipairs(lookups) do
        for i = 1, GameTooltip:NumLines() do
          if _G["GameTooltipTextLeft"..i]:GetText() == lookup then return profession, lookup, i end
        end
      end
  end

    return nil
end

function Tooltip:IsProfessionInTooltip()
  if self:GetTooltipProfession() then return true end

  return false
end

function Tooltip:HasMatches()
  for i = 1, GameTooltip:NumLines() do
    local rowText = MyLib.UnescapeStr(_G["GameTooltipTextLeft"..i]:GetText())

    for word in rowText:gmatch("[^\n]+") do
      if GatheringInfo:IsProfessionItemName(word) then return true end
    end
  end

  return false
end

function Tooltip:GetTooltipStr(professionString, levelReq)
  return "["..ADDON_NAME_COLOR..ADDON_NAME_ACRONYM.."|r".."] "..L[professionString].." ["..levelReq.."]"
end

function Tooltip:ResetGameTooltipDefaults(tooltip)
  for i = 1, select("#", tooltip:GetRegions()) do
    local region = select(i, tooltip:GetRegions())
    if region and region:GetObjectType() == "FontString" then
      region:SetFontObject(GameTooltipText)
    end
  end
  GameTooltipTextLeft1:SetFontObject(GameTooltipHeaderText)
end