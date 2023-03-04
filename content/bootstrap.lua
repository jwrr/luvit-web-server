-- bootstrap.lua

local srv = require'lws.srv'

local bootstrap = {}

local initContent = function(c)
  c = c or {}
  c.author = c.author or ''
  c.body_class = c.body_class and ' class='..c.body_class or ''
  c.css_external = c.css_external and '<link href="'..c.css_external..'" rel="stylesheet">\n' or ''
  c.css_internal = c.css_internal or ''
  c.css_hack = c.css_hack or 'body {padding-top:65px;}' or ''
  if c.css_hack ~= '' then
    c.css_hack = '<style>'..c.css_hack..'</style>'
  end
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
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="]]..c.description..[[">
    <meta name="author" content="]]..c.author..[[">
    <link rel="icon" href="/favicon.ico">

    <title>]]..c.title_page..[[</title>

    <!-- Bootstrap core CSS -->
    <link href="/styles/bootstrap/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    ]] .. c.css_external .. [[
    ]] .. c.css_hack .. [[
    ]] .. c.css_internal .. [[


  </head>

  <body]]..c.body_class..[[>
]]
end


bootstrap.getNavbarFixed = function(c)
  c = initContent(c)
  local loginRelatedLinks = ''
  if c.isLoggedIn then
    loginRelatedLinks = [[
          <li class="nav-item active"><a class="nav-link" href="/logout.html">Logout</a></li>
    ]]
  else
    loginRelatedLinks = [[
          <li class="nav-item active"><a class="nav-link" href="/login-form.html">Login</a></li>
          <li class="nav-item active"><a class="nav-link" href="/join-form.html">Join</a></li>
    ]]
  end

  return [[
    <!-- Navbar fixed -->
    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
      <a class="navbar-brand" href="#">]]..c.title_navbar..[[</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false"
        aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarsExampleDefault">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active"><a class="nav-link" href="/">Home <span class="sr-only">(current)</span></a></li>]]
          .. loginRelatedLinks .. [[
          <li class="nav-item"><a class="nav-link disabled" href="#">Comment</a></li>
          <li class="nav-item"><a class="nav-link disabled" href="#">Like</a></li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="http://example.com" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Manage</a>
            <div class="dropdown-menu" aria-labelledby="dropdown01">
              <a class="dropdown-item" href="#">Upload</a>
              <a class="dropdown-item" href="#">Edit</a>
              <a class="dropdown-item" href="#">Delete</a>
            </div>
          </li>
        </ul>
        <li class="nav-item active"><a class="nav-link" href="#">]]..c.user..[[<span class="sr-only">(current)</span></a></li>
        <form class="form-inline my-2 my-lg-0">
          <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search">
          <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
        </form>
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


bootstrap.getMain = function(c)
  c = initContent(c)
  return [[
    <!-- Main Container -->
    <main class="container">
      <div class="starter-template">
      ]] .. c.html .. [[
      </div>
    </main>
]]
end


bootstrap.getFooter = function(c)
  c = initContent(c)
  return [[
    <!-- Footer
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery-slim.min.js"><\/script>')</script>
    <script src="../../assets/js/vendor/popper.min.js"></script>
    <script src="../../dist/js/bootstrap.min.js"></script>
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
