-- login.lua

local srv = require'lws.srv'
local bootstrap = require'content.bootstrap'

local success = srv.session.start(srv.res)

local login = {}

local c = {}
c.author='jwrr'
c.body_class='text-center'
c.css='/styles/bootstrap/signin.css'
c.description='Login page to sign out of the LWServer'
c.navbar_title='LWServer'
c.please= success and 'Success... you are logged in' or 'Please try again'
c.title='LWServer Login Page'

c.html = [[
<form class="form-signin" action="/login.html" method="post">
  <img class="mb-4" src="/images/lua30.gif" alt="" width="72" height="72">
  <h1 class="h3 mb-3 font-weight-normal">]] .. c.please .. [[</h1>
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

login.getHTML = function()
  return bootstrap.getHTML(c)
end

return login

