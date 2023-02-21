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

function utils.tostring(t, indent)
  indent = indent or 0
  indent = indent + 1
  local indentStr = (indent > 0) and string.rep('\t', indent) or ''
  local json = '{\n'
  if indent > 10 then
    return json .. indentStr .. 'STACK OVERFLOW\n' .. indentStr .. '}\n'
  end
  for k,v in pairs(t) do
    local skip = tostring_skiptable[k]
    if not skip then
      json = json .. indentStr .. k .. ': ' 
      if type(v) == 'table' then
        json = json .. utils.tostring(v, indent)
      elseif type(v) == 'function' then
        json = json .. '\t\t' .. '"function",\n'
      else
        local s = (type(v)==string) and v or tostring(v)
        json = json .. '\t\t' .. '"' .. s .. '",\n'
      end
    end
  end

  json = json:gsub(',\n$', '\n')  
  indent = indent - 1
  local indentStr = (indent > 0) and string.rep('\t', indent) or ''
  json = json .. indentStr .. '}\n'
  return json
end

return utils
