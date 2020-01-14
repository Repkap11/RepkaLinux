#Start top level commands
PACKAGE_NAME := repkalinux
TEST_DEPEND := dunst

OUT_DEB_FILE := out/$(PACKAGE_NAME).deb
REMOTE_USERNAME := paul
REMOTE_SERVER := repkap11.com
REMOTE_FILE := /home/paul/website/$(PACKAGE_NAME).deb
REMOTE_TARGET := $(REMOTE_USERNAME)@$(REMOTE_SERVER):$(REMOTE_FILE)

all: docker-run

build: $(OUT_DEB_FILE)

REPLINUX_PACKAGES := sudo xserver-xephyr xterm curl gdebi gnupg2
DOCKER_UBUNTU_VERSION := 18.04

docker-build: $(OUT_DEB_FILE)
	docker image prune -f
	docker volume prune -f
	docker container prune -f
	docker build -t repkalinux \
		--build-arg repkalinux_packages="$(REPLINUX_PACKAGES)" \
		--build-arg repkalinux_deb="$(OUT_DEB_FILE)" \
		--build-arg user_name=$(shell whoami) \
		--build-arg user_id=$(shell id -u) \
		--build-arg ubuntu_version="$(DOCKER_UBUNTU_VERSION)" \
		.

docker-run: docker-build 
	docker stop RepkaLinux || true
	echo
	docker run \
		--name=RepkaLinux \
		--hostname=RepkaLinux \
		--user $(shell id -u):$(shell id -g) \
		--rm -it --init \
		-v $(shell pwd):/home/$(shell whoami)/RepkaLinux \
		--env="DISPLAY=:0" \
		--env="QT_X11_NO_MITSHM=1" \
		--gpus device=0 \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		-d \
		repkalinux
	sleep 1
	docker exec -it --env="DISPLAY=:1" --env="QT_X11_NO_MITSHM=1" RepkaLinux i3

#Installs packages needed on the host
install:
	sudo apt-get install gdebi rsync

deploy: $(OUT_DEB_FILE)
	@echo "Copying $(OUT_DEB_FILE) to $(REMOTE_TARGET)"
	rsync --update $(OUT_DEB_FILE) $(REMOTE_TARGET)

clean:
	rm -rf out

out:
	@mkdir -p out

$(OUT_DEB_FILE): out $(shell find package)
	dpkg-deb --build package $@

.PHONY: install uninstall test build clean untest default configure deploy