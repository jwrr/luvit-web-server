# Dockerfile for luvit server
FROM ubuntu:20.04
RUN apt-get -y clean
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential libreadline-dev libcmark-dev lua5.1 curl wget unzip
RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
RUN mv /lit /luvi /luvit /usr/local/bin

# INSTALL LUA 5.1 & LUAROCKS
WORKDIR /var/local
RUN wget http://www.lua.org/ftp/lua-5.1.5.tar.gz
RUN tar zxvf lua-5.1.5.tar.gz
WORKDIR /var/local/lua-5.1.5
RUN make linux test
RUN make install

WORKDIR /var/local
RUN wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
RUN tar zxvf luarocks-3.8.0.tar.gz
WORKDIR /var/local/luarocks-3.8.0
RUN ./configure --with-lua-include=/usr/local/include
RUN make
RUN make install

# INSTALL ROCKS
RUN luarocks install luafilesystem
RUN luarocks install lpeg
RUN luarocks install cmark
RUN apt-get -y install libyaml-dev
RUN luarocks install lua-yaml
RUN luarocks install lcmark

CMD ["/var/www/html/createServer.lua"]

