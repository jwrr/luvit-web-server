-- lws/brotli.lua

local br = require'brotli'
local utils = require'lws.utils'
local page = require'lws.page'

local brotli = {}

-- {sessionid = {userid, creation, last, expire}}
brotli.cache = { a = '1', b='2', c='3'}
brotli.cache.path = '/var/www/html/cache'

function brotli.cache.tostring()
  return utils.tostring(brotli.cache, 0, 'brotlixxx = ')
end

function brotli.cache.add(body, url)
  body = body or ''
  url = url or page.urlFields.urlFileName or 'undefined'
  if url ~= 'undefined' then
    local filename = brotli.cache.path .. '/' .. url:gsub('/', '+')
    local f = io.open(filename, "w")
    f:write(body)
    f:close()
    brotli.cache[url] = filename
  end
end

function brotli.cache.hit(url)
  url = url or page.urlFields.urlFileName or 'undefined'
  return brotli.cache[url] and true or false
end

function brotli.cache.get(res, url)
  url = url or page.urlFields.urlFileName or 'undefined'
  local filename = brotli.cache[url]
  res:setHeader('Content-Encoding', 'br')
  return utils.slurp(filename)
end

function brotli.accepted(headerString) 
  if (page and page.headers_t and page.headers_t['Accept-Encoding']) then
    return page.headers_t['Accept-Encoding']:find('br') and true or false;
  end
  return false
end

brotli.compress = br.compress


function brotli.compressIfAccepted(res, body)
  if brotli.accepted() then
    body = brotli.compress(body)
    res:setHeader('Content-Encoding', 'br')
  end
  brotli.cache.add(body)
  return body
end


return brotli




