This project has been created as part of the 42 curriculum by jpflegha

# Inception

## Description
Inception is a project about learning how to use Docker to build and manage a small server infrastructure. The goal is to run multiple services (like a web server and a database) in separate containers and make them work together using Docker Compose.

Each service runs in its own isolated environment, which makes the system more organized and easier to manage. The project also focuses on basic concepts like networking between containers, data persistence, and simple security setup.

By doing this project, you understand how modern applications are deployed and how container-based systems work.
---

## Instructions:
### Requirements
Make sure you have installed:
** Docker
** Docker Compose

if you use a distor without GUI, you maybe also install:
** w3m
makes a html in the terminal, readable.

### Installation
Clone  the repository and go into the folder:

```bash
git clone https://github.com/Lumelig/inception.git
cd inception
```

### Setup
Befor running the project, you need to:
** Configure a .env file withe the enviroment variables (there is a example.env with the empty variables)
** Make sure the required ports are available
** Check path for volumes

### Execution
Build and start the containers:
```bash
make
```
all other commands:
```bash
#Stop containers:
make down

#Stop containers and remove the images
make clean

#Stop and Remove volumes and network settings
make fclean

#Stops, Removes and Start again
make re

#Shows the logs
make lage <docker_name>
```

### Notes
** Data is stored using Docker volumes to keep it persistent
** Containers are automatically connected through a custem network




Resources

Virtual Machines vs Docker
◦ Secrets vs Environment Variables
◦ Docker Network vs Host Network
◦ Docker Volumes vs Bind Mounts

w3m -o ssl_verify_server=0 https://localhost:443