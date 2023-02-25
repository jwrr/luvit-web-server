-- lws.srv.lua

local url = require'url'

local lcmark = require'lcmark'
local brotli = require'lws.brotli'
local page = require'lws.page'
local utils = require'lws.utils'
local err = require'lws.err'
local template = require'lws.template'
local mime = require'lws.mime'
local cookies = require'lws.cookies'
local srv = {}


--------------------------------------------------------------------------

function srv.getBody(req, res)
  page.urlFields = page.getUrlFields(page.sitePath, req.url)
  local body = ''
  if page.urlFields.fileFound then
    page.headers = page.getHeaders(req)
    page.cookies = page.getCookies(page.headers['Cookie'])
    page.urlParts = url.parse(page.protocol .. '://' .. page.headers['Host'] .. req.url)
    page.getParams = page.getQuery()
    page.add("method", req.method)  
    if brotli.cache.hit() then
       body = brotli.cache.get(res)
    else
      local r = ''
      for i=1,10 do
        r = r .. utils.rand64(64) .. '\n'
      end
      local page_str = utils.tostring(page, 0, "page = ")
      local req_str = utils.tostring(req, 0, "req = ")
      local res_str = utils.tostring(res, 0, "res = ")
      local diag_str = r .. page_str .. '\n\n\n' .. res_str .. '\n\n\n' .. req_str .. brotli.cache.tostring()
      if page.urlFields.fileType == 'lua' then
        body = dofile(page.urlFields.fullPathName) .. "\n" .. diag_str
      elseif page.urlFields.fileType == 'html' then
        body = utils.slurp(page.urlFields.fullPathName) .. "\n" .. diag_str
      elseif page.urlFields.fileType == 'template' then
        body = template.replace(req, res, page.urlFields, page.urlFields.fullPathName)
      elseif page.urlFields.fileType == 'md' then
        local markdownTemplateFile = page.sitePath .. '/templates/markdown.template'
        body = utils.slurp(page.urlFields.fullPathName)
        body = page.convertMarkdown(req, res, page.urlFields, markdownTemplateFile, body)
      else
        body = utils.slurp(page.urlFields.fullPathName)
      end
      body = brotli.compressIfAccepted(res, body)
    end
  else
    body = err.handler(req, res, page.urlFields, 404, page.sitePath)
  end
  mime.setHeader(res)
  res:setHeader('Content-Length', #body)

  local sessionName = 'session'
--  if cookies.isSet(sessionName) then
    local sid = utils.rand64(64)
    cookies.set(sessionName, sid)
    res:setHeader('Set-Cookie', sessionName .. '=' .. sid .. '; secure;')
    res:setHeader('Set-Cookie', 'a=1')
    res:setHeader('Set-Cookie', 'b=2')
    res:setHeader('Set-Cookie', 'c=3')
--    res:setHeader('Set-Cookie', sessionName .. '=' .. sid .. '; secure; a=1; b=2; c=3')
--  end
  if page.isImage() then
     res:setHeader('Cache-Control', 'max-age=30')
  end
  return body
end

return srv

