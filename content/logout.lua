-- logout.lua

local page='lws.page'
local bootstrap = require'content.bootstrap'

local logout = {}

local c = {}
c.title='LWServer Logout Page'
c.author='jwrr'
c.description='Logout page to sign out of the LWServer'
c.css='/styles/bootstrap/signin.css'
c.css_hack='body {padding-top:65px;}'
c.body_class='text-center'
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

