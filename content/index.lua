-- -- index.lua

local srv=require'lws.srv'
local bootstrap = require'content.bootstrap'
local isLoggedIn = srv.session.continue(srv.res)
local index = {}

local c = {}
c.author='jwrr'
c.description='Index page for LWServer'
c.title_site="LWServer"
c.title_navbar=c.title_site
c.title_page='LWServer Home Page'
c.css_internal = 'body {padding-top:68px;} img {height:200px;}'

c.html = [[
<main class="col col-8 border p-3 rounded">
<h1>Lua and Luvit Example using Bootstrap</h1>
<p class="lead">
This site runs on <a href="https://luvit.io/">Luvit</a>.
Luvit is a reimplementation of
<a href="https://nodejs.org">node.js</a> for 
<a href="http://www.lua.org/">Lua</a>/<a href="https://luajit.org/">LuaJit</a>.
</p>

<p>If I had read the docs, instead of just diving in, then I would have 
found <a href="https://github.com/creationix/weblit">Weblit</a> which pretty 
much does everything I want.  I'm gonna keep plugging away at this project. 
But if you're interested in a good starting point for a Luvit-based web server,
take a look at Weblit. Best of luck.

<h2>Here are a few things that are supported</h2>

<h3>CSS & JavaScript</h3>
Typically Bootstrap CSS and JS files are served from a fast CDN to reduced load on a
website server. But for this example the Bootstrap CSS and Javacript files are
being server locally to demonstrate that CSS and JS files are supported.

<h3>Markdown</h3>
Markdown is supported using <a href="https://luarocks.org/modules/jgm/lcmark">lcmark</a>.
Here is an example, <a href="/examples/README.md">README.md</a>. Pages with the .md
extension are converted to html. 

<h3>Brotli Compression</h3>
<a href="https://github.com/google/brotli">Brotli Compression</a> is supported 
using <a href="https://luarocks.org/modules/witchu/lua-brotli">lua-brotli</a>. 
Brotli is a compression algorithm developed by Google to help  websites load 
faster. It is supported by major browsers and is considered the successor to gzip.
Brotli is useful for compressing static text files but not so much for images that
are already compressed.

<h3>SQLite Database</h3>
<a href="https://www.sqlite.org/index.html">SQLite3</a> is supported using <a href="https://luarocks.org/modules/tomasguisasola/luasql-sqlite3">
luasql-sqlite3</a>.  Here is an <a href="/examples/db.html">example database page</a>.

<h3>Password Hash</h3>
The <a href="https://github.com/p-h-c/phc-winner-argon2">Argon2</a> password hash is supported using
<a href="https://github.com/thibaultcha/lua-argon2">lua-argon2</a>.

<h3>Images</h3>
<p>GIF, PNG, JPG, SVG and ICO image formats are supported. Here are a few examples.</p>

<img src="/images/lua30.gif" alt="GIF image being served by Luvit">
<img src="/images/lua.png" alt="PNG image being served by Luvit">
<img src="/images/luvit.jpg" alt="JPG image being served by Luvit">
<br>
<img src="/images/logo.svg" alt="SVG image being served by Luvit">


<h2>More Examples</h2>
<ul>
<li><a href="/examples/test1.html">Link to test1.html</a></li>
<li><a href="/examples/test2.html">Link to test2.html</a></li>
<li><a href="/examples/README.md">Link to README.md. Markdown is converted to html.</a></li>
<li><a href="/examples/bootstrap-start.html">404 Not Found Example</a></li>
<li><a href="/blog.lua">Blog</a></li>
<li><a href="/examples/test3.lua">Link to test3.lua</a></li>
<li><a href="/examples/test3.html">Link to test3.html (should internally redirect to test3.lua)</a></li>
<li><a href="/examples/test4.template">Link to test4.template (templates do simple substutions)</a></li>
<li><a href="/examples/test4.html">Link to test4.html (should internally redirect to test4.template)</a></li>
<li><a href="/examples/signin-form.html">Link to sign-in form</a></li>
</ul>
</main>
]]

index.getHTML = function()
  return bootstrap.getHTML(c)
end

return index

