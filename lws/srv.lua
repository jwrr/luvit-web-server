-- lws.srv.lua

local url = require'url'

local lcmark = require'lcmark'
local brotli = require'lws.brotli'
local page = require'lws.page'
local utils = require'lws.utils'
local err = require'lws.err'
local template = require'lws.template'
local mime = require'lws.mime'
local srv = {}


--------------------------------------------------------------------------


function srv.getUrlFields(rootDir, reqUrl)
  local urlFileName = reqUrl:gsub('%?.*', '')
  if urlFileName:sub(-1) == '/' then
    urlFileName = urlFileName .. 'index.html'
  end
  local baseName = urlFileName:gsub('.*%/', '')
  if not baseName:find('.') then
    baseName = 'index.html'
    urlFileName = urlfileName .. '/' .. baseName
  end
  local charToDelete = -(#baseName + 2)
  local pathName = urlFileName:sub(2, charToDelete)
  local fileType = baseName:gsub('.*%.', '')

  local fullPathName = rootDir .. urlFileName;
  local fileFound = utils.fileExists(fullPathName)

  local fullPathNameLua = fullPathName:gsub('.html$', '.lua')
  local isLua = not fileFound and utils.fileExists(fullPathNameLua)
  if isLua then
    fileFound = true
    fileType = 'lua'
    fullPathName = fullPathNameLua
    baseName = baseName:gsub('.html$', '.lua')
  end

  local fullPathNameTemplate = fullPathName:gsub('.html$', '.template')
  local isTemplate = not fileFound and utils.fileExists(fullPathNameTemplate)
  if isTemplate then
    fileFound = true
    fileType = 'template'
    fullPathName = fullPathNameTemplate
    baseName = baseName:gsub('.html$', '.template')
  end

  local mime = mime.get(fileType)

  local processedOutput = {fileType = fileType, pathName = pathName, urlFileName = urlFileName, baseName = baseName,
  fullPathName = fullPathName, fileFound = fileFound, mime = mime }
  return processedOutput
end


function srv.convertMarkdown(req, res, urlFields, markdownTemplateFile, body)
  local middle, metadata = lcmark.convert(body, "html", {smart = true})
  urlFields.markdown = middle
  local html = template.replace(req, res, urlFields, markdownTemplateFile)
  return html
end

function srv.getHeaders(req)
  local t = {}
  for i,h in ipairs(req.headers) do
    k = h[1]
    v = h[2]
    t[k] = v
  end
  return t
end

function srv.getQuery(query)
  query = query or page.url_t.query or ''
  local q_t = {}
  for q in string.gmatch(query, "[^&]+") do
    local k = q:gsub('=.*', '')
    local v = q:gsub('[^=]*=', '')
    q_t[k] = v
  end
  return q_t
end


function srv.getBody(req, res)
  page.urlFields = srv.getUrlFields(page.sitePath, req.url)
  local body = ''
  if page.urlFields.fileFound then
    page.headers_t = srv.getHeaders(req)
    page.url_t = url.parse(page.protocol .. '://' .. page.headers_t['Host'] .. req.url)
    page.get_t = srv.getQuery()
    page.add("method", req.method)  
    if brotli.cache.hit() then
       body = brotli.cache.get(res)
    else
      if page.urlFields.fileType == 'lua' then
        body = dofile(page.urlFields.fullPathName)
        local page_str = utils.tostring(page, 0, "page = ")
        local req_str = utils.tostring(req, 0, "req = ")
        local res_str = utils.tostring(res, 0, "res = ")
        local diag_str = page_str .. '\n\n\n' .. res_str .. '\n\n\n' .. req_str .. brotli.cache.tostring()
        body = body .. "\n" .. diag_str
      elseif page.urlFields.fileType == 'html' then
        body = utils.slurp(page.urlFields.fullPathName)
        local page_str = utils.tostring(page, 0, "page = ")
        local req_str = utils.tostring(req, 0, "req = ")
        local res_str = utils.tostring(res, 0, "res = ")
        local diag_str = page_str .. '\n\n\n' .. res_str .. '\n\n\n' .. req_str .. brotli.cache.tostring()
        body = body .. "\n" .. diag_str
      elseif page.urlFields.fileType == 'template' then
        body = template.replace(req, res, page.urlFields, page.urlFields.fullPathName)
      elseif page.urlFields.fileType == 'md' then
        local markdownTemplateFile = page.sitePath .. '/templates/markdown.template'
        body = utils.slurp(page.urlFields.fullPathName)
        body = srv.convertMarkdown(req, res, page.urlFields, markdownTemplateFile, body)
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

  return body
end


return srv

