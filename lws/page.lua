-- lws/page.lua

local lcmark=require'lcmark'
local utils=require'lws.utils'
local err=require'lws.err'
local template=require'lws.template'
local mime=require'lws.mime'
local password=require'lws.password'

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
    local v = q:gsub('[^=]email*=', '')
    q_t[k] = v
  end
  return q_t
end


function page.setPostParam(k, v)
  if not k then return end
  page.postParams[k] = v
end


function page.getPostParam(key)
  if page.postParams and page.postParams[key] then
    return page.postParams[key]
  end
  return nil
end


function page.getPostParams(format)
  print('IN page.getPostParams. format=',format)
  format = format or 'array'
  if format ~= 'array' then
    print('IN page.getPostParams, NOT ARRAY format=',format)
    if not page.postParams then return '' end
    print('IN page.getPostParams, postParams EXISTS format=',format)
    return utils.tostring(page.postParams, 0, 'parms=', format)
  end
  if not page.postParams then return {} end
  return page.postParams
end


function page.encodePassword()
  local pw = page.getPostParam('password')
  local email = page.getPostParam('email')
  if not pw or not email then return end
  local encodedPassword = password.encode(pw, email)
  page.setPostParam('password', encodedPassword)
end


function page.getPassword()
  return page.getPostParam(password)
end


function page.getUser()
  return page.user
end


function page.renameMissingFile(fileFound, fileType, fullPathName, baseName)
  if not fileFound then
    local fullPathNameLua = fullPathName:gsub('.html$', '') .. '.lua'
    local isLua = utils.fileExists(fullPathNameLua)
    local fullPathNameTemplate = fullPathName:gsub('.html$', '') .. '.template'
    local isTemplate = utils.fileExists(fullPathNameTemplate)
    if isLua then
      fileFound = true
      fileType = 'lua'
      fullPathName = fullPathNameLua
      baseName = fullPathName:gsub('.*/', '')
    elseif isTemplate then
      fileFound = true
      fileType = 'template'
      fullPathName = fullPathNameTemplate
      baseName = fullPathName:gsub('.*/', '')
    end
  end
  return fileFound, fileType, fullPathName, baseName
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

  fileFound, fileType, fullPathName, baseName = page.renameMissingFile(fileFound, fileType, fullPathName, baseName)

  local mime = mime.get(fileType)

  local processedOutput = {fileType = fileType, pathName = pathName, urlFileName = urlFileName, baseName = baseName,
  fullPathName = fullPathName, fileFound = fileFound, mime = mime }
  return processedOutput
end


function page.convertMarkdown(req, res, urlFields, markdownTemplateFile, body, srv)
  local middle, metadata = lcmark.convert(body, "html", {smart = true})
  urlFields.markdown = middle
  local html = template.run(markdownTemplateFile, srv)
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

