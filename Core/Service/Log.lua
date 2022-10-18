local _, ADDON_TABLE = ...
local ADDON_VERSION = ADDON_TABLE.ADDON_VERSION
local TE = ADDON_TABLE.Addon
local Log = TE.Include("Log")
local Colors = TE.Include("Colors")

ADDON_TABLE.ADDON_COLOR = Colors:GetColorByName("DARKORANGE")
ADDON_TABLE.COLORED_ADDON_MARK = format("[%s%s|r]", ADDON_TABLE.ADDON_COLOR, ADDON_TABLE.ADDON_NAME_SHORT)
ADDON_TABLE.COLORED_ADDON_NAME = format("%s%s|r", ADDON_TABLE.ADDON_COLOR, ADDON_TABLE.ADDON_NAME)
local COLORED_ADDON_MARK = ADDON_TABLE.COLORED_ADDON_MARK
local COLORED_ADDON_NAME = ADDON_TABLE.COLORED_ADDON_NAME


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
  self:PrintRaw(format("%s:", COLORED_ADDON_NAME), ...)
end

function Log:Printf(...)
  self:Print(format(...))
end

function Log:PrintD(...)
  if private.DEBUG_ENABLED then
    local str = format("%s (%s):", COLORED_ADDON_NAME, Colors:GetColorByName("RED") .. "debug"  .. "|r")
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