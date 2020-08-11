local _, ADDON_TABLE = ...
local TE = ADDON_TABLE.Addon

local MyLib = TE.Init("Util.MyLib")

function MyLib.GetTableLength(table)

  -- return if input is not a table
  if type(table) ~= "table" then return nil end

  local count = 0

  for key, val in pairs(table) do
    count = count + 1
  end

  return count
end

function MyLib.GetiTableLength(table)

  -- return if input is not a table
  if type(table) ~= "table" then return nil end

  return #table
end

function MyLib.ConcatTwoTables(tbl1, tbl2)
  local newTable = {}

  for k, v in pairs(tbl1) do
    newTable[k] = v
  end

  for k, v in pairs(tbl2) do
    newTable[k] = v
  end

  return newTable
end

function MyLib.IndexOf(table, value)
  if not table then return nil end -- return if no table

  for k,v in ipairs(table) do 
    if v == value then return k end
  end

  return nil
end

function MyLib.GetNextNumInRange(num, max)

  assert(type(num) == "number" or type(max) == "number" or num or max)

  local nextNum = nil

  if (num >= max or num <= 0) then
    nextNum = 1
  else
    nextNum = num + 1
  end

  return nextNum
end

function MyLib.splitStringByLength(str, max_line_length)
   local lines = {}
   local line
   str:gsub("(%s*)(%S+)", 
      function(spc, word) 
         if not line or #line + #spc + #word > max_line_length then
            table.insert(lines, line)
            line = word
         else
            line = line..spc..word
         end
      end
   )
   table.insert(lines, line)
   return lines
end

function MyLib.splitString(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then 
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then 
        result[i] = source
    end
    return result
end

function MyLib.Acronym(s,ignore)
  ignore = ignore or
  {                                     --default list of words to ignore
    ["a"] = true, ["an"] = true, ["and"] = true, ["in"] = true, ["for"] = true,
    ["of"] = true, ["the"] = true, ["to"] = true, ["or"] = true,
  }

  local ans = {}
  for w in s:gmatch "[%w\"]+" do
    if not ignore[w:lower()] then ans[#ans+1] = w:sub(1,1):upper() end
  end
  return table.concat(ans)
end

function MyLib.UnescapeStr(str)
  local Result = tostring(str)
    Result = gsub(Result, "|c........", "") -- Remove color start.
    Result = gsub(Result, "|r", "") -- Remove color end.
    Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
    Result = gsub(Result, "|T.-|t", "") -- Remove textures.
    Result = gsub(Result, "{.-}", "") -- Remove raid target icons.
  return Result
end

function MyLib.PrintMouseoverInfo()
  -- print(MouseIsOver(Minimap))
  print(GetMouseFocus():GetName())
end