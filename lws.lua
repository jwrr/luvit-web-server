#!/usr/local/bin/luvit

-- lws.lua

local rootpath='/var/www/html'

package.path  = "/var/local/luarocks-3.8.0/lua_modules/share/lua/5.1/?.lua;" .. package.path
package.path  = package.path..';'..rootpath..'/?.lua;/luvit/deps/?.lua'
package.cpath = "/var/local/luarocks-3.8.0/lua_modules/lib/lua/5.1/?.so;" .. package.cpath
package.cpath = "/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;" .. package.cpath

local fs=require'fs'
local http=require'http'
local https=require'https'
local url=require'url'

local page=require'lws.page'
page.rootpath=rootpath

local srv=require'lws.srv'
local db=require'lws.db'
local brotli=require'lws.brotli'
local utils=require'lws.utils'
local upload=require'lws.upload'


local items = {};

function map(a, fcn)
  a = a or {}
  local b={}
  for i,v in ipairs(a) do
    table.insert(b, fcn(v))
  end
  return b
end

function show(res)
  local html = '<html><head><title>Todo List</title></head><body>\n'
  .. '<h1>Todo List</h1>\n' 		-- For simple apps, inlining
  .. '<ul>\n' 						-- the HTML instead of
  .. table.concat(map(items, function(item) 	--using a template engine works well.
  return '<li>' .. item .. '</li>'
  end),'\n')
  .. '</ul>\n'
  .. '<form method="post" action="/todo">\n'
  .. '<p><input type="email" name="email" /></p>\n'
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
    parse.
    show(res);
  end);
end


-- ====================================================================
-- ====================================================================


local function onRequest(req, res, protocol)
  page.protocol = protocol
  page.sitepath = rootpath..'/content'
    print("IN http.createServer method=",req.method)

  if req.url=='/upload' then
    upload.handleUpload(req, res)
  elseif req.url=='/todo' then
    if req.method=='GET' then
      show(res)
    elseif req.method=='POST' then
      handlePOST(req, res)
    else
      badRequest(res)
    end
  else
    if req.method=='POST' then
      handlePOST(req, res)
    else
      body = srv.getBody(req, res)
      res:finish(body)
    end
  end
end


function handlePOST(req, res)
  local postQuery = '';
  --req.setEncoding('utf8');
  req:on('data', function(chunk) postQuery = postQuery .. chunk; end);
  req:on('end', function()
    local obj = qs.parse(postQuery);
    --p(obj)
    table.insert(items,obj.item);

    page.postQuery = utils.decodeURL(postQuery)
    print("IN handlePOST postQuery=",page.postQuery)
    page.postParams = utils.splitKV(page.postQuery, '&', '=')
    page.requestParams = page.postParams
    local json = utils.tostring(page.postParams)
    body = srv.getBody(req, res)
    res:setHeader('Content-Type', 'text/html');
    res:setHeader('Content-Length', #body);
    res:finish(body);
  end);
end


http.createServer(function(req,res)
  onRequest(req, res, 'http')
end):listen(80)


https.createServer({
  key = fs.readFileSync("/var/www/html/key.pem"),
  cert = fs.readFileSync("/var/www/html/cert.pem"),
}, function(req,res)
  onRequest(req,res,'https')
end):listen(443)


print("Server listening at https://localhost:443/")
print('Server running at http://localhost:80/')

