-- account.lua

local utils=require'lws.utils'
local page=require'lws.page'
local password=require'lws.password'
local quickfind=require'lws.quickfind'
local account = {}

account.qf = quickfind.new({'email', 'user'})

account.create = function(skipSave,k,v)
  if not k then
    if not page.postParams and page.postParams['email'] then return end
    k = page.postParams['email']
    if not k then return end
  end
  k = string.lower(k)
  if not v then
    if not page.postParams then return end
    page.encodePassword()
    v = page.postParams
  end
  if not v['email'] then return end
  if not v['user'] then return end
  if not v['password'] then return end
  local ok = quickfind.add(account.qf, v)
  if not ok then return end
  if skipSave then return true end
  ok = account.save()
  return ok
end


account.delete = function(skipSave,k)
  if not k then return end
  local ok = quickfind.deletebykey(account.qf, 'email', k)
  if skipSave then return true end
  return account.save()
end


account.get = function(k)
  if not k then return end
  local entry = quickfind.getbykey(account.qf, 'email', k)
  return entry
end


account.update = function(skipSave, k, vtable)
  quickfind.updatebykey(account.qf, 'email', k, vtable)
  if skipSave then return true end
  return account.save()
end


account.save = function(filename)
  filename = filename or page.rootpath.."/accounts.db"
  if not filename then return end
  local fileContent = utils.tostring(account.qf.data, 0, 'db = ', 'lua')
  local ok = utils.writeFile(filename, fileContent)
  return ok
end


account.load = function(filename)
  filename = filename or page.rootpath.."/accounts.db"
  dofile(filename)
  quickfind.load(account.qf, db)
  print(utils.tocsv(account.qf.data, '\t||| '))
  return
end


function account.contains(k)
  if not k then return false end
  local exists = quickfind.existsbykey(account.qf, 'email', k)
  return exists
end


function account.containsField(k, f)
  if not k or not f then return false end
  local exists = quickfind.existsbykey(account.qf, 'email', k, f)
  return exists
end


function account.getField(k, f)
  local field = quickfind.getbykey(account.qf, 'email' , k, f)
  return field
end


function account.validPassword(k, pw)
  if not k or not pw then return end
  local encodedPassword = account.getField(k, 'password')
  if not encodedPassword then return end
  local ok = password.check(encodedPassword, pw)
  return ok
end


function account.validEncodedPassword(k, encodedPassword)
  if not k or not encodedPassword then return end
  local storedPassword = account.getField(k, 'password')
  print('IN account.validEncodedPassword. k=', k)
  print('  encodedPassword=', encodedPassword)
  print('  storedPassword =', storedPassword)
  if not storedPassword then return end
  local ok = encodedPassword == storedPassword
  return ok
end


function account.getUser(k, encodedPassword)
  if account.validEncodedPassword(k, encodedPassword) then
    local user = account.getField(k, 'user')
    return user
  end
  return
end


account.load()

return account

