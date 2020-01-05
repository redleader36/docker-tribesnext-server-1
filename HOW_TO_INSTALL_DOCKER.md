# Install Docker 
The official install docs are located here: https://docs.docker.com/install/linux/docker-ce/ubuntu/ 

*Please read the official install docs in their entirety before you run this automated install script*
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

After Docker has been installed, you need to init Docker Swarm
```
docker swarm init
```

Thats it!