.PHONY: all setup up own claim down build term clean

all: setup up own

DOCKER_NAME=ros
DOCKER_TAG=1.0-base
NETWORK_NAME=ros-net
ROS_MASTER_URI=http://localhost:11311
ROS_HOSTNAME=localhost
UID=$(shell id -u)
GID=$(shell id -g)

setup:
	@if (docker network ls | grep -q $(NETWORK_NAME)); \
	then echo "An existing $(NETWORK_NAME) network found..."; \
	else docker network create -d bridge $(NETWORK_NAME); \
	fi

up: setup
	@docker-compose up -d \
	&& sleep 5s \
	&& docker logs -t --tail 3 $(DOCKER_NAME)

own: up
	@if [ $(shell ls -ld ./xycar_ws | awk -F' ' '{ print $$3 }') = root ]; then \
		sleep 5s \
		&& echo "Changing ownership of ./xycar_ws..." \
		&& sudo chown -R $(UID):$(GID) ./xycar_ws; \
	fi

claim:
	@echo "Claiming ownership of ./xycar_ws..." \
	&& sudo chown -R $(UID):$(GID) ./xycar_ws; \

down:
	docker-compose down

build:
	docker build \
	--build-arg USERNAME=$(shell whoami) \
	--build-arg UID=$(UID) \
	--build-arg GID=$(GID) \
	--build-arg ROS_MASTER_URI=$(ROS_MASTER_URI) \
	--build-arg ROS_HOSTNAME=$(ROS_HOSTNAME) \
	-t junekimdev/$(DOCKER_NAME):$(DOCKER_TAG) .

clean:
	docker rmi $(shell docker images -qf dangling=true)
