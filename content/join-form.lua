-- login.lua

local srv = require'lws.srv'
local bootstrap = require'content.bootstrap'

srv.session.continue(srv.res)

local join_form = {}

local c = {}
c.author='jwrr'
c.description='Join form for the LWServer'
c.header2='Hello and welcome'
c.title_site="LWServer"
c.title_navbar=c.title_site
c.title_page=c.title_site..' Join Form Page'

c.html = [[
          <!-- signin form -->
          <main class="col border p-4 m-5 rounded">
            <h2>]]..c.header2..[[</h2>
            <p>Enjoy more features when logged in</p>
            <form action="/join" method="post">
              <div class="mb-3">
                <label for="user-id" class="form-label">Username</label>
                <input name="user" type="text" class="form-control" id="user-id" aria-describedby="user-help" placeholder="Your Name" required autofocus>
                <div id="user-help" class="form-text">Please enter your name, or nickname or any identifier you wish to go by.</div>
              </div>
              <div class="mb-3">
                <label for="email-id" class="form-label">Email address</label>
                <input name="email" type="email" class="form-control" id="email-id" aria-describedby="email-help" placeholder="Email address" required autofocus>
                <div id="email-help" class="form-text">We'll never share your email with anyone else.</div>
              </div>
              <div class="mb-3">
                <label for="password-id" class="form-label">Password</label>
                <input name = "password" type="password" class="form-control" id="password-id" aria-describedby="password-help" placeholder="Password" required>
                <div id="password-help" class="form-text">Passwords are encoded for better security.</div>
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
            <p>
              We don't use <a href="https://allaboutcookies.org/">cookies</a> 
              while you're not logged in. But after you log in we need to 
              use cookies to authenticate that you're really you.  And when you 
              log out we erase the cookie.  We do not sell or share information 
              gathered from the cookies. We value privacy so we collect and keep 
              as little data about you as we can... just enough for maintenance, 
              performance and security. Enjoy the site.
            </p>
          </main>
]]


join_form.getHTML = function()
  return bootstrap.getHTML(c)
end

return join_form

