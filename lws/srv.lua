-- lws.srv.lua

local url = require'url'

local lcmark = require'lcmark'
local brotli = require'lws.brotli'
local page = require'lws.page'
local utils = require'lws.utils'
local err = require'lws.err'
local template = require'lws.template'
local mime = require'lws.mime'
local cookie = require'lws.cookie'
local session = require'lws.session'
local account = require'lws.account'
local err404 = require'content.err404'

local srv = {}

srv.session = session
srv.utils = utils

--------------------------------------------------------------------------

function srv.getBody(req, res)

  srv.res = res
  srv.req = req
  srv.page = page
  srv.account = account
  srv.template = template

  page.urlFields = page.getUrlFields(page.sitepath, req.url)
  local body = ''
  if page.urlFields.fileFound then
    page.headers = page.getHeaders(req)
    page.headerCookies = page.getCookies(page.headers['Cookie'])
    page.urlParts = url.parse(page.protocol .. '://' .. page.headers['Host'] .. req.url)
    page.getParams = page.getQuery()
    page.add("method", req.method)
    brotli.cache.enabled = false
    if brotli.cache.enabled and brotli.cache.hit() then
       body = brotli.cache.get(res)
    else
      local r = ''
      for i=1,10 do
        r = r .. utils.rand64(64) .. '\n'
      end
      local page_str = utils.tostring(page, 0, "page = ")
      local req_str = utils.tostring(req, 0, "req = ")
      local res_str = utils.tostring(res, 0, "res = ")
      local diag_str = page_str .. '\n\n\n' .. res_str .. '\n\n\n' .. req_str .. brotli.cache.tostring()
      diag_str = ''
      if page.urlFields.fileType == 'lua' then
        local tmp = dofile(page.urlFields.fullPathName)
        if type(tmp) == 'string' then
          body = dofile(page.urlFields.fullPathName) .. "\n" .. diag_str
        else
          body = tmp.getHTML()
        end
      elseif page.urlFields.fileType == 'html' then
        body = utils.slurp(page.urlFields.fullPathName) .. "\n" .. diag_str
      elseif page.urlFields.fileType == 'template' then
        body = template.run(page.urlFields.fullPathName, srv)
      elseif page.urlFields.fileType == 'md' then
        local markdownTemplateFile = page.sitepath .. '/templates/markdown.template'
        body = utils.slurp(page.urlFields.fullPathName)
        body = page.convertMarkdown(req, res, page.urlFields, markdownTemplateFile, body, srv)
      else
        body = utils.slurp(page.urlFields.fullPathName)
      end
--       if page.urlFields.fileType ~= 'lua' then
--         body = brotli.compressIfAccepted(res, body)
--       end
    end
  else
    print('IN srv: before err.handler. req.url=',req.url)
    body = err404.getHTML(srv)
--    err.handler(req, res, page.urlFields, 404, page.sitepath, srv)
  end
  mime.setHeader(res)
  res:setHeader('Content-Length', #body)

--   if page.isImage() then
--      res:setHeader('Cache-Control', 'max-age=30')
--   end

  return body
end

return srv

