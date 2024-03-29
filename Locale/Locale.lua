--
--                      YOUR ATTENTION PLEASE
--
--         !!!!!!! TRANSLATORS TRANSLATORS TRANSLATORS !!!!!!!
--
--    Thank you very much for your interest in translating Track Everything
--    Do not edit this file. Use the localization interface available at the following address:
--
--      ##########################################################################
--      #  https://www.curseforge.com/wow/addons/track-everything/localization   #
--      ##########################################################################
--
--    Your translations made using this interface will be automatically included in the next release.

--[[
RegExp string to extract locals from GatherMate2:

(L\["Engineering"\].*|L\["Herbalism"\].*|L\["Mining"\].*|L\["Copper Vein"\].*|L\["Tin Vein"\].*|L\["Incendicite Mineral Vein"\].*|L\["Silver Vein"\].*|L\["Ooze Covered Silver Vein"\].*|L\["Lesser Bloodstone Deposit"\].*|L\["Iron Deposit"\].*|L\["Ooze Covered Iron Deposit"\].*|L\["Indurium Mineral Vein"\].*|L\["Gold Vein"\].*|L\["Ooze Covered Gold Vein"\].*|L\["Mithril Deposit"\].*|L\["Ooze Covered Mithril Deposit"\].*|L\["Truesilver Deposit"\].*|L\["Ooze Covered Truesilver Deposit"\].*|L\["Dark Iron Deposit"\].*|L\["Small Thorium Vein"\].*|L\["Ooze Covered Thorium Vein"\].*|L\["Rich Thorium Vein"\].*|L\["Ooze Covered Rich Thorium Vein"\].*|L\["Hakkari Thorium Vein"\].*|L\["Small Obsidian Chunk"\].*|L\["Large Obsidian Chunk"\].*|L\["Fel Iron Deposit"\].*|L\["Khorium Vein"\].*|L\["Adamantite Deposit"\].*|L\["Rich Adamantite Deposit"\].*|L\["Cobalt Deposit"\].*|L\["Rich Cobalt Deposit"\].*|L\["Saronite Deposit"\].*|L\["Rich Saronite Deposit"\].*|L\["Firethorn"\].*|L\["Frozen Herb"\].*)
--]]

local _, ADDON_TABLE = ...
local ADDON_NAME = ADDON_TABLE.ADDON_NAME

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true, true)

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = true
    L["Herbalism"] = true
    L["Mining"] = true
    L["Adamantite Deposit"] = true
    L["Cobalt Deposit"] = true
    L["Copper Vein"] = true
    L["Dark Iron Deposit"] = true
    L["Fel Iron Deposit"] = true
    L["Firethorn"] = true
    L["Frozen Herb"] = true
    L["Gold Vein"] = true
    L["Incendicite Mineral Vein"] = true
    L["Indurium Mineral Vein"] = true
    L["Iron Deposit"] = true
    L["Khorium Vein"] = true
    L["Large Obsidian Chunk"] = true
    L["Lesser Bloodstone Deposit"] = true
    L["Mithril Deposit"] = true
    L["Ooze Covered Gold Vein"] = true
    L["Ooze Covered Mithril Deposit"] = true
    L["Ooze Covered Rich Thorium Vein"] = true
    L["Ooze Covered Silver Vein"] = true
    L["Ooze Covered Thorium Vein"] = true
    L["Ooze Covered Truesilver Deposit"] = true
    L["Rich Adamantite Deposit"] = true
    L["Rich Cobalt Deposit"] = true
    L["Rich Saronite Deposit"] = true
    L["Rich Thorium Vein"] = true
    L["Saronite Deposit"] = true
    L["Silver Vein"] = true
    L["Small Obsidian Chunk"] = true
    L["Small Thorium Vein"] = true
    L["Tin Vein"] = true
    L["Truesilver Deposit"] = true
    L["Hakkari Thorium Vein"] = true
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    L[" Spell switching: %s, Type %s to see all chat commands. Have a nice day! :)"] = true
    L["%sDrag%s to move icon"] = true
    L["%sLeft-click%s to manualy select tracking spell"] = true
    L["%sRight-click%s to cancel current tracking spell"] = true
    L["%sShift+Left-click%s to enable/disable auto switching"] = true
    L["%sShift+Right-click%s to open settings"] = true
    L["Activate last used tracking spell on resurrection"] = true
    L["Arguments to %s :"] = true
    L["Auto spell switching"] = true
    L["Auto tracking"] = true
    L["Cast interval"] = true
    L["Check if you want to hide default minimap tracking icon"] = true
    L["Check to hide addon minimap icon"] = true
    L["Check to show required profession level on minimap tooltips"] = true
    L["Check to show required profession level on world map tooltips. Requires GatherMate2 addon."] = true
    L["Check to show required profession level on world object tooltips"] = true
    L["Current tracking spell"] = true
    L["Disable auto spell switching"] = true
    L["Enable auto spell switching"] = true
    L["Enable to activate last used tracking spell on resurrection"] = true
    L["Enable to switch only while character is moving"] = true
    L["Enable/disable auto spell switching"] = true
    L["Enable/disable last used tracking spell activation on resurrection"] = true
    L["Enable/disable required profession level on Minimap tooltips"] = true
    L["Enable/disable required profession level on World Map tooltips"] = true
    L["Enable/disable required profession level on World tooltips"] = true
    L["Enable/disable spell switching only while moving mode"] = true
    L["Force in combat"] = true
    L["Hide addon icon"] = true
    L["Hide default tracking icon"] = true
    L["Icon display mode"] = true
    L["Last used tracking spell activation is [%s]"] = true
    L["Minimap tooltips"] = true
    L["Mute spell switch sound"] = true
    L["Mute spell switch sound is [%s]"] = true
    L["Mute spell switch sound while auto tracking"] = true
    L["Next tracking spell"] = true
    L["Only while moving"] = true
    L["Open settings"] = true
    L["Print information about Author"] = true
    L["Required profession level on Minimap tooltips is [%s]"] = true
    L["Required profession level on World Map tooltips sis [%s]"] = true
    L["Required profession level on World tooltips is [%s]"] = true
    L["Resources"] = true
    L["Select to include in auto switching"] = true
    L["Select what to display inside icon"] = true
    L["Settings have been reset to default"] = true
    L["Show required profession level"] = true
    L["Spell switching is [%s]"] = true
    L["Spell switching only while moving is [%s]"] = true
    L["Switch spells even if player in combat"] = true
    L["Time in seconds between spell casts while auto switching"] = true
    L["Toggle auto spell switching"] = true
    L["Tooltip"] = true
    L["Tracking spells"] = true
    L["Units"] = true
    L["World Map tooltips"] = true
    L["World tooltips"] = true
    L["Current tracking"] = true
    L["Only on mount"] = true
    L["Enable to switch only if character on mount. Also works with druid's flying form"] = true
    L['Remove "%s" mark'] = true
    L['Check to remove "%s" mark in tooltips'] = true
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "frFR");
  
  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Ingénierie"
    L["Herbalism"] = "Herboristerie"
    L["Mining"] = "Minage"
    L["Adamantite Deposit"] = "Gisement d'adamantite"
    L["Cobalt Deposit"] = "Gisement de cobalt"
    L["Copper Vein"] = "Filon de cuivre"
    L["Dark Iron Deposit"] = "Gisement de sombrefer"
    L["Fel Iron Deposit"] = "Gisement de gangrefer"
    L["Firethorn"] = "Epine de feu"
    L["Frozen Herb"] = "Herbe gelée"
    L["Gold Vein"] = "Filon d'or"
    L["Incendicite Mineral Vein"] = "Filon d'incendicite"
    L["Indurium Mineral Vein"] = "Filon d'indurium"
    L["Iron Deposit"] = "Gisement de fer"
    L["Khorium Vein"] = "Filon de khorium"
    L["Large Obsidian Chunk"] = "Grand morceau d'obsidienne"
    L["Lesser Bloodstone Deposit"] = "Gisement de pierre de sang inférieure"
    L["Mithril Deposit"] = "Gisement de mithril"
    L["Ooze Covered Gold Vein"] = "Filon d'or couvert de limon"
    L["Ooze Covered Mithril Deposit"] = "Gisement de mithril couvert de vase"
    L["Ooze Covered Rich Thorium Vein"] = "Riche filon de thorium couvert de limon"
    L["Ooze Covered Silver Vein"] = "Filon d'argent couvert de limon"
    L["Ooze Covered Thorium Vein"] = "Filon de thorium couvert de limon"
    L["Ooze Covered Truesilver Deposit"] = "Gisement de vrai-argent couvert de vase"
    L["Rich Adamantite Deposit"] = "Riche gisement d'adamantite"
    L["Rich Cobalt Deposit"] = "Riche gisement de cobalt"
    L["Rich Saronite Deposit"] = "Riche gisement de saronite"
    L["Rich Thorium Vein"] = "Riche filon de thorium"
    L["Saronite Deposit"] = "Gisement de saronite"
    L["Silver Vein"] = "Filon d'argent"
    L["Small Obsidian Chunk"] = "Petit morceau d'obsidienne"
    L["Small Thorium Vein"] = "Petit filon de thorium"
    L["Tin Vein"] = "Filon d'étain"
    L["Truesilver Deposit"] = "Gisement de vrai-argent"
    L["Hakkari Thorium Vein"] = "Filon de thorium Hakkari"
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="frFR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "deDE");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Ingenieurskunst"
    L["Herbalism"] = "Kräuterkunde"
    L["Mining"] = "Bergbau"
    L["Adamantite Deposit"] = "Adamantitablagerung"
    L["Cobalt Deposit"] = "Kobaltablagerung"
    L["Copper Vein"] = "Kupfervorkommen"
    L["Dark Iron Deposit"] = "Dunkeleisenablagerung"
    L["Fel Iron Deposit"] = "Teufelseisenvorkommen"
    L["Firethorn"] = "Feuerdorn"
    L["Frozen Herb"] = "Gefrorenes Kraut"
    L["Gold Vein"] = "Goldvorkommen"
    L["Incendicite Mineral Vein"] = "Pyrophormineralvorkommen"
    L["Indurium Mineral Vein"] = "Induriummineralvorkommen"
    L["Iron Deposit"] = "Eisenvorkommen"
    L["Khorium Vein"] = "Khoriumvorkommen"
    L["Large Obsidian Chunk"] = "Großer Obsidiumvorkommen"
    L["Lesser Bloodstone Deposit"] = "Geringe Blutsteinablagerung"
    L["Mithril Deposit"] = "Mithrilablagerung"
    L["Ooze Covered Gold Vein"] = "Schlammbedecktes Goldvorkommen"
    L["Ooze Covered Mithril Deposit"] = "Schlammbedeckte Mithrilablagerung"
    L["Ooze Covered Rich Thorium Vein"] = "Schlammbedecktes reiches Thoriumvorkommen"
    L["Ooze Covered Silver Vein"] = "Schlammbedecktes Silbervorkommen"
    L["Ooze Covered Thorium Vein"] = "Schlammbedeckte Thoriumader"
    L["Ooze Covered Truesilver Deposit"] = "Schlammbedecktes Echtsilbervorkommen"
    L["Rich Adamantite Deposit"] = "Reiche Adamantitablagerung"
    L["Rich Cobalt Deposit"] = "Reiche Kobaltablagerung"
    L["Rich Saronite Deposit"] = "Reiche Saronitablagerung"
    L["Rich Thorium Vein"] = "Reiches Thoriumvorkommen"
    L["Saronite Deposit"] = "Saronitablagerung"
    L["Silver Vein"] = "Silbervorkommen"
    L["Small Obsidian Chunk"] = "Kleiner Obsidiumvorkommen"
    L["Small Thorium Vein"] = "Kleines Thoriumvorkommen"
    L["Tin Vein"] = "Zinnvorkommen"
    L["Truesilver Deposit"] = "Echtsilberablagerung"
    L["Hakkari Thorium Vein"] = "Hakkari Thoriumvorkommen"

    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="deDE", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "esES");
  
  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Ingeniería"
    L["Herbalism"] = "Botánica"
    L["Mining"] = "Minería"
    L["Adamantite Deposit"] = "Depósito de adamantita"
    L["Cobalt Deposit"] = "Depósito de cobalto"
    L["Copper Vein"] = "Filón de cobre"
    L["Dark Iron Deposit"] = "Depósito de Hierro negro"
    L["Fel Iron Deposit"] = "Depósito de hierro vil"
    L["Firethorn"] = "Espino de fuego"
    L["Frozen Herb"] = "Hierba congelada"
    L["Gold Vein"] = "Filón de oro"
    L["Incendicite Mineral Vein"] = "Filón de mineral de incendicita"
    L["Indurium Mineral Vein"] = "Filón de mineral de indurio"
    L["Iron Deposit"] = "Depósito de hierro"
    L["Khorium Vein"] = "Filón de korio"
    L["Large Obsidian Chunk"] = "Trozo de obsidiana grande"
    L["Lesser Bloodstone Deposit"] = "Depósito de sangrita inferior"
    L["Mithril Deposit"] = "Depósito de mitril"
    L["Ooze Covered Gold Vein"] = "Filón de oro cubierto de moco"
    L["Ooze Covered Mithril Deposit"] = "Filón de mitril cubierto de moco"
    L["Ooze Covered Rich Thorium Vein"] = "Filón de torio enriquecido cubierto de moco"
    L["Ooze Covered Silver Vein"] = "Filón de plata cubierto de moco"
    L["Ooze Covered Thorium Vein"] = "Filón de torio cubierto de moco"
    L["Ooze Covered Truesilver Deposit"] = "Filón de veraplata cubierta de moco"
    L["Rich Adamantite Deposit"] = "Depósito rico en adamantita"
    L["Rich Cobalt Deposit"] = "Depósito de cobalto rico"
    L["Rich Saronite Deposit"] = "Depósito de saronita rico"
    L["Rich Thorium Vein"] = "Filón de torio enriquecido"
    L["Saronite Deposit"] = "Depósito de saronita"
    L["Silver Vein"] = "Filón de plata"
    L["Small Obsidian Chunk"] = "Pequeño fragmento de obsidiana"
    L["Small Thorium Vein"] = "Filón pequeño de torio"
    L["Tin Vein"] = "Filón de estaño"
    L["Truesilver Deposit"] = "Depósito de veraplata"
    L["Hakkari Thorium Vein"] = "Filón de torio de Hakkari"

    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="esES", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "esMX");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Ingeniería"
    L["Herbalism"] = "Herboristería"
    L["Mining"] = "Minería"
    L["Adamantite Deposit"] = "Depósito de adamantita"
    L["Cobalt Deposit"] = "Depósito de cobalto"
    L["Copper Vein"] = "Filón de cobre"
    L["Dark Iron Deposit"] = "Depósito de Hierro negro"
    L["Fel Iron Deposit"] = "Depósito de hierro vil"
    L["Firethorn"] = "Espino de fuego"
    L["Frozen Herb"] = "Hierba congelada"
    L["Gold Vein"] = "Filón de oro"
    L["Incendicite Mineral Vein"] = "Filón de mineral de incendicita"
    L["Indurium Mineral Vein"] = "Filón de mineral de indurio"
    L["Iron Deposit"] = "Depósito de hierro"
    L["Khorium Vein"] = "Filón de korio"
    L["Large Obsidian Chunk"] = "Gran Trozo obsidiana"
    L["Lesser Bloodstone Deposit"] = "Depósito de sangrita inferior"
    L["Mithril Deposit"] = "Depósito de mitril"
    L["Ooze Covered Gold Vein"] = "Filón de oro cubierto de moco"
    L["Ooze Covered Mithril Deposit"] = "Filón de mitril cubierto de moco"
    L["Ooze Covered Rich Thorium Vein"] = "Filón de torio enriquecido cubierto de moco"
    L["Ooze Covered Silver Vein"] = "Filón de plata cubierto de moco"
    L["Ooze Covered Thorium Vein"] = "Filón de torio cubierto de moco"
    L["Ooze Covered Truesilver Deposit"] = "Filón de veraplata cubierta de moco"
    L["Rich Adamantite Deposit"] = "Depósito rico en adamantita"
    L["Rich Cobalt Deposit"] = "Depósito de cobalto rico"
    L["Rich Saronite Deposit"] = "Depósito de saronita rico"
    L["Rich Thorium Vein"] = "Filón de torio enriquecido"
    L["Saronite Deposit"] = "Depósito de saronita"
    L["Silver Vein"] = "Filón de plata"
    L["Small Obsidian Chunk"] = "Pequeño fragmento de obsidiana"
    L["Small Thorium Vein"] = "Filón pequeño de torio"
    L["Tin Vein"] = "Filón de estaño"
    L["Truesilver Deposit"] = "Depósito de veraplata"
    L["Hakkari Thorium Vein"] = "Filón de torio de Hakkari"

    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="esMX", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "ptBR");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Engenharia"
    L["Herbalism"] = "Herborismo"
    L["Mining"] = "Mineração."
    L["Adamantite Deposit"] = "Depósito de Adamantita"
    L["Cobalt Deposit"] = "Depósito de Cobalto"
    L["Copper Vein"] = "Veio de Cobre"
    L["Dark Iron Deposit"] = "Depósito de Ferro Negro"
    L["Fel Iron Deposit"] = "Depósito de Ferrovil"
    L["Firethorn"] = "Espinho de Fogo"
    L["Frozen Herb"] = "Planta Congelada"
    L["Gold Vein"] = "Veio de Ouro"
    L["Incendicite Mineral Vein"] = "Veio de Incendicita"
    L["Indurium Mineral Vein"] = "Mineral Indurio"
    L["Iron Deposit"] = "Depósito de Ferro"
    L["Khorium Vein"] = "Veio de Kório"
    L["Large Obsidian Chunk"] = "Grande Estilhaço de Obisidiana"
    L["Lesser Bloodstone Deposit"] = "Depósito de Menor Plasma"
    L["Mithril Deposit"] = "Depósito de Mithril"
    L["Ooze Covered Gold Vein"] = "Veio de Ouro Coberto de Gosma"
    L["Ooze Covered Mithril Deposit"] = "Depósito de Mithril Coberto de Gosma"
    L["Ooze Covered Rich Thorium Vein"] = "Veio de Tório Abundante Coberto de Gosma"
    L["Ooze Covered Silver Vein"] = "Veio de Prata Coberto de Gosma"
    L["Ooze Covered Thorium Vein"] = "Veio de Tório Coberto de Gosma"
    L["Ooze Covered Truesilver Deposit"] = "Depósito de Veraprata Coberto de Gosma"
    L["Rich Adamantite Deposit"] = "Depósito de Adamantita Abundante"
    L["Rich Cobalt Deposit"] = "Depósito de Cobalto Abundante "
    L["Rich Saronite Deposit"] = "Depósito de Saronita Abundante"
    L["Rich Thorium Vein"] = "Veio de Tório Abundante"
    L["Saronite Deposit"] = "Depósito de Saronita"
    L["Silver Vein"] = "Veio de Prata"
    L["Small Obsidian Chunk"] = "Pequeno Estilhaço de Obisidiana"
    L["Small Thorium Vein"] = "Veio de Tório Pequeno"
    L["Tin Vein"] = "Veio de Estanho"
    L["Truesilver Deposit"] = "Depósito de Veraprata"
    L["Hakkari Thorium Vein"] = "Veio de Tório Hakkari"
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="ptBR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end


do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "koKR");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "기계공학"
    L["Herbalism"] = "약초 채집"
    L["Mining"] = "채광"
    L["Adamantite Deposit"] = "아다만타이트 광맥"
    L["Cobalt Deposit"] = "코발트 광맥"
    L["Copper Vein"] = "구리 광맥"
    L["Dark Iron Deposit"] = "검은무쇠 광맥"
    L["Fel Iron Deposit"] = "지옥무쇠 광맥"
    L["Firethorn"] = "화염가시풀"
    L["Frozen Herb"] = "얼어붙은 약초"
    L["Gold Vein"] = "금 광맥"
    L["Incendicite Mineral Vein"] = "발연 광석 광맥"
    L["Indurium Mineral Vein"] = "인듀리움 광맥"
    L["Iron Deposit"] = "철 광맥"
    L["Khorium Vein"] = "코륨 광맥"
    L["Large Obsidian Chunk"] = "풍부한 흑요암 광맥"
    L["Lesser Bloodstone Deposit"] = "저급 혈석 광맥"
    L["Mithril Deposit"] = "미스릴 광맥"
    L["Ooze Covered Gold Vein"] = "진흙으로 덮인 금 광맥"
    L["Ooze Covered Mithril Deposit"] = "진흙으로 덮인 미스릴 광맥"
    L["Ooze Covered Rich Thorium Vein"] = "진흙으로 덮인 풍부한 토륨 광맥"
    L["Ooze Covered Silver Vein"] = "진흙으로 덮인 은 광맥"
    L["Ooze Covered Thorium Vein"] = "진흙으로 덮인 토륨 광맥"
    L["Ooze Covered Truesilver Deposit"] = "진흙으로 덮인 진은 광맥"
    L["Rich Adamantite Deposit"] = "풍부한 아다만타이트 광맥"
    L["Rich Cobalt Deposit"] = "풍부한 코발트 광맥"
    L["Rich Saronite Deposit"] = "풍부한 사로나이트 광맥"
    L["Rich Thorium Vein"] = "풍부한 토륨 광맥"
    L["Saronite Deposit"] = "사로나이트 광맥"
    L["Silver Vein"] = "은 광맥"
    L["Small Obsidian Chunk"] = "작은 흑요암 광맥"
    L["Small Thorium Vein"] = "작은 토륨 광맥"
    L["Tin Vein"] = "주석 광맥"
    L["Truesilver Deposit"] = "진은 광맥"
    L["Hakkari Thorium Vein"] = "학카리 토륨 광맥"
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="koKR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhCN");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "工程学"
    L["Herbalism"] = "草药学"
    L["Mining"] = "采矿"
    L["Adamantite Deposit"] = "精金矿脉"
    L["Cobalt Deposit"] = "钴矿脉"
    L["Copper Vein"] = "铜矿"
    L["Dark Iron Deposit"] = "黑铁矿脉"
    L["Fel Iron Deposit"] = "魔铁矿脉"
    L["Firethorn"] = "火棘"
    L["Frozen Herb"] = "冰冷的草药"
    L["Gold Vein"] = "金矿石"
    L["Incendicite Mineral Vein"] = "火岩矿脉"
    L["Indurium Mineral Vein"] = "精铁矿脉"
    L["Iron Deposit"] = "铁矿石"
    L["Khorium Vein"] = "氪金矿脉"
    L["Large Obsidian Chunk"] = "大型黑曜石碎块"
    L["Lesser Bloodstone Deposit"] = "次级血石矿脉"
    L["Mithril Deposit"] = "秘银矿脉"
    L["Ooze Covered Gold Vein"] = "软泥覆盖的金矿脉"
    L["Ooze Covered Mithril Deposit"] = "软泥覆盖的秘银矿脉"
    L["Ooze Covered Rich Thorium Vein"] = "软泥覆盖的富瑟银矿脉"
    L["Ooze Covered Silver Vein"] = "软泥覆盖的银矿脉"
    L["Ooze Covered Thorium Vein"] = "软泥覆盖的瑟银矿脉"
    L["Ooze Covered Truesilver Deposit"] = "软泥覆盖的真银矿脉"
    L["Rich Adamantite Deposit"] = "富精金矿脉"
    L["Rich Cobalt Deposit"] = "富钴矿脉"
    L["Rich Saronite Deposit"] = "富萨隆邪铁矿脉"
    L["Rich Thorium Vein"] = "富瑟银矿"
    L["Saronite Deposit"] = "萨隆邪铁矿脉"
    L["Silver Vein"] = "银矿"
    L["Small Obsidian Chunk"] = "小型黑曜石碎块"
    L["Small Thorium Vein"] = "瑟银矿脉"
    L["Tin Vein"] = "锡矿"
    L["Truesilver Deposit"] = "真银矿石"
    L["Hakkari Thorium Vein"] = "哈卡莱瑟银矿脉"
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="zhCN", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhTW");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "工程學"
    L["Herbalism"] = "草藥學"
    L["Mining"] = "採礦"
    L["Adamantite Deposit"] = "堅鋼礦床"
    L["Cobalt Deposit"] = "鈷藍礦床"
    L["Copper Vein"] = "銅礦脈"
    L["Dark Iron Deposit"] = "黑鐵礦床"
    L["Fel Iron Deposit"] = "魔鐵礦床"
    L["Firethorn"] = "火棘"
    L["Frozen Herb"] = "冰凍草藥"
    L["Gold Vein"] = "金礦脈"
    L["Incendicite Mineral Vein"] = "火岩礦脈"
    L["Indurium Mineral Vein"] = "精鐵礦脈"
    L["Iron Deposit"] = "鐵礦床"
    L["Khorium Vein"] = "克銀礦脈"
    L["Large Obsidian Chunk"] = "大黑曜石塊"
    L["Lesser Bloodstone Deposit"] = "次級血石礦床"
    L["Mithril Deposit"] = "秘銀礦床"
    L["Ooze Covered Gold Vein"] = "軟泥覆蓋的金礦脈"
    L["Ooze Covered Mithril Deposit"] = "軟泥覆蓋的秘銀礦床"
    L["Ooze Covered Rich Thorium Vein"] = "軟泥覆蓋的富瑟銀礦脈"
    L["Ooze Covered Silver Vein"] = "軟泥覆蓋的銀礦脈"
    L["Ooze Covered Thorium Vein"] = "軟泥覆蓋的瑟銀礦脈"
    L["Ooze Covered Truesilver Deposit"] = "軟泥覆蓋的真銀礦床"
    L["Rich Adamantite Deposit"] = "豐沃的堅鋼礦床"
    L["Rich Cobalt Deposit"] = "豐沃的鈷藍礦床"
    L["Rich Saronite Deposit"] = "豐沃的薩鋼礦床"
    L["Rich Thorium Vein"] = "富瑟銀礦脈"
    L["Saronite Deposit"] = "薩鋼礦床"
    L["Silver Vein"] = "銀礦脈"
    L["Small Obsidian Chunk"] = "小黑曜石塊"
    L["Small Thorium Vein"] = "瑟銀礦脈"
    L["Tin Vein"] = "錫礦脈"
    L["Truesilver Deposit"] = "真銀礦床"
    L["Hakkari Thorium Vein"] = "哈卡萊瑟銀礦脈"
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="zhTW", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "ruRU");

  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Инженерное дело"
    L["Herbalism"] = "Травничество"
    L["Mining"] = "Горное дело"
    L["Adamantite Deposit"] = "Залежи адамантита"
    L["Cobalt Deposit"] = "Залежи кобальта"
    L["Copper Vein"] = "Медная жила"
    L["Dark Iron Deposit"] = "Залежи черного железа"
    L["Fel Iron Deposit"] = "Залежи оскверненного железа"
    L["Firethorn"] = "Огница"
    L["Frozen Herb"] = "Мерзлая трава"
    L["Gold Vein"] = "Золотая жила"
    L["Incendicite Mineral Vein"] = "Ароматитовая жила"
    L["Indurium Mineral Vein"] = "Индарилиевая жила"
    L["Iron Deposit"] = "Залежи железа"
    L["Khorium Vein"] = "Кориевая жила"
    L["Large Obsidian Chunk"] = "Большая обсидиановая глыба"
    L["Lesser Bloodstone Deposit"] = "Малое месторождение кровавого камня"
    L["Mithril Deposit"] = "Мифриловые залежи"
    L["Ooze Covered Gold Vein"] = "Покрытая слизью золотая жила"
    L["Ooze Covered Mithril Deposit"] = "Покрытые слизью мифриловые залежи"
    L["Ooze Covered Rich Thorium Vein"] = "Покрытая слизью богатая ториевая жила"
    L["Ooze Covered Silver Vein"] = "Покрытая слизью серебрянная жила"
    L["Ooze Covered Thorium Vein"] = "Покрытая слизью ториевая жила"
    L["Ooze Covered Truesilver Deposit"] = "Покрытые слизью залежи истинного серебра"
    L["Rich Adamantite Deposit"] = "Богатые залежи адамантита"
    L["Rich Cobalt Deposit"] = "Богатые залежи кобальта"
    L["Rich Saronite Deposit"] = "Богатое месторождение саронита"
    L["Rich Thorium Vein"] = "Богатая ториевая жила"
    L["Saronite Deposit"] = "Месторождение саронита"
    L["Silver Vein"] = "Серебряная жила"
    L["Small Obsidian Chunk"] = "Маленький кусочек обсидиана"
    L["Small Thorium Vein"] = "Малая ториевая жила"
    L["Tin Vein"] = "Оловянная жила"
    L["Truesilver Deposit"] = "Залежи истинного серебра"
    L["Hakkari Thorium Vein"] = "Ториевая жила племени Хаккари"
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="ruRU", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end

do
  local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "itIT");


  if L then
    -- ============================================================================================================================================
    -- ===== CURRENTLY WE ARE UNABLE TO GET INGAME LOCALIZATION FOR PROFESSION NAMES AND MINING NODES SO WE NEED TO KEEP OUR OWN FOR EACH OWN. ====
    -- ============================================================================================================================================
    L["Engineering"] = "Ingegneria"
    L["Herbalism"] = "Erbalismo"
    L["Mining"] = "Estrazione"
    L["Adamantite Deposit"] = "Deposito di Adamantite"
    L["Cobalt Deposit"] = "Deposito di Cobalto"
    L["Copper Vein"] = "Vena di Rame"
    L["Dark Iron Deposit"] = "Deposito di Ferroscuro"
    L["Fel Iron Deposit"] = "Deposito di Vilferro"
    L["Firethorn"] = "Ardispina"
    L["Frozen Herb"] = "Erba del Gelo"
    L["Gold Vein"] = "Vena d'Oro"
    L["Incendicite Mineral Vein"] = "Vena di Incendicite"
    L["Iron Deposit"] = "Deposito di Ferro"
    L["Khorium Vein"] = "Vena di Korio"
    L["Large Obsidian Chunk"] = "Frammento Grande d'Ossidiana"
    L["Mithril Deposit"] = "Deposito di Mithril"
    L["Ooze Covered Thorium Vein"] = "Vena di Torio Coperta di Melma"
    L["Ooze Covered Truesilver Deposit"] = "Deposito di Verargento Coperto di Melma"
    L["Rich Adamantite Deposit"] = "Deposito Ricco di Adamantite"
    L["Rich Cobalt Deposit"] = "Deposito Ricco di Cobalto"
    L["Rich Saronite Deposit"] = "Deposito Ricco di Saronite"
    L["Rich Thorium Vein"] = "Vena Ricca di Torio"
    L["Saronite Deposit"] = "Deposito di Saronite"
    L["Silver Vein"] = "Vena d'Argento"
    L["Small Obsidian Chunk"] = "Frammento Piccolo d'Ossidiana"
    L["Small Thorium Vein"] = "Vena Piccola di Torio"
    L["Tin Vein"] = "Vena di Stagno"
    L["Truesilver Deposit"] = "Deposito di Verargento"
    L["Hakkari Thorium Vein"] = true
    -- ============================================================================================================================================
    -- ========================================================== Base Namespaces =================================================================
    -- ============================================================================================================================================
    --@localization(locale="itIT", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat")@
  end
end
