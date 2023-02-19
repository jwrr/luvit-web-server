docker rm -f `docker ps -aq` && docker run -d -p  1337:1337 -v .:/var/www/html --name luvit1 jwrr/luvit-web-server
sleep 1
docker ps
docker logs luvit1

