-- lws.template.lua

local utils = require'lws.utils'
local template = {}

function template.replace(req, res, urlFields, templateName, srv)
--   print("IN template.replace. srv="..utils.tostring(srv))
  local cfg = {
    page_url = urlFields.urlFileName,
    page_markdown = urlFields.markdown,
    date = utils.getDateUTC()
  }
  local html = utils.slurp(templateName)
  local matches = utils.getMatches(html, '{{(.-)}}')
  for m,cnt in pairs(matches) do
    local fromStr = '{{' .. m .. '}}'
    local toStr = cfg[m]
    if not toStr then
      local t = srv
      local dotkey = m
      toStr = utils.getTableStringFromDotKey(t, dotkey)
      if not toStr or toStr == 'nil' then toStr = '{{'..dotkey..'}}' end
    end
    html = html:gsub(fromStr, toStr, cnt)
  end
  return html
end

return template

