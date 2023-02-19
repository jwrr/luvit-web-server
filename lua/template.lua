-- template.lua

local utils = require'utils'
local template = {}

function template.replace(req, res, urlFields, templateName)
  local templateMap = {
    page_url = urlFields.urlFileName,
    page_markdown = urlFields.markdown
  }
  local html = utils.slurp(templateName)
  for fromStr,toStr in pairs(templateMap) do
      local fromStr = '{' .. fromStr .. '}'
      html = html:gsub(fromStr, toStr)
  end
  return html
end

return template

