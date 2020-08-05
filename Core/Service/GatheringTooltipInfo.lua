local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local GatheringData = TE.Include('Data.Gathering')
local Colors = TE.Include('Data.Colors')
local GatheringTooltipInfo = TE.Include('Service.GatheringTooltipInfo')
local Log = TE.Include('Util.Log')
local MyLib = TE.Include('Util.MyLib')
local L = TE.Include('Locale')

local ADDON_NAME_COLOR = ADDON_TABLE.ADDON_NAME_COLOR
local ADDON_NAME_ACRONYM = ADDON_TABLE.ADDON_NAME_ACRONYM


local private = {
  IS_SHOWN = false
}

function GatheringTooltipInfo:OnInitialize()
  GameTooltip:HookScript('OnShow', function() GatheringTooltipInfo:SendMessage('GAMETOOLTIP_SHOW') end)
  GameTooltip:HookScript('OnHide', function() GatheringTooltipInfo:SendMessage('GAMETOOLTIP_HIDE') end)

  self:RegisterMessage('GAMETOOLTIP_SHOW', 'EventHandler')
  self:RegisterMessage('GAMETOOLTIP_HIDE', 'EventHandler')
end

function GatheringTooltipInfo:ShowTooltip()

end

function GatheringTooltipInfo:EventHandler(...)
  local event = ...

  if event == 'GAMETOOLTIP_SHOW' then
    self:RegisterEvent('CURSOR_UPDATE', 'EventHandler')
    self:RegisterEvent('UPDATE_MOUSEOVER_UNIT', 'EventHandler') 
    self:ModifyTooltip()
    private.IS_SHOWN = true
  elseif event == 'GAMETOOLTIP_HIDE' then
    self:UnregisterEvent('CURSOR_UPDATE')
    self:UnregisterEvent('UPDATE_MOUSEOVER_UNIT')
    private.IS_SHOWN = false
  elseif event == 'CURSOR_UPDATE' then
    if private.IS_SHOWN then self:ScheduleTimer(function() GatheringTooltipInfo:ModifyTooltip() end, 0,0001) end -- need timer on CURSOR_UPDATE becouse GameTooltip apears after this event
  elseif event  == 'UPDATE_MOUSEOVER_UNIT' then
    if private.IS_SHOWN then GatheringTooltipInfo:ModifyTooltip() end
  end
end

function GatheringTooltipInfo:ShowTooltip()

end

function GatheringTooltipInfo:GetProfessionInfo()

  local _, profLine = self:IsProfessionInTooltip()
  local name = _G['GameTooltipTextLeft'..profLine]:GetText()
  local levelReq = '?'

  if name == L['Skinnable'] then
    local unitLevel = UnitLevel('mouseover')
    levelReq = self:CalculateSkinningLevel(unitLevel)
  elseif MyLib.IndexOf(GatheringData:GetDataByKey(L['Herbalism']).LOOKUP, name) then
    local items = GatheringData:GetItemsByKey(L['Herbalism'])
    local itemName = GameTooltipTextLeft1:GetText()
    
    for i, item in ipairs(items) do
      local name = GetItemInfo(item.itemId)
      if name == itemName then levelReq = item.levelReq end
    end
  else
    local dataKey = GatheringData:GetDataKeyByLookupValue(name)
    local items = GatheringData:GetItemsByKey(dataKey)

    local itemName = GameTooltipTextLeft1:GetText()

    for i, item in ipairs(items) do
      if item.name == itemName then levelReq = item.levelReq end
    end
  end

  return name, profLine, levelReq
end

function GatheringTooltipInfo:ModifyTooltip()
  if not self:IsProfessionInTooltip() then return end

  local name, profLine, levelReq = self:GetProfessionInfo()
  _G['GameTooltipTextLeft'..profLine]:SetText('['..ADDON_NAME_COLOR..ADDON_NAME_ACRONYM..'|r'..'] '..name..' ['..levelReq..']')
  GameTooltip:Show()
end

function GatheringTooltipInfo:GetTooltipStrLineNum(str)
  for i = 1, GameTooltip:NumLines() do
    if _G['GameTooltipTextLeft'..i]:GetText() == str then return i end
  end
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

function GatheringTooltipInfo:IsProfessionInTooltip()
  local professionsTable = GatheringData:GetLookupValues()
  for i, key in ipairs(professionsTable) do
    local line = self:GetTooltipStrLineNum(key)
    if line then return true, line end
  end

  return false
end