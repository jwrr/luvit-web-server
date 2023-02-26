
local bootstrap = {}

local main = {}

main.content = [[
<h1>Lua and Luvit Example using Bootstrap</h1>
<p class="lead">
I stumble upon <a href="https://luvit.io/">Luvit</a> while playing around with 
<a href="http://www.lua.org/">Lua</a>. Luvit is a reimplementation of
<a href="https://nodejs.org">node.js</a> for <a href="https://luajit.org/">LuaJit</a>.
</p>

<p>Luvit is pretty cool and this is my first stab at using it to make a 
website. If I had read the docs, instead of just diving in, then I would have 
found <a href="https://github.com/creationix/weblit">Weblit</a> which pretty 
much does everything I want.  I'm gonna keep plugging away at this project 
because that's the way I roll. But if you're interested in a good starting 
point for a Luvit-based web server, take a look at Weblit. Best of luck, JWRR.

<h2>Here are a few things that are supported</h2>

<h3>CSS & JavaScript</h3>
The Bootstrap CSS and Javacript files are being server locally with this server.

<h3>Markdown</h2>
Markdown is supported using <a href="https://luarocks.org/modules/jgm/lcmark">lcmark</a>.
Here is an example, <a href="/examples/README.md">README.md</a>. Pages with the .md
extension are converted to html. 

<h3>Brotli Compression</h3>
<a href="https://github.com/google/brotli">Brotli Compression</a> is supported 
using <a href="https://luarocks.org/modules/witchu/lua-brotli">lua-brotli</a>. 
Brotli is a compression algorithm developed by Google to help  websites load 
faster. It is supported by major browsers and is considered the successor to gzip.

<h3>SQLite Database</h3>
<a href="https://www.sqlite.org/index.html">SQLite3</a> is supported using <a href="https://luarocks.org/modules/tomasguisasola/luasql-sqlite3">
luasql-sqlite3</a>.  Here is an <a href="/examples/db.html">example database page</a>.

<h3>Images</h3>
<p>GIF, SVG, PNG, PNG and ICO image formats are supported. Here are a few examples.</p>
<img src="/images/lua30.gif" alt="GIF image being served by Luvit">
<img src="/images/logo.svg" alt="SVG image being served by Luvit">
<img src="/images/lua.png" alt="PNG image being served by Luvit">
<img src="/images/luvit.jpg" alt="JPG image being served by Luvit">



<h2>More Examples</h2>
<ul>
<li><a href="/examples/test1.html">Link to test1.html</a></li>
<li><a href="/examples/test2.html">Link to test2.html</a></li>
<li><a href="/examples/README.md">Link to README.md. Markdown is converted to html.</a></li>
<li><a href="/examples/bootstrap-start.html">404 Not Found Example</a></li>
<li><a href="/examples/bootstrap-blog.html">Link to bootstrap based blog.html</a></li>
<li><a href="/examples/test3.lua">Link to test3.lua</a></li>
<li><a href="/examples/test3.html">Link to test3.html (should internally redirect to test3.lua)</a></li>
<li><a href="/examples/test4.template">Link to test4.template (templates do simple substutions)</a></li>
<li><a href="/examples/test4.html">Link to test4.html (should internally redirect to test4.template)</a></li>
<li><a href="/examples/signin-form.html">Link to sign-in form</a></li>
</ul>

]]

local header = {}
header.title = 'Lua & Luvit Web Server'
header.description = 'This experimental project uses Lua and the Luvit asynchronous I/O library'
header.author = 'jwrr'
header.style = [[
  body {padding-top:65px;}
  img {max-width:300px;width:20%;}
]]

header.html = [[
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="]] .. header.description .. [[">
    <meta name="author" content="]]..header.author..[[">
    <link rel="icon" href="/favicon.ico">

    <title>]] .. header.title .. [[</title>

    <!-- Bootstrap core CSS -->
    <link href="/styles/bootstrap/bootstrap-4.1.3.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="starter-template.css" rel="stylesheet">
    <style>]] .. header.style .. [[</style>
    
  </head>
]]


local navbar = {}
navbar.title = 'LWServer'

navbar.html = [[
  <body>

    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
      <a class="navbar-brand" href="#">]] .. navbar.title  .. [[</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarsExampleDefault">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active"><a class="nav-link" href="/">Home <span class="sr-only">(current)</span></a></li>
          <li class="nav-item active"><a class="nav-link" href="/login-form.html">Login</a></li>
          <li class="nav-item active"><a class="nav-link" href="/join.html">Join</a></li>
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
        <form class="form-inline my-2 my-lg-0">
          <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search">
          <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
        </form>
      </div>
    </nav>
]]

main.html = [[
    <main role="main" class="container">

      <div class="starter-template">]] .. main.content .. [[

      </div>

    </main><!-- /.container -->
]]

local footer = {}
footer.html = [[
    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/styles/bootstrap/jquery-3.3.1.slim.min.js"></script>
    <script src="/styles/bootstrap/popper-1.14.3.min.js"></script>
    <script src="/styles/bootstrap/bootstrap-4.1.3.min.js"></script>
  </body>
</html>
]]


html = header.html .. navbar.html .. main.html .. footer.html

return html

