-- login.lua

local srv = require'lws.srv'
local bootstrap = require'content.bootstrap'

local success = srv.session.start(srv.res)

local login = {}

local c = {}
c.author='jwrr'
c.body_class='' -- '''text-center'
c.css_external='' -- '''/styles/bootstrap/signin.css'
c.description='Login page to sign out of the LWServer'
c.title_navbar="LWServer"
c.please= success and 'Login Successful!' or 'Please try again'
c.title_page='LWServer Login Page'

c.html = [[
<form class="form-signin" action="/login.html" method="post">
  <img class="mb-4" src="/images/lua30.gif" alt="" width="72" height="72">
  <h1 class="h3 mb-3 font-weight-normal">]] .. c.please .. [[</h1>
  <label for="inputEmail" class="sr-only">Email address</label>
  <input type="email" name="email" id="inputEmail" class="form-control" placeholder="Email address" required autofocus>
  <label for="inputPassword" class="sr-only">Password</label>
  <input type="password" name="password"  id="inputPassword" class="form-control" placeholder="Password" required>
  <!--
  <div class="checkbox mb-3">
    <label>
      <input type="checkbox" value="remember-me"> Remember me
    </label>
  </div>
  -->
  <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
  <p class="mt-5 mb-3 text-muted">
    <a href='/'>Home</a> | 
    <a href='/join-form.html'>Join</a> 
  </p>
</form>
]]

c.html = [[
          <!-- signin form -->
          <main class="col border p-4 m-5 rounded">
            <h2>]]..c.please..[[</h2>
            <p>Enjoy more features when logged in</p>
            <form action="/login.html" method="post">
              <div class="mb-3">
                <label for="email-id" class="form-label">Email address</label>
                <input name="email" type="email" class="form-control" id="email-id" aria-describedby="email-help" placeholder="Email address" required autofocus>
                <div id="email-help" class="form-text">We'll never share your email with anyone else.</div>
              </div>
              <div class="mb-3">
                <label for="password-id" class="form-label">Password</label>
                <input name = "password" type="password" class="form-control" id="password-id" aria-describedby="password-help" placeholder="Password" required>
                <div id="password-help" class="form-text">Passwords are encrypted for better security.</div>
              </div>
              <!--
              <div class="form-check">
                <input type="checkbox" class="form-check-input" id="check1">
                <label name="remember" class="form-check-label" for="check1">Remember Me</label>
              </div>
              -->
              <button type="submit" class="btn btn-primary">Enter</button>
            </form>
            <p class="mt-3 text-muted">
              <a href='/'>Home</a> | 
              <a href='/join-form.html'>Join</a> 
            </p>
          </main>
]]

login.getHTML = function()
  return bootstrap.getHTML(c)
end

return login

