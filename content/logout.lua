-- logout.lua

local srv=require'lws.srv'
local bootstrap = require'content.bootstrap'

local logout = {}

srv.session.stop(srv.res)

local c = {}
c.author='jwrr'
c.body_class='text-center'
c.css='/styles/bootstrap/signin.css'
c.description='Logout page to sign out of the LWServer'
c.navbar_title='LWServer'
c.please= 'Please log in'
c.title='LWServer Login Page'


c.html = [[
<form class="form-signin" action="/login.html" method="get">
  <img class="mb-4" src="/images/lua30.gif" alt="" width="72" height="72">
  <h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>
  <label for="inputEmail" class="sr-only">Email address</label>
  <input type="email" id="inputEmail" class="form-control" placeholder="Email address" required autofocus>
  <label for="inputPassword" class="sr-only">Password</label>
  <input type="password" id="inputPassword" class="form-control" placeholder="Password" required>
  <div class="checkbox mb-3">
    <label>
      <input type="checkbox" value="remember-me"> Remember me
    </label>
  </div>
  <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
  <p class="mt-5 mb-3 text-muted"><a href='/'>Home</a></p>
</form>
]]

logout.getHTML = function()
  return bootstrap.getHTML(c)
end

return logout

