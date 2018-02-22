#Start top level commands
PACKAGE_NAME = repkalinux

default: test

#Installs packages needed for this project
configure:
	sudo apt install gdebi

test: Makefile
	#Force uninstall before build and install
	$(MAKE) untest
	$(MAKE) build install
	@echo "Test Done..."

untest: clean uninstall
	sudo apt remove dunst -y

install: build
	@echo "\n##Starting Install###"
	sudo gdebi --n out/$(PACKAGE_NAME).deb
	#sudo apt install --only-upgrade $(PACKAGE_NAME)
	sudo apt install -f $(PACKAGE_NAME)
	@echo "##Ending Install###\n"

uninstall:
	sudo dpkg --purge $(PACKAGE_NAME)

build: out/$(PACKAGE_NAME).deb

clean:
	rm -rf out

PACKAGE_DEPENDS = $(wildcard DEBIAN/*)

out:
	@mkdir -p out

out/$(PACKAGE_NAME).deb: out $(PACKAGE_DEPENDS)
	dpkg-deb --build package $@

.PHONY: install uninstall test build clean untest
