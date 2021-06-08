local FOLDER_NAME, ADDON_TABLE = ...
local ADDON_NAME = "Track Everything"
ADDON_TABLE.ADDON_NAME = ADDON_NAME
ADDON_TABLE.Addon = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME)
ADDON_TABLE.ADDON_VERSION = GetAddOnMetadata(FOLDER_NAME, "Version")
ADDON_TABLE.ADDON_AUTHOR = GetAddOnMetadata(FOLDER_NAME, "Author")
ADDON_TABLE.ADDON_AUTHOR_GAME_INFO = GetAddOnMetadata(FOLDER_NAME, "X-Author-Game-Info")
local TE = ADDON_TABLE.Addon

function TE:OnInitialize()

end

function TE.Init(name, ...)
  return TE:NewModule(name, ...)
end

function TE.Include(name)
  if name == "Locale" then
    return LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
  end

  return TE:GetModule(name)
end

function TE.GetAddon()
  return TE
end