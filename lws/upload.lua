-- upload.lua

local utils=require'lws.utils'

--[[
-----------------------------184124336541065743333443315844
Content-Disposition: form-data; name="uploader"; filename="README.md"
Content-Type: text/markdown

<!DOCTYPE html>
-----------------------------184124336541065743333443315844
Content-Disposition: form-data; name="title"

Image Name
-----------------------------184124336541065743333443315844
--]]

local upload = {}

function upload.parseMulti(s)
  t = {}
  t.uploads = {}
  t.uploadsCnt = 0
  t.barrier = ''
  if not s then return t end
  local State = { first=1, content=2, value=3, file=4 }
  local state = State.first
  local name = nil
  local filename = nil
  local contentType = nil
  for line in s:gmatch('.-\n') do
    print('IN parseUpload: state='..tostring(state))
    if state == State.first then
      if not utils.startsWith(line, '----', true) then
        t.err = 'Error: invalid barrier - ' .. line
        return t
      end
      t.barrier = utils.rtrim(line)
      print('IN parseUpload: barrier='..t.barrier)
      state = State.content
    elseif state == State.content then
      if utils.startsWith(line, 'Content-Disposition', true) then
        name = utils.getValue(line, ' name')
        if not name then
          t.err = "Error: Content-Disposition does not have a name - "..line
          return t
        end
        filename = utils.getValue(line, 'filename')
        if name=='uploader' and not filename then
          t.err = "Error: Content-Disposition named 'uploader' does not have a filename - "..line
          return t
        end
        if filename then
          t.uploadsCnt = t.uploadsCnt + 1
          print('filename exists filename ='..filename)
          t.uploads[t.uploadsCnt] = {}
          t.uploads[t.uploadsCnt].filename = filename
          t.uploads[t.uploadsCnt].data = ''
        else
          t[name] = ''
        end
      elseif utils.startsWith(line, 'Content-Type', true) then
        contentType = utils.lastWord(utils.rtrim(line))
        if not contentType then
          t.err = "Error: Content-Type missing the type value - "..line
          return t
        end
        t.uploads[t.uploadsCnt].contentType = contentType
      elseif utils.isBlank(line) then
        if not name then
          t.err = "Error: Blank line found before Content-Disposition"
          return t
        end
        if filename then
          state = State.file
        else
          state = State.value
        end
      end
    elseif state == State.value then
      print("NAME="..name)
      if utils.startsWith(line, t.barrier) then
        t[name] = utils.rtrim(t[name])
        state = State.content
      else
        t[name] = t[name] .. line
      end
    elseif state == State.file then
      if utils.startsWith(line, t.barrier) then
        t.uploads[t.uploadsCnt].data = utils.removeCRLF(t.uploads[t.uploadsCnt].data)      
        state = State.content
      else
        t.uploads[t.uploadsCnt].data = t.uploads[t.uploadsCnt].data .. line
      end
    end
  end
  return t
end


function upload.handleUpload(req, res)
  local uploadfile = '';
  --req.setEncoding('utf8');
  req:on('data', function(chunk) uploadfile = uploadfile .. chunk .. "xxx" end);
  req:on('end', function()
    local t = upload.parseMulti(uploadfile)
    print(utils.tostring(t,0,'uploadfile = ', 'json', {data=1}))

    for i,v in ipairs(t.uploads) do
      utils.writeFile('/var/www/html/uploads/'..v.filename, v.data)
    end
--     utils.writeFile('/var/www/html/uploads/'..t.uploads[1].filename', t.uploads[1].data)
    body = "upload complete"
    res:setHeader('Content-Type', 'text/html');
    res:setHeader('Content-Length', #body);
    res:finish(body);
  end);
end

return upload

