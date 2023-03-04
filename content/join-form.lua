-- login.lua

local srv = require'lws.srv'
local bootstrap = require'content.bootstrap'

srv.session.continue(srv.res)

local join_form = {}

local c = {}
c.author='jwrr'
c.body_class='text-center'
c.css_external='/styles/bootstrap/signin.css'
c.description='Join form for the LWServer'
c.please='Please Join'
c.title_site="LWServer"
c.title_navbar=c.title_site
c.title_page=c.title_site..' Join Page'

c.html = [[
<form class="form-signin" action="/join.html" method="post">
  <img class="mb-4" src="/images/lua30.gif" alt="" width="72" height="72">
  <h1 class="h3 mb-3 font-weight-normal">]] .. c.please .. [[</h1>
  <label for="inputUser" class="sr-only">Email address</label>
  <input type="user" name="user" id="inputUser" class="form-control" placeholder="Username" required autofocus>
  <label for="inputEmail" class="sr-only">Email address</label>
  <input type="email" name="email" id="inputEmail" class="form-control" placeholder="Email address" required>
  <label for="inputPassword" class="sr-only">Password</label>
  <input type="password" name="password"  id="inputPassword" class="form-control" placeholder="Password" required>
  <button class="btn btn-lg btn-primary btn-block" type="submit">Sign up</button>
  <p class="mt-5 mb-3 text-muted"><a href='/'>Home</a></p>
</form>
]]

join_form.getHTML = function()
  return bootstrap.getHTML(c)
end

return join_form

