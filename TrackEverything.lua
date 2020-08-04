local FOLDER_NAME, ADDON_TABLE = ...
ADDON_TABLE.AddonName = 'Track Everything'
local ADDON_NAME = ADDON_TABLE.AddonName
ADDON_TABLE.Addon = LibStub('AceAddon-3.0'):NewAddon(ADDON_NAME)
local TE = ADDON_TABLE.Addon

function TE:OnInitialize()

end

function TE.Init(name, ...)
  return TE:NewModule(name, ...)
end

function TE.Include(name)
  if name == 'Locale' then
    return LibStub('AceLocale-3.0'):GetLocale(ADDON_NAME)
  end
  
  return TE:GetModule(name)
end

function TE.GetAddon()
  return TE
end