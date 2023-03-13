-- bootstrap.lua

local srv = require'lws.srv'

local bootstrap = {}

local initContent = function(c)
  c = c or {}
  c.author = c.author or ''
  c.body_class = c.body_class and ' class='..c.body_class or ''
  c.css_external = c.css_external and '<link href="'..c.css_external..'" rel="stylesheet">\n' or ''
  c.css_internal = c.css_internal or 'body {padding-top:68px;}'
  c.css_internal = '<style>'..c.css_internal..'</style>\n'
  c.description = c.description or ''
  c.html = c.html or ''
  c.scrolling_navbar = c.scrolling_navbar or false
  c.title_navbar = c.title_navbar or 'Navbar'
  c.title_page = c.title_page or ''
  c.title_site = c.title_site or ''
  c.email = srv.session.getUser()
  c.user = srv.utils.getNth(c.email, '@', 1) or 'Guest'
  c.isLoggedIn = srv.session.isLoggedIn()
  return c
end


bootstrap.getHeader = function(c)
  c = initContent(c)

  return [[
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom styles -->
    ]] .. c.css_external .. [[
    ]] .. c.css_internal .. [[
  </head>
  <body>
]]
end


bootstrap.getNavbarFixed = function(c)
  c = initContent(c)
  local loginRelatedLinks = ''
  if c.isLoggedIn then
    loginRelatedLinks = [[
          <li class="nav-item"><a class="nav-link active" aria-current="page" href="/]]..c.user..[[">]]..c.user..[[</a></li>
          <li class="nav-item"><a class="nav-link active" href="/logout">Logout</a></li>
          <li class="nav-item"><a class="nav-link active" href="#">Like</a></li>
          <li class="nav-item"><a class="nav-link active" href="#">Comment</a></li>
    ]]
  else
    loginRelatedLinks = [[
          <li class="nav-item"><a class="nav-link active" href="/login-form">Login</a></li>
          <li class="nav-item"><a class="nav-link active" href="/join-form">Join</a></li>
          <li class="nav-item"><a class="nav-link disabled" href="#">Like</a></li>
          <li class="nav-item"><a class="nav-link disabled" href="#">Comment</a></li>
    ]]
  end

  return [[
    <!-- fixed navbar -->
    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
          <a class="navbar-brand" href="/">LWServer</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle +
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto">
              ]]..loginRelatedLinks..[[
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Manage</a>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item disabled" href="/upload-form">New</a></li>
                  <li><a class="dropdown-item disabled" href="/edit-form">Edit</a></li>
                  <li><hr class="dropdown-divider" Disabled></li>
                  <li><a class="dropdown-item disabled" href="/join-form" disabled>Update Account</a></li>
                </ul>
              </li>
            </ul>
            <form class="d-flex" role="search">
              <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
              <button class="btn btn-outline-success" type="submit">Search</button>
            </form>
          </div>
        </div>
    </nav>
]]
end


bootstrap.getNavbarScrolling = function(c)
if not c.scrolling_navbar then return '' end
return [[
  <!-- Navbar Scrolling -->
  <header class="container blog-header py-3">
    <div class="row flex-nowrap justify-content-between align-items-center">
      <div class="col-4 pt-1">
        <a class="text-muted" href="#">Subscribe</a>
      </div>
      <div class="col-4 text-center">
        <a class="blog-header-logo text-dark" href="#">]] .. c.title_site .. [[</a>
      </div>
      <div class="col-4 d-flex justify-content-end align-items-center">
        <a class="text-muted" href="#">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"
          stroke-width="2" class="mx-3" role="img" viewBox="0 0 24 24" focusable="false"><title>Search</title><circle cx="10.5" cy="10.5" r="7.5"/><path d="M21 21l-5.2-5.2"/></svg>
        </a>
        <a class="btn btn-sm btn-outline-secondary" href="#">Sign up</a>
      </div>
    </div>
  </header>
]]
end


bootstrap.getBanner = function(c)
return [[
    <!-- dismissable banner -->
    <div class="container-fluid p-0 border-0 alert alert-dismissible">
        <button class="btn-close bg-light" aria-label="close" data-bs-dismiss="alert"></button>
        <img src="./images/banner.jpg" alt="Dismissable Banner" class="w-100">
    </div>
]]
end


bootstrap.getMain = function(c)
  c = initContent(c)

  return [[
    <div class="container">
      <div class="row">
          ]] .. c.html .. [[
          <aside class="col col-2 border-start d-none d-md-flex alert alert-dismissible" style="max-width:300px;min-width:300px;">
              <button class="btn-close bg-white" aria-label="close" data-bs-dismiss="alert"></button>
              Sidebar
          </aside>
      </div>
    </div>
]]
end


bootstrap.getFooter = function(c)
  c = initContent(c)
  return [[
  </body>
</html>
]]

end

bootstrap.getHTML = function(c)
  return bootstrap.getHeader(c) ..
        bootstrap.getNavbarFixed(c) ..
        bootstrap.getNavbarScrolling(c) ..
         bootstrap.getMain(c) ..
         bootstrap.getFooter(c)
end -- getHTML

return bootstrap

