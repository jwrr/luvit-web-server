-- login-form.lua

local srv = require'lws.srv'
local template = srv.template

srv.session.continue(srv.res)

local login = {}

login.getHTML = function()
  local cfg = {
    title         = "Login Page",
    description   = "Welcome to our site. This is the Login page.",
    author        = "JWRR",
    main_template = "login.template",
    header        = "Please log in",
    subheader     = "Enjoy more features when logged in",
    action        = "/login",
    home_url      = "/",
    home_txt      = "Home",
    join_url      = "/join-form",
    join_txt      = "Join"
  }
  return template.run(srv.page.sitepath..'/templates/page.template', srv, cfg)
end

return login

