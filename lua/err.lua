-- err.lua

local utils = require'utils'
local template = require'template'

local err = {}

function err.handler(req, res, urlFields, errCode, contentDir)
  res.statusCode = errCode
  local errTemplate = contentDir .. '/templates/err' .. tostring(errCode) .. '.template'
  local html = template.replace(req, res, urlFields, errTemplate)
  if html == '' then
    html = 'Error ' .. string(errCode) .. '\n'
  end
  return html
end

return err

