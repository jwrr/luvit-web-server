jwrr/luvit-web-server/Dockerfile
================================

This Dockerfile makes a web server using Lua and Luvit. 
Luvit provides asynchronous I/O for Lua, similar to Node.js.

Place your new content into the `content` folder.

TLDR
----

`build-server` builds the docker container and `start-server` runs the 
container. `use-server` opens firefox to the server home page.

```bash
source scripts/server-aliases.sh
build-server
start-server
use-server
restart-server
server-status
stop-server
```


Luvit Links
-----------

* [Documentation](https://luvit.io/)
* [Github](https://github.com/luvit/luvit)
* [Coderwall](https://coderwall.com/p/gkokaw/luvit-node-s-ziggy-stardust)


Build Docker Image
------------------

```bash
## Set path to Dockerfile.  Here are two examples. The first is from github, 
## the second is current directory

## Build Docker Image
export DOCKER_IMAGE_TAG=jwrr/luvit-web-server
docker build -t $DOCKER_IMAGE_TAG .

## Verify image was built
docker images

Start and Run Docker Container
------------------------------

## Create and Start container from image
export DOCKER_CONTAINER_NAME=luvit1
export DOCKER_HOST_PORT=1337
export DOCKER_CONTAINER_PORT=1337
export DOCKER_CONTAINER_DIR=/var/www/html

docker run -d -p $DOCKER_HOST_PORT:$DOCKER_CONTAINER_PORT \
-v $PWD:$DOCKER_CONTAINER_DIR --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE_TAG

## Verify container is running
docker ps
```

As a side note, the syntax hightlighting css and js files are from highlight.js
and are hosted and served here by this luvit web server, shown in the head of
this html file.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>index.html - Home Page</title>
  <link rel="stylesheet" type="text/css" href="markdown.css">

<!--
  <link rel="stylesheet"
        href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/default.min.css">
  <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js"></script>
-->

  <link rel="stylesheet" href="/styles/highlight/default.min.css">
  <script src="/styles/highlight//highlight.min.js"></script>

  <script>hljs.initHighlightingOnLoad();</script>
</head>
<body>
```


Use Docker Container
--------------------

Using firefox access the container on port 1337. You should see a web page with
several image types and links.

```bash
firefox localhost:1337
```

Stop Docker Container
---------------------

```bash
## Stop container
docker stop $DOCKER_CONTAINER_NAME

## Verify container is on longer active, but that it exists
docker ps
docker ps -a
```

Remove Docker Container and Image
---------------------------------

```bash
## Remove Container
docker rm $DOCKER_CONTAINER_NAME

## Verify container has been removed
docker ps -a

## Remove Image
docker rmi $DOCKER_IMAGE_TAG

## Verify image has been removed
docker images
```

