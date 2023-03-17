-- quickfind.lua

local utils=require'lws.utils'

local quickfind = {}

quickfind.new = function(keys)
  local t = {}
  t.data = {}
  t.keys = {}
  if not keys then return t end
  for i,k in ipairs(keys) do
    t.keys[k] = {}
  end
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


quickfind.iskey(t, k)
  if not t or not t.keys then return end
  return t.keys[k] and true or false
end

quickfind.update = function(t, id, d)
  local dold = quickfind.get(t, id)
  if not dold then return end
  -- make sure keys stay unique
  for k,v in pairs(d) do
    if quickfind.iskey(k) then
      if t.keys[k][v] then return end
    end
  end

  -- update
  for k,v in pairs(d) do
    if not dold[k] or dold[k] ~= v then
      if quickfind.iskey(t, k) then
        local oldkey = dold[k]
        t.keys[k][oldkey] = nil
        t.keys[k][v] = id
      end
      t.data[id][k] = v
    end
  end
  return true
end


quickfind.updatebykey = function(t, k, v, d)
  local id = quickfind.getid(t, k, v)
  if not id or not t.data[id] then return end
  return quickfind.update(t, id, d)
end


quickfind.addkey = function(t, k)
  if not t or not t.keys or not t.data then return end
  if t.keys[k] then return end

  local keyhash = {}
  -- verify all existing data entries have the key and and are unique
  for id,v in ipairs(t.data) do
    if not v[k] then return end
    local keyvalue = v[k]
    if keyhash[keyvalue] then return end
    keyhash[keyvalue] = id
  end
  t.keys[k] = keyhash
  return true
end


quickfind.addkeys = function(t, keys)
  local ok = true
  for _,k in ipairs(keys) do
    local ok = quickfind.addkeys(t, k) and ok
  end
  return ok
end


quickfind.delete = function(t, id, f)
  if not id or not t or not t.data or not t.data[id] or t.keys then return end
  local d_t = t.data[id]
  if f then
    if not t.data[id][f] then return end
    if t.keys[f] then return end
    t.data[id][f] = nil
    return true
  end
  for k,keyhash in pairs(t.keys) do
    local dk = d_t[k]
    if dk and keyhash[dk] then
      hask[dk] = nil
    end
  end
  t.data[id] = nil
  return true
end


quickfind.deletebykey = function(t, k, v, f)
  local id = quickfind.getid(t, k, v)
  if not id or not t.data[id] then return end
  return quickfind.delete(t, id, f)
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


quickfind.exists = function(t, id, f)
  if f then
    return t and t.data and t.data[id] and t.data[id][f] and true or false
  end
  return t and t.data and t.data[id] and true or false
end


quickfind.existsbykey = function(t, k, v, f)
  if not t or not t.keys or not t.keys[k] or not t.keys[k][v]  then return end
  local id = t.keys[k][v]
  return quickfind.exists(t, id, f)
end


return quickfind



