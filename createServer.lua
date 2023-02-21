#!/usr/local/bin/luvit

-- createServer.lua

package.path  = "/var/local/luarocks-3.8.0/lua_modules/share/lua/5.1/?.lua;" .. package.path
package.path  = package.path..';/var/www/html/?.lua;/luvit/deps/?.lua'
package.cpath = "/var/local/luarocks-3.8.0/lua_modules/lib/lua/5.1/?.so;" .. package.cpath
package.cpath = "/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;" .. package.cpath

local lfs = require 'lfs'
local http = require'http'
local https = require'https'
local url = require'url'
local srv = require'lws.srv'
local db = require'lws.db'

http.createServer(function (req, res)
  local currDir = lfs.currentdir()
  srv.addContentType('md', 'text/html')
  local contentDir = '/var/www/html/content'
  body = srv.getBody(req, res, contentDir)
  res:finish(body)
end):listen(1337, '0.0.0.0')

print('Server running at http://0.0.0.0:1337/')

