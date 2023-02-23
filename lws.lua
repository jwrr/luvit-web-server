#!/usr/local/bin/luvit

-- createServer.lua

package.path  = "/var/local/luarocks-3.8.0/lua_modules/share/lua/5.1/?.lua;" .. package.path
package.path  = package.path..';/var/www/html/?.lua;/luvit/deps/?.lua'
package.cpath = "/var/local/luarocks-3.8.0/lua_modules/lib/lua/5.1/?.so;" .. package.cpath
package.cpath = "/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;" .. package.cpath

local fs = require'fs'
local http = require'http'
local https = require'https'
local url = require'url'
local page = require'lws.page'
local srv = require'lws.srv'
local db = require'lws.db'


local function onRequest(req, res)
  page.protocol = 'https'
  page.sitePath = '/var/www/html/content'
  body = srv.getBody(req, res)
  res:finish(body)
end


function map(a, fcn)
  a = a or {}
  local b={}
  for i,v in ipairs(a) do
    table.insert(b, fcn(v))
  end
  return b
end


local items = {};


function show(res)
  local html = '<html><head><title>Todo List</title></head><body>\n'
  .. '<h1>Todo List</h1>\n' 		-- For simple apps, inlining
  .. '<ul>\n' 						-- the HTML instead of
  .. table.concat(map(items, function(item) 	--using a template engine works well.
  return '<li>' .. item .. '</li>'
  end),'\n')
  .. '</ul>\n'
  .. '<form method="post" action="/todo">\n'
  .. '<p><input type="text" name="item" /></p>\n'
  .. '<p><input type="submit" value="Add Item" /></p>\n'
  .. '</form></body></html>\n';
  res:setHeader('Content-Type', 'text/html');
  res:setHeader('Content-Length', #html);
  res:finish(html);
end

local qs = require('querystring');
function add(req, res)
  local body = '';
  --req.setEncoding('utf8');
  req:on('data', function(chunk) body =body.. chunk; end);
  req:on('end', function()
    local obj = qs.parse(body);
    --p(obj)
    table.insert(items,obj.item);
    show(res);
  end);
end


function handlePOST(req, res, page)
  local postQuery = '';
  --req.setEncoding('utf8');
  req:on('data', function(chunk) postQuery = postQuery .. chunk end);
  req:on('end', function()
    page.post = postQuery
    page.post_t = srv.getQuery(postQuery)
    page.request_t = page.post_t
  end);
end



http.createServer(function (req, res)
  page.protocol = 'http'
  page.sitePath = '/var/www/html/content'

  if req.url=='/todo' then
    if req.method=='GET' then
      show(res);
    elseif req.method=='POST' then
      add(req, res);
    else
      badRequest(res);
    end
  else
    if req.method=='POST' then
      handlePOST(req, res, page)
    end
    body = srv.getBody(req, res)
    res:finish(body)
  end
end):listen(1337, '0.0.0.0')


-- http.createServer(onRequest):listen(8080)
-- print("Server listening at http://localhost:8080/")

https.createServer({
  key = fs.readFileSync("/var/www/html/key.pem"),
  cert = fs.readFileSync("/var/www/html/cert.pem"),
}, onRequest):listen(8443)

print("Server listening at https://localhost:8443/")
print('Server running at http://localhost:1337/')
