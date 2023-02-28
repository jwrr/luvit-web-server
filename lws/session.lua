-- lws/session.lua

local cookie = require'lws.cookie'
local utils = require'lws.utils'
local page = require'lws.page'

local session = {}

session.t = {}

function session.start(res)
  session.id = cookie.getCurrent()
  local userName = page.getPostParam('email') or 'Guest'
  session.user = userName
  if true then
    session.id = cookie.create(res)
    session_t = {userName = userName, startTime = utils.now()}
    cookie.appendFields(session_t, session.id)
    return true
  end
  return false
end


function session.continue(res)
  session.id = cookie.getCurrent()
  session.user = session.getUser(id)
end


function session.stop(res)
  session.id = nil
  session.user = nil
  cookieName = cookieName or cookie.defaultName or 'sid'
  local id = cookie.getCurrent()
  if not id then
    return
  end
  local user = session.getUser(id)
  print('SESSION.STOP id='..id..' user='..user)
  cookie.remove(id)
  user = session.getUser(id)
  print('SESSION.STOP after remove: user='..user)
  
  if not res then
    return
  end
  local nameVal = cookieName .. '=Expired;'
  local expireDate = ' Expires=' .. utils.nowUTC() .. ';'
  print("Set-Cookie: " .. nameVal .. expireDate)
  res:setHeader('Set-Cookie', nameVal .. expireDate)
end


function session.getUser(sessionKey, sessionTableName)
  sessionTableName = sessionTableName or cookie.defaultName or 'id'
--  sessionKey = sessionKey or page.headerCookies[sessionTableName] or 'nocookie'
  sessionKey = sessionKey or session.id or 'nokey' -- page.headerCookies[sessionTableName] or 'nokey'
  local userName = 'Guest'
  if cookie.exists(sessionKey, sessionTableName) then
    userName = cookie.getField('userName', sessionKey, sessionTableName) or 'Guest'
    print("IN GETUSER: userName ="..userName)
  end
  return userName
end


function session.isLoggedIn()
  local isLoggedIn = session.id~=nil -- or page.headerCookies[sessionTableName]
  return isLoggedIn
end





return session
