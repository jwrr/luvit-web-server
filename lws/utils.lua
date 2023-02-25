-- lws.utils.lua

local utils = {}

function utils.slurp(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end


function utils.fileExists(name)
   local f=io.open(name, "r")
   if f~=nil then io.close(f) return true else return false end
end


local tostring_skiptable = {socket = 1, handlers = 2,}

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
    local kStr = tostring(k)
    local skip = tostring_skiptable[k]
    if not skip then
      json = json .. indentStr .. '"' .. k .. '"' .. ': '
      local tabSize = 4
      local spaceSize = 3 - math.floor(#kStr/tabSize)
      local spaces = string.rep('\t', spaceSize) 
      if type(v) == 'table' then
        json = json .. utils.tostring(v, indent)
      elseif type(v) == 'function' then
        json = json .. spaces .. '"**function**",\n'
      else
        local s = (type(v)==string) and v or tostring(v)
        json = json .. spaces .. '"' .. s .. '",\n'
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


function utils.split(str, sep)
  sep = sep or '%w'
  local notsep = '[^' .. sep .. ']+'
  local pieces = {}
  for piece in string.gmatch(str, notsep) do
    pieces[#pieces+1] = piece
  end
  return pieces
end


function utils.trim(s)
  return s:gsub("^%s+", ""):gsub("%s+$", "")
end


function utils.splitKV(cookieString)
  if cookieString == nil then
    return {}
  end

  local c = utils.split(cookieString, ';')

  kv_t = {}
  for i,s in ipairs(c) do
    local kv = utils.split(s, '=')
    local k = utils.trim(kv[1])
    local v = utils.trim(kv[2])
    kv_t[k] = v
  end  
  
  return kv_t
end


return utils
