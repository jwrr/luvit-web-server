alias docker='sudo docker'
alias server-build='docker build -t jwrr/luvit-web-server .'
alias server-start='source scripts/server-start.sh'
alias server-use='firefox localhost:1337'
alias server-restart='source scripts/server-restart.sh'
alias server-stop='docker rm -f `docker ps -aq` && docker ps -a'
alias server-status='docker ps -a && docker ps'
alias server-bash='docker exec -it luvit1 bash'
alias server-log='docker logs luvit1'
alias server-logs='docker logs luvit1'


