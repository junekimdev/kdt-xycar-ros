# Xycar-ROS in Docker

Containerized Xycar-ROS for [Programmers Autonomous Drive Dev Course](https://school.programmers.co.kr/learn/courses/14966)

<p align="center">
<img src="PRGMS-Atonomous-Driving-Dev-4.png" alt="school logo" width="50%"/>
</p>

## Table of Contents

1. [Prerequisites](#prerequisites)
1. [How to Build](#how-to-build)
1. [How to Use](#how-to-use)
1. [How to Stop](#how-to-stop)
1. [Authors](#authors)
1. [License](#license)

---

## Prerequisites

1. You need `docker-engine` installed in your machine
1. You need `docker-compose` installed in your machine

refer: <https://docs.docker.com/engine/install/>

> If you installed `docker-desktop`, which includes both packages, you are good to go!

---

## How to Build

In order to run Xycar-ROS, you need to build docker image first.

### 1. Move to your workspace 📂

example:

```shell
cd ~/kdt_practice
```

### 2. Modify `Makefile` 🖊️

Change these values in `Makefile` as you wish:

- `DOCKER_NAME` (name for your docker image)
- `DOCKER_TAG`
- `NETWORK_NAME`
- `ROS_MASTER_URI`
- `ROS_HOSTNAME`

### 3. Modify `Dockerfile` 🖊️

Choose ENTRYPOINT for master or slave

> This might be changed in the future so that the container can choose its running mode according to the environmental variable

### 4. Build 🚧

```shell
make build
```

This will take a couple of minutes; get some coffee ☕

At the end, if successful `make` will ask your password to change ownership of `./xycar_ws/`.

### 5. Aftermath 👍

✅ During the build, an empty directory (`./xycar_ws/`) will be created.

> `./xycar_ws/` will remain empty until you starts a container from the image.

✅ Make sure image has been created

```shell
docker image ls
```

> The image size on my machine is 1.13GB

✅ Clean up dangling images

```shell
make clean
```

### 😸 Build is done

---

## How to Use

### 1. Modify `docker-compose.yml` 🖊️

- `image`: image name in `Makefile`
- `networks`: network name in `Makefile`
  - make sure you modify all of network names (hint: 2 places)

### 2. Start a container by docker-compose 🐳

```shell
make
# or
make up
```

⚠️ This step will populate `./xycar_ws/` automatically by `catkin_make` inside

If you want to start multiple containers, modify `docker-compose.yml` accordingly.

By starting multiple containers, you can emulate multiple machines connected to one network. You can practice for remote environment in this way.

Also, you can start a container with a specific command like `roslaunch` by option `command`.

- refer: <https://docs.docker.com/compose/compose-file/#command>

### 3. Open Terminals 💻

If you want to start a master by `roscore` or want to create ROS packages, or whatever, open interactive terminal for the live docker container which you started in step 2.

```shell
docker exec -it {image_name} /bin/bash
```

### 4. Use `./xycar_ws/` 👷

This directory is a bind-mounting volume for your container.
You can put any files in this directory and can use it in your container like a virtual machine.

If you have access problem, change the permission of this directory.

```shell
make claim
```

You need to be able to use `sudo` to do this.

## How to Stop

### Stop the Container 🛑

If you are done with the container, you can stop it.

```shell
make down
```

- This will not remove docker-network.
- This will not remove any works done in `./xycar_ws/`.

> Next time you start a container, you can continue from where you left off.

## Authors

- June Kim : _Creator_ - [Github](https://github.com/junekimdev)

## License

This project is licensed under the **MIT** License

> see the [LICENSE](License) file for details
