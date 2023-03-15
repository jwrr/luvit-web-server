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

local tostring_skiptable = {socket = 1, handlers = 2,}

function utils.tostring(t, level, title, format, skips)
  skips = skips or tostring_skiptable or {}
  if type(t) ~= 'table' then
    return tostring(t)
  end
  format = format or 'json'
  format = format:lower()
  level = level or 0
  level = level + 1
  title = title or ''
  local indentstr = (level > 0) and string.rep('\t', level) or ''
  local finalstr = '{\n'
  if level > 10 then
    return finalstr .. indentstr .. 'STACK OVERFLOW\n' .. indentstr .. '}\n'
  end
  for k,v in pairs(t) do
    local skip = skips[k]
    if not skip then
      local keystr = tostring(k)
      if format == 'lua' then
        local isValidIdentifier = keystr:find('^[%a_][%w_]*$')
        if isValidIdentifier then
          keystr = utils.rpad(keystr..' = ', 20)
        else
          keystr = utils.rpad('["'..keystr..'"] = ', 20)
        end
      else -- default to json
        keystr = utils.rpad('"'..tostring(keystr)..'": ', 20)
      end

      finalstr = finalstr .. indentstr .. keystr
      if type(v) == 'table' then
        finalstr = finalstr .. utils.tostring(v, level, '', format, skips)
      elseif type(v) == 'function' then
        finalstr = finalstr .. '"**function**",\n'
      else
        local s = (type(v)==string) and v or tostring(v)
        finalstr = finalstr .. '"' .. s .. '",\n'
      end
    end
  end

  finalstr = finalstr:gsub(',\n$', '\n')
  level = level - 1
  local comma = (level>0) and ',' or ''
  local indentstr = (level > 0) and string.rep('\t', level) or ''
  if finalstr:find('{\n$') then
    finalstr = finalstr:gsub('{\n$', '{')
    indentstr = ''
  end
  finalstr = finalstr .. indentstr .. '}' .. comma .. '\n'

  return title .. finalstr
end


function utils.getkeys(t)
  if not t then return {} end
  local keys = {}
  local cnt = 0
  for k,v in pairs(t) do
    cnt = cnt + 1
    keys[cnt] = k
  end
  return keys
end


function utils.tocsv(convertthis_t, sep, level, title, skipthese_t, hierarchy_str, columns_t, rownum)
  level = level or 0
  if level > 10 then return 'STACK OVERFLOW' end
  title = title or ''
  skipthese_t = skipthese_t or {}
  hierarchy_str = hierarchy_str or ''
  columns_t = columns_t or {}
  rownum = rownum or 0
  sep = sep or ','
  for k,v in pairs(convertthis_t) do
    local skip = skipthese_t[k]
    if not skip then
      local fullkey = hierarchy_str~='' and hierarchy_str..'.'..k or k
      if type(v) == 'table' then
        if level == 0 then
          rownum = rownum + 1
        end
        local fullkey_tmp = level > 0 and fullkey or ''
        utils.tocsv(v, sep, level+1, '', skipthese_t, fullkey_tmp, columns_t, rownum)
      else
        local s = type(v) == 'function' and '**function**' or tostring(v)
        if k:lower() == 'password' then
          s = s:sub(-12)
        end
        columns_t[fullkey] = columns_t[fullkey] or {}
        columns_t[fullkey][rownum] = s
      end
    end
  end
  if level == 0 then
    local cnames_t = utils.getkeys(columns_t)
    local header_str = 'id'..sep..utils.join(cnames_t, sep)
    local csvrows_t = {header_str}
    for i = 1,rownum do
      local row_t = {tostring(i)..sep}
      for _,cname in ipairs(cnames_t) do
        row_t[#row_t+1] = columns_t[cname][i] or ''
      end
      csvrows_t[#csvrows_t+1] = utils.join(row_t, sep)
    end
    return utils.join(csvrows_t, '\n')
  end
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


function utils.join(t, sep)
  if not t or not t[1] then return '' end
  sep = sep or ' '
  local s = t[1]
  for i=2,#t do
    s = s .. sep .. t[i]
  end
  return s
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
