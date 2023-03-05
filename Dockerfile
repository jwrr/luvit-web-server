# Dockerfile for luvit server
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y clean
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential libreadline-dev libcmark-dev curl wget
RUN apt-get -y install libyaml-dev sqlite3 libsqlite3-dev lua5.1 luarocks
RUN apt-get -y install unzip vim emacs

## ==============================================================
RUN apt update -y --allow-unauthenticated
RUN apt install -y git
## # https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
## RUN apt-get -y install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
## RUN apt-get -y install asciidoc xmlto docbook2x
## RUN apt-get -y install install-info
## RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
## RUN tar -xf git-2.9.5.tar.gz
## WORKDIR git-2.9.5
## RUN make configure
## RUN ./configure --prefix=/usr
## RUN make all doc info
## RUN make install install-doc install-html install-info
## WORKDIR /

## ==============================================================
## INSTALL LUVIT
#RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
#RUN mv /lit /luvi /luvit /usr/local/bin

RUN git clone https://github.com/luvit/luvit.git --branch 2.18.1
WORKDIR luvit
RUN make
RUN mv lit luvi luvit /usr/local/bin
WORKDIR /



## ==============================================================
# INSTALL LUA 5.1 & LUAROCKS
## WORKDIR /var/local
## RUN wget http://www.lua.org/ftp/lua-5.1.5.tar.gz
## RUN tar zxvf lua-5.1.5.tar.gz
## WORKDIR /var/local/lua-5.1.5
## RUN make linux test
## RUN make install
##
## WORKDIR /var/local
## RUN wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
## RUN tar zxvf luarocks-3.8.0.tar.gz
## WORKDIR /var/local/luarocks-3.8.0
## RUN ./configure --with-lua-include=/usr/local/include
## RUN make
## RUN make install

## ==============================================================
# INSTALL ROCKS
RUN luarocks install luafilesystem
RUN luarocks install lpeg
RUN luarocks install cmark
RUN luarocks install lua-yaml
RUN luarocks install lcmark
# RUN luarocks install luasql-sqlite3
RUN apt-get -y install lua-sql-sqlite3
RUN luarocks install lua-brotli
RUN apt-get install argon2 libargon2-0-dev 
# RUN luarocks install argon2
RUN git clone --branch 3.0.1 https://github.com/thibaultcha/lua-argon2.git
WORKDIR lua-argon2
RUN make LUA_INCDIR=/usr/include/lua5.1 INST_LIBDIR=/usr/lib/x86_64-linux-gnu/lua/5.1
RUN make LUA_INCDIR=/usr/include/lua5.1 INST_LIBDIR=/usr/lib/x86_64-linux-gnu/lua/5.1 install


## ==============================================================
WORKDIR /var/www/html/
CMD ["/var/www/html/lws.lua"]

