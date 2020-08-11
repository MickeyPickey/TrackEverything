local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon
local Colors = TE.Init("Data.Colors")

function Colors:GetColorByName(name)
    local COLORS = self:GetAllColors()

    if COLORS[name] then
        return COLORS[name]
    else
        return COLORS["WHITE"]
    end
end

function Colors:GetAllColors()
    local COLORS = {
        ALICEBLUE = "|CFFF0F8FF",
        ANTIQUEWHITE = "|CFFFAEBD7",
        AQUA = "|CFF00FFFF",
        AQUAMARINE = "|CFF7FFFD4",
        AZURE = "|CFFF0FFFF",
        BEIGE = "|CFFF5F5DC",
        BISQUE = "|CFFFFE4C4",
        BLACK = "|CFF000000",
        BLANCHEDALMOND = "|CFFFFEBCD",
        BLUE = "|CFF0000FF",
        BLUEVIOLET = "|CFF8A2BE2",
        BROWN = "|CFFA52A2A",
        BURLYWOOD = "|CFFDEB887",
        CADETBLUE = "|CFF5F9EA0",
        CHARTREUSE = "|CFF7FFF00",
        CHOCOLATE = "|CFFD2691E",
        CORAL = "|CFFFF7F50",
        CORNFLOWERBLUE = "|CFF6495ED",
        CORNSILK = "|CFFFFF8DC",
        CRIMSON = "|CFFDC143C",
        CYAN = "|CFF00FFFF",
        DARKBLUE = "|CFF00008B",
        DARKCYAN = "|CFF008B8B",
        DARKGOLDENROD = "|CFFB8860B",
        DARKGRAY = "|CFFA9A9A9",
        DARKGREEN = "|CFF006400",
        DARKKHAKI = "|CFFBDB76B",
        DARKMAGENTA = "|CFF8B008B",
        DARKOLIVEGREEN = "|CFF556B2F",
        DARKORANGE = "|CFFFF8C00",
        DARKORCHID = "|CFF9932CC",
        DARKRED = "|CFF8B0000",
        DARKSALMON = "|CFFE9967A",
        DARKSEAGREEN = "|CFF8FBC8B",
        DARKSLATEBLUE = "|CFF483D8B",
        DARKSLATEGRAY = "|CFF2F4F4F",
        DARKTURQUOISE = "|CFF00CED1",
        DARKVIOLET = "|CFF9400D3",
        DEEPPINK = "|CFFFF1493",
        DEEPSKYBLUE = "|CFF00BFFF",
        DIMGRAY = "|CFF696969",
        DODGERBLUE = "|CFF1E90FF",
        FIREBRICK = "|CFFB22222",
        FLORALWHITE = "|CFFFFFAF0",
        FORESTGREEN = "|CFF228B22",
        FUCHSIA = "|CFFFF00FF",
        GAINSBORO = "|CFFDCDCDC",
        GHOSTWHITE = "|CFFF8F8FF",
        GOLD = "|CFFFFCC00",
        GOLD2 = "|CFFFFD700",
        GOLDENROD = "|CFFDAA520",
        GRAY = "|CFF808080",
        GREEN = "|CFF008000",
        GREEN2 = "|CFF00FF00",
        GREENYELLOW = "|CFFADFF2F",
        GREY = "|CFF888888",
        HONEYDEW = "|CFFF0FFF0",
        HOTPINK = "|CFFFF69B4",
        INDIANRED = "|CFFCD5C5C",
        INDIGO = "|CFF4B0082",
        IVORY = "|CFFFFFFF0",
        KHAKI = "|CFFF0E68C",
        LAVENDER = "|CFFE6E6FA",
        LAVENDERBLUSH = "|CFFFFF0F5",
        LAWNGREEN = "|CFF7CFC00",
        LEMONCHIFFON = "|CFFFFFACD",
        LIGHTBLUE = "|CFF00CCFF",
        LIGHTBLUE2 = "|CFFADD8E6",
        LIGHTCORAL = "|CFFF08080",
        LIGHTCYAN = "|CFFE0FFFF",
        LIGHTGRAY = "|CFFD3D3D3",
        LIGHTGREEN = "|CFF90EE90",
        LIGHTPINK = "|CFFFFB6C1",
        LIGHTRED = "|CFFFF6060",
        LIGHTSALMON = "|CFFFFA07A",
        LIGHTSEAGREEN = "|CFF20B2AA",
        LIGHTSKYBLUE = "|CFF87CEFA",
        LIGHTSLATEGRAY = "|CFF778899",
        LIGHTSTEELBLUE = "|CFFB0C4DE",
        LIGHTYELLOW = "|CFFFFFFE0",
        LIME = "|CFF00FF00",
        LIMEGREEN = "|CFF32CD32",
        LINEN = "|CFFFAF0E6",
        MAGENTA = "|CFFFF00FF",
        MAROON = "|CFF800000",
        MEDIUMAQUAMARINE = "|CFF66CDAA",
        MEDIUMBLUE = "|CFF0000CD",
        MEDIUMORCHID = "|CFFBA55D3",
        MEDIUMPURPLE = "|CFF9370DB",
        MEDIUMSEAGREEN = "|CFF3CB371",
        MEDIUMSLATEBLUE = "|CFF7B68EE",
        MEDIUMSPRINGGREEN = "|CFF00FA9A",
        MEDIUMTURQUOISE = "|CFF48D1CC",
        MEDIUMVIOLETRED = "|CFFC71585",
        MIDNIGHTBLUE = "|CFF191970",
        MINTCREAM = "|CFFF5FFFA",
        MISTYROSE = "|CFFFFE4E1",
        MOCCASIN = "|CFFFFE4B5",
        NAVAJOWHITE = "|CFFFFDEAD",
        NAVY = "|CFF000080",
        OLDLACE = "|CFFFDF5E6",
        OLIVE = "|CFF808000",
        OLIVEDRAB = "|CFF6B8E23",
        ORANGE = "|CFFFFA500",
        ORANGERED = "|CFFFF4500",
        ORCHID = "|CFFDA70D6",
        PALEGOLDENROD = "|CFFEEE8AA",
        PALEGREEN = "|CFF98FB98",
        PALETURQUOISE = "|CFFAFEEEE",
        PALEVIOLETRED = "|CFFDB7093",
        PAPAYAWHIP = "|CFFFFEFD5",
        PEACHPUFF = "|CFFFFDAB9",
        PERU = "|CFFCD853F",
        PINK = "|CFFFFC0CB",
        PLUM = "|CFFDDA0DD",
        POWDERBLUE = "|CFFB0E0E6",
        PURPLE = "|CFF800080",
        RED = "|CFFFF0000",
        ROSYBROWN = "|CFFBC8F8F",
        ROYALBLUE = "|CFF4169E1",
        SADDLEBROWN = "|CFF8B4513",
        SALMON = "|CFFFA8072",
        SANDYBROWN = "|CFFF4A460",
        SEAGREEN = "|CFF2E8B57",
        SEASHELL = "|CFFFFF5EE",
        SIENNA = "|CFFA0522D",
        SILVER = "|CFFC0C0C0",
        SKYBLUE = "|CFF87CEEB",
        SLATEBLUE = "|CFF6A5ACD",
        SLATEGRAY = "|CFF708090",
        SNOW = "|CFFFFFAFA",
        SPRINGGREEN = "|CFF00FF7F",
        STEELBLUE = "|CFF4682B4",
        SUBWHITE = "|CFFBBBBBB",
        TAN = "|CFFD2B48C",
        TEAL = "|CFF008080",
        THISTLE = "|CFFD8BFD8",
        TOMATO = "|CFFFF6347",
        TRANSPARENT = "|C00FFFFFF",
        TURQUOISE = "|CFF40E0D0",
        VIOLET = "|CFFEE82EE",
        WHEAT = "|cFFF5DEB3",
        WHITE = "|cFFFFFFFF",
        WHITESMOKE = "|cFFF5F5F5",
        YELLOW = "|cFFFFFF00",
        YELLOWGREEN = "|CFF9ACD32",
    }
    return COLORS
end

function Colors:GetStrColors()
  local COLORS = self:GetAllColors()
  local tbl = {}
  for colorName, color in pairs(COLORS) do
    local str = colorName
    -- local str = color..colorName.."|r"
    table.insert(tbl, str)
  end

  table.sort(tbl)
  local coloredTbl = {}

  for _, colorName in ipairs(tbl) do
    table.insert(coloredTbl, COLORS[colorName]..colorName.."|r")
  end

  local colorStr = table.concat(coloredTbl, " ")
  
  return colorStr
end