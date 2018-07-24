IS_UNDER_GIT := $(shell git rev-parse --is-inside-work-tree)

ifeq "$(IS_UNDER_GIT)" "true"
GIT_VERSION := $(shell git describe --tags --long --match "v[0-9]*.[0-9]")
VERSION:= $(shell echo $(GIT_VERSION) | sed -E "s/v([0-9]+\.[0-9]+)-([0-9]+)-.*/\1.\2/g")
else
VERSION:= ""
endif

CFG_DIR := /etc
BIN_DIR := /bin
MAN_DIR := /share/man
TMP_DIR := $(shell mktemp -d)

FILES := $(wildcard etc/* boot/* sbin/*)
ALL_FILES := $(FILES) $(wildcard rpm/*) Makefile

.PHONY: all info install rpms clean

all: info

info:
	@echo "Version: $(VERSION)"
	@echo "Available make targets:"
	@echo "  install   : install binaries and man pages in DESTDIR (default /)"
	@echo "  dist      : create packages (RPM, tarball) ready for distribution"

clean:
	rm -f my-cfg-*.tar.gz

install:
	@for file in $(FILES); do \
    install -D $(DESTDIR)/$$file $$file \
  done

my-cfg-$(VERSION).tar.gz: clean $(ALL_FILES)
	mkdir $(TMP_DIR)/my-cfg-$(VERSION)
	cp -r * $(TMP_DIR)/my-cfg-$(VERSION)
	cd $(TMP_DIR); \
  sed -i -E "s/^(Version:\s*)[0-9]+\.[0-9]+.*/\1$(VERSION)/g" my-cfg-$(VERSION)/rpm/my-cfg.spec; \
  tar cfz $(TMP_DIR)/my-cfg-$(VERSION).tar.gz my-cfg-$(VERSION)
	mv $(TMP_DIR)/my-cfg-$(VERSION).tar.gz .
	rm -rf $(TMP_DIR)

rpms: my-cfg-$(VERSION).tar.gz
	@echo $(VERSION)
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
