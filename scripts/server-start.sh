docker run -d -p 1337:1337 -p 8443:8443 -v .:/var/www/html --name luvit1 jwrr/luvit-web-server
sleep 1
docker ps
docker logs luvit1

