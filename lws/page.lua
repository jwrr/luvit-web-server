-- lws/page.lua


page = {}


function page.add(k, v)
  page[k] = v
end

-- function page.init(req)
--
--       page.headers = srv.getHeaders(req)
--       page.url_t = url.parse(page.protocol .. '://' .. page.headers['Host'] .. req.url)
--       page.query_t = srv.getQuery()
--       page.add("method", req.method)
--
--
-- end

return page

