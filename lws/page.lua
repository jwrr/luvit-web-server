-- lws/page.lua

local lcmark = require'lcmark'
local utils = require'lws.utils'
local err = require'lws.err'
local template = require'lws.template'
local mime = require'lws.mime'

page = {}

function page.add(k, v)
  page[k] = v
end

function page.getMime()
  return page.urlFields.mime
end


function page.isImage()
  if string.find(page.getMime(), 'image') then
    return true
  else
    return false
  end
end


function page.getQuery(query)
  query = query or page.urlParts.query or ''
  local q_t = {}
  for q in string.gmatch(query, "[^&]+") do
    local k = q:gsub('=.*', '')
    local v = q:gsub('[^=]*=', '')
    q_t[k] = v
  end
  return q_t
end


function page.getPostParam(key)
  if page.postParams and page.postParams[key] then
    return page.postParams[key]
  end
  return nil
end


function page.getUrlFields(rootDir, reqUrl)
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


function page.convertMarkdown(req, res, urlFields, markdownTemplateFile, body)
  local middle, metadata = lcmark.convert(body, "html", {smart = true})
  urlFields.markdown = middle
  local html = template.replace(req, res, urlFields, markdownTemplateFile)
  return html
end

function page.getHeaders(req)
  local t = {}
  if req.headers then
    for i,h in ipairs(req.headers) do
      k = h[1]
      v = h[2]
      t[k] = v
    end
  end
  return t
end



function page.getCookies(cookieString)
  return utils.splitKV(cookieString)
end


-- function page.init(req)
--
--       page.headers = page.getHeaders(req)
--       page.urlParts = url.parse(page.protocol .. '://' .. page.headers['Host'] .. req.url)
--       page.query_t = page.getQuery()
--       page.add("method", req.method)
--
--
-- end

return page

