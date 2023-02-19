-- db.lua

local db = {}

db.driver = require'luasql.sqlite3'


function db.open()
  db.env = db.driver.sqlite3()
  db.db = db.env:connect('/var/www/html/litelua.db')
end

function db.close()
  db.db:close()
  db.env:close()
end

function db.get(key)
  db.open()

  local results = db.db:execute('SELECT * FROM example;')
  
  local id,mail,url,lang,name = results:fetch()
  local dataStr = ''
  while id do
    dataStr = dataStr .. id..' | '..mail..' | '..url..' | '..lang ..' | '..name..'\n'
    id,mail,url,lang,name = results:fetch()
  end
  
  results:close()
  db.close()
  return dataStr
end

print( db.get("asdf") )

return db



