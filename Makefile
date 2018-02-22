#Start top level commands
PACKAGE_NAME := repkalinux
TEST_DEPEND := dunst

OUT_DEB_FILE := out/$(PACKAGE_NAME).deb
REMOTE_USERNAME := paul
REMOTE_SERVER := repkap11.com
REMOTE_FILE := /home/paul/website/$(PACKAGE_NAME).deb
REMOTE_TARGET := $(REMOTE_USERNAME)@$(REMOTE_SERVER):$(REMOTE_FILE)

default: build install deploy

#Installs packages needed for this project
configure:
	sudo apt install gdebi

deploy: build
	@echo "Copying $(OUT_DEB_FILE) to $(REMOTE_TARGET)"
	rsync --update $(OUT_DEB_FILE) $(REMOTE_TARGET)

test: clean uninstall
	@#Uninstall a package to make sure it gets reinstalled
	sudo apt remove $(TEST_DEPEND) -y
	$(MAKE) build install deploy
	@#Make sure the test depend is installed again
	which $(TEST_DEPEND)
	@echo "Test Finished Successfully"

install: build
	@echo "\n### Starting Install ###"
	sudo gdebi --n $(OUT_DEB_FILE)
	@#sudo apt install --only-upgrade $(PACKAGE_NAME)
	sudo apt install -f $(PACKAGE_NAME)
	@echo "### Ending Install ###\n"

uninstall:
	sudo dpkg --purge $(PACKAGE_NAME)

build: $(OUT_DEB_FILE)

clean:
	rm -rf out

PACKAGE_DEPENDS:=$(shell find package)
#Print the PACKAGE_DEPENDS
#$(info $$PACKAGE_DEPENDS is [${PACKAGE_DEPENDS}])

out:
	@mkdir -p out

$(OUT_DEB_FILE): out $(PACKAGE_DEPENDS)
	dpkg-deb --build package $@

.PHONY: install uninstall test build clean untest default configure deploy