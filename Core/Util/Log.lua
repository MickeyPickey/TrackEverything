local _, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME
local ADDON_VERSION = ADDON_TABLE.ADDON_VERSION
local TE = ADDON_TABLE.Addon
local Log = TE.Init("Util.Log")
local Colors = TE.Include("Colors")

local ADDON_NAME_COLOR = Colors:GetColorByName("DARKORANGE")
local ADDON_VERSION_COLOR = Colors:GetColorByName("TURQUOISE")
local DEBOG_COLOR = Colors:GetColorByName("RED")
ADDON_TABLE.ADDON_NAME_COLOR = ADDON_NAME_COLOR
ADDON_TABLE.ADDON_VERSION_COLOR = ADDON_VERSION_COLOR

local private = {
  DEBUG_ENABLED = false
}

function Log:OnInitialize()

end

function Log:PrintRaw(...)
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

function Log:PrintD(...)
  if private.DEBUG_ENABLED then
    local str = ADDON_NAME_COLOR..ADDON_NAME.."|r ["..DEBOG_COLOR.."debug".."|r".."]:"
    self:PrintRaw(str, ...)
  end
end

function Log:PrintfD(...)
  self:PrintD(format(...))
end

function Log:DebugToggle()
  private.DEBUG_ENABLED = not private.DEBUG_ENABLED
end

function  Log:GetDubugState()
  return private.DEBUG_ENABLED
end