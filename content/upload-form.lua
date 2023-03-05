-- upload.lua

local srv = require'lws.srv'
local bootstrap = require'content.bootstrap'

srv.session.continue(srv.res)

local upload = {}

local c = {}
c.author='jwrr'
c.body_class='text-center'
c.css_external='/styles/bootstrap/signin.css'
c.description='upload page to sign out of the LWServer'
c.title_navbar="LWServer"
c.please='Please sign in'
c.title_page='LWServer upload Page'

c.html = [[

<form class="form-signin" action="/upload" method="post" enctype="multipart/form-data">
  <img class="mb-4" src="/images/lua30.gif" alt="" width="72" height="72">
  <h1 class="h3 mb-3 font-weight-normal">]] .. c.please .. [[</h1>
  <label for="inputUploader" class="sr-only">Uploader</label>
  <input type="file" name="uploader" id="inputUploader">
  <input type="submit">
  <p class="mt-5 mb-3 text-muted"><a href='/'>Home</a></p>
</form>
]]

upload.getHTML = function()
  return bootstrap.getHTML(c)
end

return upload

