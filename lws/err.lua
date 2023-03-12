-- lws.err.lua

local utils = require'lws.utils'
local template = require'lws.template'

local err = {}

function err.handler(req, res, urlFields, errCode, contentDir, srv)
  res.statusCode = errCode
  local errTemplate = contentDir .. '/templates/err' .. tostring(errCode) .. '.template'
  local html = template.replace(req, res, urlFields, errTemplate, srv)
  if html == '' then
    html = 'Error ' .. string(errCode) .. '\n'
  end
  return html
end

return err

