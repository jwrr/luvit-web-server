local db = require'db'
local dbStr = db.get('asdf')

local html = "<table><tr><td>" .. dbStr
html = html:gsub('\n', '</td></tr>\n<tr><td>')
html = html:gsub(' | ', '</td><td>')
html = html .. '</td></tr>\n</table>'
html = html:gsub('table>', 'table>\n')
html = html:gsub('<tr><td></td></tr>\n', '')

return "hello from db. dbStr=\n" .. html

