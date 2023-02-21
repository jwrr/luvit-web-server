-- lws.srv.lua

local url = require'url'

local lcmark = require'lcmark'
-- local cjson = require'cjson'
--local lunajson = require 'lunajson'
local utils = require'lws.utils'
local err = require'lws.err'
local template = require'lws.template'
local srv = {}

-------------------------------------------------------------------------
-- contentTypes

local contentTypes = {
  css = 'text/css',
  gif = 'image/gif',
  html = 'text/html',
  htm = 'text/html',
  jpg = 'image/jpeg',
  js  = 'text/javascript',
  lua = 'text/html',
  md  = 'text/html',
  png = 'image/x-png',
  svg = 'image/svg+xml',
  template = 'text/html',
  ttf = 'font/ttf',
  txt = 'text/plain'
}

function srv.getContentType(fileType)
  return contentTypes[fileType] or 'unknown'
end

-- Add custom http content-type
function srv.addContentType(fileType, contentType)
  contentTypes[fileType] = contentType
end

-------------------------------------------------------------------------


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

  local contentType = srv.getContentType(fileType)

  local processedOutput = {fileType = fileType, pathName = pathName, urlFileName = urlFileName, baseName = baseName,
  fullPathName = fullPathName, fileFound = fileFound, contentType = contentType }
  return processedOutput
end


function srv.convertMarkdown(req, res, urlFields, markdownTemplateFile, body)
  local middle, metadata = lcmark.convert(body, "html", {smart = true})
  urlFields.markdown = middle
  local html = template.replace(req, res, urlFields, markdownTemplateFile)
  return html
end


function srv.getBody(req, res, contentDir)
  local urlFields = srv.getUrlFields(contentDir, req.url)
  local body = ''
  if urlFields.fileFound then
    if urlFields.fileType == 'lua' then
      body = dofile(urlFields.fullPathName)
      -- local json_str = cjson.encode(req)
      local req_str = utils.tostring(req)
      local res_str = utils.tostring(req)
      local url_t = url.parse('https://' .. req.headers[1][2] .. req.url)
      local url_str = utils.tostring(url_t)
      body = body .. "\n" .. url_str .. '\n\n\n' .. res_str .. '\n\n\n' .. req_str
    elseif urlFields.fileType == 'template' then
      body = template.replace(req, res, urlFields, urlFields.fullPathName)
    elseif urlFields.fileType == 'md' then
      local markdownTemplateFile = contentDir .. '/templates/markdown.template'
      body = utils.slurp(urlFields.fullPathName)
      body = srv.convertMarkdown(req, res, urlFields, markdownTemplateFile, body)
    else
      body = utils.slurp(urlFields.fullPathName)
    end
  else
    body = err.handler(req, res, urlFields, 404, contentDir)
  end

  if urlFields.contentType ~= 'unknown' then
    res:setHeader('Content-Type', urlFields.contentType)
  end
  res:setHeader('Content-Length', #body)

  return body
end


return srv

