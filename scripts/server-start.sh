docker run -d -p 80:80 -p 443:443 -v .:/var/www/html --name luvit1 jwrr/luvit-web-server
sleep 1
docker ps
docker logs luvit1

