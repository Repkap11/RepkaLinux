#Start top level commands

#Commands that require sudo
test: untest build install
	echo "Test Done..."

untest: clean uninstall

install: build
	echo "\n##Starting Install###"
	sudo dpkg -i out/RepkaLinux.deb
	echo "##Ending Install###\n"

uninstall:
	sudo dpkg --purge RepkaLinux

#Commands which don't require sudo
build: out/RepkaLinux.deb

clean:
	rm -rf out

#Start package implementation
PACKAGE_DEPENDS = $(wildcard DEBIAN/*)

out:
	mkdir -p out

out/RepkaLinux.deb: out $(PACKAGE_DEPENDS)
	dpkg-deb --build package out/RepkaLinux.deb



.PHONY: install uninstall test build clean untest
