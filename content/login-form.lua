-- login.lua

local srv = require'lws.srv'
local bootstrap = require'content.bootstrap'

srv.session.continue(srv.res)

local login = {}

local c = {}
c.author='jwrr'
c.description='Login page to sign out of the LWServer'
c.title_navbar='LWServer'
c.header2='Please log in'
c.title_page='LWServer Login Page'

c.html = [[
          <!-- signin form -->
          <main class="col border p-4 m-5 rounded">
            <h2>]]..c.header2..[[</h2>
            <p>Enjoy more features when logged in</p>
            <form action="/login" method="post">
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
              <a href='/join-form'>Join</a> 
            </p>
          </main>
]]

login.getHTML = function()
  return bootstrap.getHTML(c)
end

return login

