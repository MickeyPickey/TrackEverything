local _, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.AddonName
local TE = ADDON_TABLE.Addon
local Log = TE.Include('Util.Log')
local Colors = TE.Include('Data.Colors')

local ADDON_NAME_COLOR = Colors:GetColorByName('DARKORANGE')

function Log:OnInitialize()

end

function Log:PrintRaw(...)
  -- DEFAULT_CHAT_FRAME:AddMessage(str)
  print(...)
end

function Log:PrintfRaw(...)
  self:PrintRaw(format(...))
end

function Log:Print(...)
  self:PrintRaw(ADDON_NAME_COLOR..ADDON_NAME..'|r:', ...)
end

function Log:Printf(...)
  self:Print(format(...))
end