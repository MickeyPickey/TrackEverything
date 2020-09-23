local _, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local ADDON_VERSION = ADDON_TABLE.ADDON_VERSION
local TE = ADDON_TABLE.Addon
local Log = TE.Init("Util.Log")
local Colors = TE.Include("Data.Colors")

local ADDON_NAME_COLOR = Colors:GetColorByName("DARKORANGE")
local ADDON_VERSION_COLOR = Colors:GetColorByName("TURQUOISE")
ADDON_TABLE.ADDON_NAME_COLOR = ADDON_NAME_COLOR
ADDON_TABLE.ADDON_VERSION_COLOR = ADDON_VERSION_COLOR

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
  self:PrintRaw(ADDON_NAME_COLOR..ADDON_NAME.."|r "..ADDON_VERSION_COLOR..ADDON_VERSION.."|r:", ...)
end

function Log:Printf(...)
  self:Print(format(...))
end