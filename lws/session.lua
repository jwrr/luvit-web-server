-- lws/session.lua

local cookie=require'lws.cookie'
local utils=require'lws.utils'
local page=require'lws.page'
local account=require'lws.account'
local session = {}


function session.getUserFromAccount(email, password)
  email = email or page.getPostParam('email') or nil
  password = password or page.getPostParam('password') or nil
  return account.getUser(email, password)
end


function session.start(res)
  local user = session.getUserFromAccount()
  if not user then return end
  session.user = user
  session.id = cookie.create(res)
  session_t = {userName = session.user, startTime = utils.now()}
  cookie.appendFields(session.id, session_t)
  return true
end


function session.continue(res)
  session.id = cookie.getCurrent()
  session.user = session.getUser(session.id)
end


function session.stop(res)
  session.id = nil
  session.user = nil
  cookieName = cookieName or cookie.defaultName or 'sid'
  local id = cookie.getCurrent()
  if not id then return end
  local user = session.getUser(id)
  cookie.remove(id)
  user = session.getUser(id)
  if not res then return end
  local nameVal = cookieName .. '=Expired;'
  local expireDate = ' Expires=' .. utils.nowUTC() .. ';'
  print('Set-Cookie: ' .. nameVal .. expireDate)
  res:setHeader('Set-Cookie', nameVal .. expireDate)
end


function session.getUser(sessionKey, sessionTableName)
  sessionTableName = sessionTableName or cookie.defaultName or 'id'
  sessionKey = sessionKey or session.id or 'nokey' -- page.headerCookies[sessionTableName] or 'nokey'
  local userName = 'Guest'
  if cookie.exists(sessionKey, sessionTableName) then
    userName = cookie.getField('userName', sessionKey, sessionTableName) or 'Guest'
  end
  return userName
end


function session.isLoggedIn()
  local isLoggedIn = session.id~=nil -- or page.headerCookies[sessionTableName]
  return isLoggedIn
end


return session
