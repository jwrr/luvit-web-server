-- lws.template.lua

local utils = require'lws.utils'
local template = {}


function template.getDefaults(s)
--   local json = utils.getMatch(s, '%s*{(.-)\n}' )
  local json = utils.getMatch(s, '%b{}' )
  json = utils.trim(json, '[%s{}]')
  local removeQuotes = true
  local defaults, cnt = utils.splitKV(json, ',', ':', removeQuotes)
  if cnt > 0 then
    s = s:gsub('%b{}', '', 1)
  end
  s = utils.ltrim(s)
  return defaults, s
end


function template.run(templateName, srv, overrides, depth)
  if not templateName then return '' end
  depth = depth or 0
  if depth > 5 then return "TEMPLATE DEPTH LIMIT EXCEEDED" end

  srv = srv or {}
  overrides = overrides or {}

  local html = utils.slurp(templateName)
  local defaults, html = template.getDefaults(html)
  local matches = utils.getMatchesAndCnt(html, '{{(.-)}}')
  for m,cnt in pairs(matches) do
    local fromStr = '{{' .. m .. '}}'
    local toStr = ''
    if utils.startsWith(m, '>', true) then
      local filetag = utils.trim(m,'>')
      local tempname = overrides[filetag] or defaults[filetag] or 'undefined'
      tempname = page.sitepath .. '/templates/'.. tempname
      toStr = template.run(tempname, srv, overrides, depth+1)
      if not toStr or toStr=='' then 
        toStr = "Missing template for '"..filetag.."' = '"..tempname.."'"
      end
    else
      toStr = overrides[m] or defaults[m]
      if not toStr then
        local t = srv
        local dotkey = m
        toStr = utils.getTableStringFromDotKey(t, dotkey)
        if not toStr or toStr == 'nil' then toStr = '{{'..dotkey..' not found}}' end
      end
    end
    toStr = toStr:find("%", 1, true) and '' or toStr 
    html = html:gsub(fromStr, toStr, cnt)
  end
  return html
end

return template

