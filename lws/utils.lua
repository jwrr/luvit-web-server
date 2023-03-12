-- lws.utils.lua

local utils = {}

function utils.slurp(file)
  local f = assert(io.open(file, 'rb'))
  local content = f:read('*all')
  f:close()
  return content
end


function utils.writeFile(filename, s)
  if not filename then return end
  if not s then return end
  local f = assert(io.open(filename, 'w'))
  local writeSuccessful = f:write(s)
  local closeSuccessful = f:close()
  local success = writeSuccessful and closeSuccessful
  return success
end


function utils.fileExists(name)
  local f=io.open(name, "r")
  if f~=nil then io.close(f) return true else return false end
end



function utils.rpad(s, n)
  s = s or ''
  local str = tostring(s)
  local p = n - #str
  return str .. string.rep(' ', p)
end



utils.luaTable = {
	["jwrr.com@gmail.com"] = {
		["user"] =             "jwrr",
		["password"] =         "1234",
		["email"] =            "jwrr.com@gmail.com"
	},
	["jacob2@gmail.com"] = {
		["user"] =             "jacob2",
		["password"] =         "asdfasfasdf",
		["email"] =            "jacob2@gmail.com"
	}
}


--[[
function utils.tostring(t, indent, title)
  if type(t) ~= 'table' then
    return tostring(t)
  end
  indent = indent or 0
  indent = indent + 1
  title = title or ''
  local indentStr = (indent > 0) and string.rep('\t', indent) or ''
  local json = '{\n'
  if indent > 10 then
    return json .. indentStr .. 'STACK OVERFLOW\n' .. indentStr .. '}\n'
  end
  for k,v in pairs(t) do
    local skip = tostring_skiptable[k]
    if not skip then
      local kStr = utils.rpad('"'..tostring(k)..'": ', 20)
      json = json .. indentStr .. kStr
      if type(v) == 'table' then
        json = json .. utils.tostring(v, indent)
      elseif type(v) == 'function' then
        json = json .. '"**function**",\n'
      else
        local s = (type(v)==string) and v or tostring(v)
        json = json .. '"' .. s .. '",\n'
      end
    end
  end

  json = json:gsub(',\n$', '\n')
  indent = indent - 1
  local comma = (indent>0) and ',' or ''
  local indentStr = (indent > 0) and string.rep('\t', indent) or ''
  if json:find('{\n$') then
    json = json:gsub('{\n$', '{')
    indentStr = ''
  end
  json = json .. indentStr .. '}' .. comma .. '\n'
  return title .. json
end
--]]

local tostring_skiptable = {socket = 1, handlers = 2,}

function utils.tostring(t, indent, title, format, skips)
  skips = skips or tostring_skiptable or {}
  if type(t) ~= 'table' then
    return tostring(t)
  end
  format = format or 'json'
  indent = indent or 0
  indent = indent + 1
  title = title or ''
  local indentStr = (indent > 0) and string.rep('\t', indent) or ''
  local sss = '{\n'
  if indent > 10 then
    return sss .. indentStr .. 'STACK OVERFLOW\n' .. indentStr .. '}\n'
  end
  for k,v in pairs(t) do
    local skip = skips[k]
    if not skip then
      local kStr = tostring(k)
      if format:lower() == "lua" then
        local isValidIdentifier = kStr:find('^[%a_][%w_]*$')
        if isValidIdentifier then
          kStr = utils.rpad(kStr..' = ', 20)
        else
          kStr = utils.rpad('["'..kStr..'"] = ', 20)
        end
      else -- default to json
        kStr = utils.rpad('"'..tostring(kStr)..'": ', 20)
      end
      sss = sss .. indentStr .. kStr
      if type(v) == 'table' then
        sss = sss .. utils.tostring(v, indent, '', format, skips)
      elseif type(v) == 'function' then
        sss = sss .. '"**function**",\n'
      else
        local s = (type(v)==string) and v or tostring(v)
        sss = sss .. '"' .. s .. '",\n'
      end
    end
  end

  sss = sss:gsub(',\n$', '\n')
  indent = indent - 1
  local comma = (indent>0) and ',' or ''
  local indentStr = (indent > 0) and string.rep('\t', indent) or ''
  if sss:find('{\n$') then
    sss = sss:gsub('{\n$', '{')
    indentStr = ''
  end
  sss = sss .. indentStr .. '}' .. comma .. '\n'
  return title .. sss
end


math.randomseed(os.time())

function utils.rand64(len)
  local base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  s = ""
  for i=1,len do
    r = math.random(64);
    ch64 = base64:sub(r, r)
    s = s .. ch64
  end
  return s
end


function utils.split(s, sep)
  sep = sep or '%w'
  local notsep = '[^' .. sep .. ']+'
  local parts = {}
  local cnt = 0
  if not s then
    return parts
  end
  for piece in string.gmatch(s, notsep) do
    parts[#parts+1] = piece
    cnt = cnt + 1
  end
  return parts
end


function utils.getTableValueFromDotKey(t, dotkey)
  if not t or not dotkey then return end
  local parts = utils.split(dotkey, '.')
  for i,p in ipairs(parts) do
    if not t[p] then
      return
    end
    t = t[p]
  end
  if type(t) == 'function' then
    return t()
  end
  return t
end


function utils.getTableStringFromDotKey(t, dotkey)
  return utils.tostring(utils.getTableValueFromDotKey(t, dotkey))
end


function utils.getNth(s, sep, n)
  local parts = utils.split(s, sep)
  if n <= #parts then
    return parts[n]
  end
  return
end


function utils.startsWith(haystack, needle, plain)
  if not haystack or not needle then return end
  local found = haystack:find(needle, 1, plain) ~= nil
  return found
end


function utils.endsWith(haystack, needle, plain)
  if not haystack or not needle then return end
  return haystack:find(needle..'$', 1, plain) and true or false
end


function utils.contains(haystack, needle, plain)
  if not haystack or not needle then return end
  return haystack:find(needle, 1, plain) and true or false
end


function utils.isBlank(s)
  if not s then return true end
  return utils.trim(s) == ''
end


function utils.getValue(s, name)
  if not s or not name then return end
  local p = '.*'..name..'%s*=%s*"([^"]*).*'
  if not s:find(p) then return end
  local v = s:gsub(p, '%1')
  return v
end


function utils.lastWord(s)
  if not s then return end
  s = utils.trim(s)
  local lw = s:gsub('.*%s', '')
  return lw
end


function utils.trim(s)
  return s:gsub("^%s+", ""):gsub("%s+$", "")
end


function utils.rtrim(s)
  return s:gsub("%s+$", "")
end


function utils.removeCRLF(s)
   return s:gsub("\r\n$", "")
end


-- Returns hash of matches with number of occurrences for each match.
function utils.getMatches(haystack, needle)
  if not haystack or not needle then return {} end
  local matches = {}
  for m in string.gmatch(haystack, needle) do
    matches[m] = matches[m] and matches[m] + 1 or 1;
  end
  return matches
end


function utils.splitKV(kvstr, sepOuter, sepInner)
  if kvstr == nil then
    return {}
  end

  sepOuter = sepOuter or ';'
  sepInner = sepInner or '='

  local c = utils.split(kvstr, sepOuter)

  kv_t = {}
  for i,s in ipairs(c) do
    local kv = utils.split(s, sepInner)
    local k = utils.trim(kv[1])
    local v = utils.trim(kv[2])
    if not kv_t[k] then -- if multiple then take only the first
      kv_t[k] = v
    end
  end

  return kv_t
end


function utils.getDateUTC(timestamp)
  timestamp = timestamp or os.time()
  return os.date('!%Y-%m-%d-%H:%M:%S GMT', timestamp)
end


function utils.now()
  return os.time()
end


function utils.nowUTC()
  return utils.getDateUTC(utils.now())
end


function utils.decodeURLChar(hex)
  return string.char(tonumber(hex,16))
end

function utils.decodeURL(url)
  local s, t = string.gsub(url, "%%(%x%x)", utils.decodeURLChar)
  return s
end

return utils
