-- account.lua

local utils=require'lws.utils'
local page=require'lws.page'

local account = {}

account.db = {}


account.create = function(skipSave,k,v)
  if not k then
    if not page.postParams and page.postParams['email'] then return end
    k = page.postParams['email']
    if not k then return end
  end
  if not v then
    if not page.postParams then return end
    v = page.postParams
  end
  account.db[k] = v
  if skipSave then return true end
  local success = account.save()
  return success
end


account.delete = function(skipSave,k)
  if not k then return end
  account.db[k] = nil
  if skipSave then return true end
  return account.save()
end


account.get = function(k)
  if not k then return end
  if not account.db[k] then return end
  return account.db[k]
end


account.update = function(skipSave, k, vtable)
  if not k then return end
  if not account.db[k] then return end
  if not vtable then return end
  for fieldk,fieldv in pairs(vtable) do
    account.db[k][fieldk] = fieldv
  end
  if skipSave then return true end
  return account.save()
end


account.save = function(filename)
  filename = filename or page.rootpath.."/accounts.db"
  if not filename then return end
  local success = utils.writeFile(filename, utils.tostring(account.db, 0, 'db = ', 'lua'))
  return success
end


account.load = function(filename)
  filename = filename or page.rootpath.."/accounts.db"
  dofile(filename)
  account.db = db
  print(utils.tostring(account.db))
  return
end


function account.contains(k)
  if not k then return false end
  return account.db[k] and true or false
end


function account.containsField(k, f)
  if not k or not f then return false end
  return account.db[k] and account.db[k][f] and true or false
end


function account.getField(k, f)
  if account.containsField(k, f) then
    return account.db[k][f]
  end
  return
end


function account.validPassword(k, pw)
  if not k or not pw then return false end
  local password = account.getField(k, 'password')
  if not password then return false end
  return pw == password
end


function account.getUser(k, pw)
  if account.validPassword(k, pw) then
    local user = account.getField(k, 'user')
    return user
  end
  return
end


account.load()

return account

