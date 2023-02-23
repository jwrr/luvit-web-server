-------------------------------------------------------------------------
-- mimeTypes

local page = require'lws.page'

local mime = {}

mime.types = {
  css = 'text/css',
  gif = 'image/gif',
  html = 'text/html',
  htm = 'text/html',
  ico = 'image/x-icon',
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

function mime.get(extension)
  return mime.types[extension] or 'unknown'
end

-- Add custom mime
function mime.insert(extension, mime)
  mime.types[extension] = mime
end

function mime.setHeader(res)  
  if page.urlFields.mime ~= 'unknown' then
    res:setHeader('Content-Type', page.urlFields.mime)
  end
end

return mime




