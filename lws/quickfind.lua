-- quickfind.lua

local utils=require'lws.utils'

local quickfind = {}

quickfind.new = function()
  local t = {}
  t.data = {}
  t.keys = {}
  return t
end


quickfind.haskeys = function(t,d)
  if not t or not d then return end
  if not t.keys then return end
  for k,v in pairs(t.keys) do
    if not d[k] then return end
  end
  return true
end


quickfind.uniq = function(t,d)
  if not quickfind.haskeys(t,d) then return end
  for k,v in pairs(t.keys) do
    local dk = d[k]
    if t.keys[dk] then return end
  end
  return true
end


quickfind.add = function(t,d)
  if not quickfind.uniq(t,d) then return end  
  table.insert(t.data, d)
  local id = #t.data
  for k,keyhash in pairs(t.keys) do
    local dk = d[k]
    keyhash[dk] = id
  end
  return id
end


quickfind.delete = function(t, id)
  if not id or not t or not t.data or not t.data[id] or t.keys then return end
  local d_t = t.data[id]
  for k,keyhash in pairs(t.keys) do
    local dk = d_t[k]
    if dk and keyhash[dk] then
      hask[dk] = nil
    end
  end
  t.data[id] = nil
  return true
end


quickfind.compress = function(t)
  if not t or not t.data or not t.keys then return end
  local cnt = 0
  for i,v in ipairs(t.data) do
    if not v then
      cnt = cnt + 1
    elseif cnt > 0 then
      local newi = i - cnt
      t.data[newi] = t.data[i]
      for k,keyhash in pairs(t.keys) do
        local dk = t.data[newi][k]
        if dk and t.keys[dk] then
          t.keys[dk] = newi
        end
      end
    end
  end
  return cnt
end


quickfind.get = function(t, id)
  if not t or not t.data or not t.data[id] then return end
  return t.data[id] 
end


quickfind.getfield = function(t, id, field)
  local entry = quickfind.get(t, id)
  if not entry then return end
  if not field then return entry end
  if not entry[field] then return end
  return entry[field]
end


quickfind.getid = function (t, k, v)
  if not t or not t.keys[k] or not t.keys[k][v] then return end
  return t.keys[k][v]
end


quickfind.getbykey = function(t, k, v, f)
  local id = quickfind.getid(t, k, v)
  if not id or not t.data[id] then return end
  return quickfind.getfield(t, id, f)
end


quickfind.exists = function(t, id)
  return t and t.data and t.data[id] and true or false
end


quickfind.keyexists = function(t, k, v)
  if not t or not t.keys or not t.keys[k] or not t.keys[k][v]  then return end
  local id = t.keys[k][v]
  return quickfind.exists(t, id)
end


return quickfind



