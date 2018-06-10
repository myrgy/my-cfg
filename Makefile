VERSION := "1.0.0"

CFG_DIR := /etc
BIN_DIR := /bin
MAN_DIR := /share/man
TMP_DIR := $(shell mktemp -d)

FILES   := $(wildcard etc/*) $(wildcard rpm/*) Makefile

.PHONY: all info install rpms clean

all: info

info:
	@echo "Available make targets:"
	@echo "  install   : install binaries and man pages in DESTDIR (default /)"
	@echo "  dist      : create packages (RPM, tarball) ready for distribution"

clean:
	rm -f my-cfg-*.tar.gz

install:
	install -d $(DESTDIR)$(CFG_DIR)/yum.repos.d
	install -p etc/yum.repos.d/skype-stable.repo $(DESTDIR)$(CFG_DIR)/yum.repos.d/skype-stable.repo
	install -d $(DESTDIR)$(CFG_DIR)/X11/xorg.conf.d
	install -p etc/X11/xorg.conf.d/00-keyboard.conf $(DESTDIR)$(CFG_DIR)/X11/xorg.conf.d/00-keyboard.conf
	install -p etc/X11/xorg.conf.d/70-touchpad.conf $(DESTDIR)$(CFG_DIR)/X11/xorg.conf.d/70-touchpad.conf

my-cfg-$(VERSION).tar.gz: clean $(FILES)
	mkdir $(TMP_DIR)/my-cfg-$(VERSION)
	cp -r * $(TMP_DIR)/my-cfg-$(VERSION)
	cd $(TMP_DIR) ; \
	tar cfz $(TMP_DIR)/my-cfg-$(VERSION).tar.gz my-cfg-$(VERSION)
	mv $(TMP_DIR)/my-cfg-$(VERSION).tar.gz .
	rm -rf $(TMP_DIR)

rpms: my-cfg-$(VERSION).tar.gz
	mkdir $(TMP_DIR)
	mkdir $(TMP_DIR)/BUILD
	mkdir $(TMP_DIR)/RPMS
	mkdir $(TMP_DIR)/SOURCES
	mkdir $(TMP_DIR)/SRPMS
	cp my-cfg-$(VERSION).tar.gz $(TMP_DIR)/SOURCES
	cd $(TMP_DIR)/BUILD ; \
	tar xfz $(TMP_DIR)/SOURCES/my-cfg-$(VERSION).tar.gz \
		my-cfg-$(VERSION)/rpm/my-cfg.spec
	rpmbuild --define '_topdir $(TMP_DIR)' \
		 -ba $(TMP_DIR)/BUILD/my-cfg-$(VERSION)/rpm/my-cfg.spec
	mv $(TMP_DIR)/RPMS/noarch/my-cfg-$(VERSION)-*.noarch.rpm .
	# mv $(TMP_DIR)/SRPMS/my-cfg-$(VERSION)-$(RELEASE).src.rpm .
	rm -rf $(TMP_DIR)