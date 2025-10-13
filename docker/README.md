# Docker
> Practical exercises and tasks related to Docker performed during CSCE certification course. 

## Table of Contents
- [Docker](#docker)
  - [Table of Contents](#table-of-contents)
  - [Docker Installation](#docker-installation)
  - [Docker Commands](#docker-commands)
  - [Docker Compose](#docker-compose)

## Docker Installation

**Task**

Test Docker installation by running the "hello-world" container.

```bash
$ docker run hello-world
```

Display all running containers.

```bash
$ docker ps -a
CONTAINER ID   IMAGE                                 COMMAND                  CREATED          STATUS                      PORTS     NAMES
c38cde9e19f7   hello-world                           "/hello"                 51 seconds ago   Exited (0) 50 seconds ago             elated_yalow
```

Display all existing images.

```bash
$ docker images
REPOSITORY                    TAG       IMAGE ID       CREATED        SIZE
hello-world                   latest    1b44b5a3e06a   6 weeks ago    10.1kB
```

**Clean up**

```bash
docker stop 
docker rm c38cde9e19f7
```

## Docker Commands

**Task**

Dockerize a simple Node.js web application (available in [examples/simple](./examples/simple)) and run it in a docker container.

**Solution**

Build image and run container.

```bash
$ cd examples/simple
$ docker build -t node-app .
# Verify image creation
$ docker image ls
REPOSITORY                    TAG       IMAGE ID       CREATED          SIZE
node-app                      latest    353cea72f89c   11 seconds ago   142MB
```

Run Container with the created image.

```bash
$ docker run -p 3000:3000 node-app
Server running on http://localhost:3000
```

Verify the app.

```bash
$ curl http://localhost:3000
Hello World!
```

*Clean up*

```bash
# Get container ID
$ docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED         STATUS              PORTS                                         NAMES
0d522594cf85   node-app   "docker-entrypoint.s…"   2 minutes ago   Up About a minute   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp   upbeat_bhabha 
$ docker stop 0d522594cf85
$ docker rm 0d522594cf85
$ docker rmi node-app
```

## Docker Compose

**Task**

Run a multi-container application with a web server (Nginx) and a MariaDB database using Docker Compose. Manfiest file is available in [examples/multi-container](./examples/multi-container) directory.

**Solution**

Deploy the application.
```bash
$ cd examples/multi-container
$ docker compose up -d
[+] Running 4/4
 ✔ Network docker-compose-demo_default   Created                                                                                           0.0s
 ✔ Volume "docker-compose-demo_db_data"  Created                                                                                           0.0s
 ✔ Container docker-compose-demo-db-1    Started                                                                                           0.4s
 ✔ Container docker-compose-demo-web-1   Started
```

Check services.

```bash
$ docker compose ps
NAME                        IMAGE            COMMAND                  SERVICE   CREATED          STATUS          PORTS
docker-compose-demo-db-1    mariadb:latest   "docker-entrypoint.s…"   db        48 seconds ago   Up 47 seconds   3306/tcp
docker-compose-demo-web-1   nginx:latest     "/docker-entrypoint.…"   web       48 seconds ago   Up 47 seconds   0.0.0.0:80->80/tcp, [::]:80->80/tcp
```

View container logs.

```bash
$ docker compose logs
# Output omitted
```

Test the DB.

```bash
$ docker exec -it $(docker compose ps -q db) mariadb -uuser -ppassword mydb
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 3
Server version: 12.0.2-MariaDB-ubu2404 mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [mydb]> exit
Bye
```

Test web application.
```bash
$ curl localhost:80
Hello World!
```

*Clean up*

```bash
$ docker compose down -v
[+] Running 4/4
 ✔ Container docker-compose-demo-web-1  Removed                                                                                                        0.3s
 ✔ Container docker-compose-demo-db-1   Removed                                                                                                        0.5s
 ✔ Network docker-compose-demo_default  Removed                                                                                                        0.3s
 ✔ Volume docker-compose-demo_db_data   Removed                                                                                                        0.0s
```