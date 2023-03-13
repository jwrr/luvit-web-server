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
c.header2='Image Upload Form'
c.title_page='LWServer upload Page'

c.html = [[

<form  action="/upload" method="post" enctype="multipart/form-data">
  <img class="mb-4" src="/images/lua30.gif" alt="" width="72" height="72">
  <h1 class="h3 mb-3 font-weight-normal">]] .. c.header2 .. [[</h1>
  <label for="inputUploader" class="sr-only">Uploader</label>

  <div class="form-group">
    <label for="titleText">Title</label>
    <input type="text" class="titleText" id="exampleInputPassword1" value="Image Name" name="title" >
  </div>

  <div class="form-group">
    <label for="formFileLg" class="form-label">Select image to upload</label>
    <input class="form-control form-control-lg" id="formFileLg" type="file" name="uploader">
  </div>

  <div class="form-group">
    <label for="descriptionTextarea">Description</label>
    <textarea class="form-control" id="descriptionTextarea" rows="5" name="description">Description of image.</textarea>
  </div>
  <button type="submit" class="btn btn-primary">Upload</button>
  <p class="mt-5 mb-3 text-muted"><a href='/'>Home</a></p>
</form>
]]

upload.getHTML = function()
  return bootstrap.getHTML(c)
end

return upload

