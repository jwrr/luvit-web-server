-- lws/brotli.lua

local br = require'brotli'
local utils = require'lws.utils'
local page = require'lws.page'

local brotli = {}

-- {sessionid = {userid, creation, last, expire}}
brotli.cache = {}

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
    brotli.cache[page.url_t.path] = 1
    res:setHeader('Content-Encoding', 'br')
  end
  return body
end

function brotli.cache.tostring()
  return utils.tostring(brotli.cache, 0, 'brotlixxx = ')
end


return brotli




