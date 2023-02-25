-- lws/cookie.lua


local utils = require'lws.utils'
local page = require'lws.page'

local cookie = {}

cookie.t = {}

cookie.defaultName = 'id'
cookie.defaultAttributes = 'secure; http-only; SameSite=None; Path=/;'


function cookie.create(res, key, name, maxAge, attr)
  key = key or utils.rand64(64)
  name = name or cookie.defaultName or 'sid'
  maxAge = maxAge or 60*60*24*7
  attr = attr or cookie.defaultAttributes
  attr = ' ' .. attr
  local now = os.time()
  local expireTime = now + maxAge

  if not cookie.t[name] then
    cookie.t[name] = {}
  end
  
  cookie.t[name][key] = expireTime
  
  print("created cookie:" .. name .. ' ' .. key .. ' ' .. cookie.t[name][key])
  
  if res then
    local nameVal = name .. '=' .. key .. ';'
    local expireDate = ' Expires=' .. utils.getDateUTC(expireTime) .. ';'
    print("Set-Cookie: " .. nameVal .. expireDate .. attr)
    res:setHeader('Set-Cookie', nameVal .. expireDate .. attr)
  end
  return key
end


function cookie.exists(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  if cookie.t[name] and cookie.t[name][key] then
    return cookie.t[name] and cookie.t[name][key] and true
  end
  return false
end


function cookie.getExpire(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  if cookie.exists(key, name) then
    return cookie[name][key]
  end
  return nil
end


function cookie.getExpireUTC(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  local expireTime = cookie.getExpire(name)
  if expireTime then
    return utils.getDateUTC(expireTime)
  end
  return nil
end


function cookie.remove(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  if cookie.exists(key, name) then
    cookie[name][key] = nil
  end
end


function cookie.isExpired(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  local expireTime = cookie.getExpire(key, name) or 0
  return expireTime < utils.now()
end


function cookie.removeIfExpired(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  if cookie.isExpired(key, name) then
    cookie.remove(key, name)
  end
end


function cookie.isValid(key, name)
  name = name or cookie.defaultName or 'sid'
  key = key or page.headerCookies[name]
  if cookie.exists(key, name) then -- and not cookie.isExpired(key, name) then
    return true
  end
  cookie.remove(key, name)
  return false
end

function cookie.getCurrent(name)
  name = name or cookie.defaultName or 'sid'
  local id = page.headerCookies[name]
  if cookie.exists(id, name) then
    return id
  end
  return nil
end

return cookie

