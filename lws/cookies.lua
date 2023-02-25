-- lws/cookie.lua

local cookies = {}

cookies.t = {}

function cookies.set(name, val)
  cookies.t[name] = val
end

function cookies.isSet(cookiename)
  return cookies.t[cookiename] and true or false
end

return cookies

