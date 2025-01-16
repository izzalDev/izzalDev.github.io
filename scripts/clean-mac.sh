clean-docker(){
    open -a docker
    docker kill $(docker ps -q)
    docker rmi $(docker images -q) -f
    docker volume rm $(docker volume ls -q)
    docker builder prune -a --force
    docker system prune -af
    sudo pkill docker
    
}

clean-docker