-- lws/session.lua

local cookie=require'lws.cookie'
local utils=require'lws.utils'
local page=require'lws.page'
local password=require'lws.password'
local account=require'lws.account'

local session = {}


function session.getPassword()
  encodedPassword = page.getPostParam('password') or nil
  return encodedPassword
end


function session.getUserFromAccount(setPage, email, encodedPassword)
  print(page.getPostParams('json'))
  email = email or page.getPostParam('email') or nil
  print('IN session.getUserFromAccount. email=',email)
  encodedPassword = encodedPassword or session.getPassword() or nil
  print('In session.getUserFromAccount. encodedPassword=',encodedPassword)
  if not email or not encodedPassword then return end
  local user = account.getUser(email, encodedPassword)
  print('In session.getUserFromAccount. user=',user)
  if setPage then
    page.user = user
  end
  return user
end


function session.start(res)
  page.clearUser()
  print("IN session.start1. user/pw=",user,page.getPassword())
  page.encodePassword()
  local user = session.getUserFromAccount(true)
  print("IN session.start2. user/pw=",user,page.getPassword())
  if not user then return end
  session.user = user
  session.id = cookie.create(res)
  session_t = {userName = session.user, startTime = utils.now()}
  print("IN session.start. user/sid=", session.user, session.id,'session_t=',utils.tostring(session_t))
  cookie.appendFields(session.id, session_t)
  return true
end


function session.continue(res)
  page.clearUser()
  session.id = cookie.getCurrent()
  session.user = session.getUser(session.id)
  
end


function session.stop(res)
  page.clearUser()
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
