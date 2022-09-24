#
# some housekeeping tasks
#

export GO111MODULE = on
export GOFLAGS = -mod=vendor

# variable definitions
NAME := checkmake
DESC := experimental linter for Makefiles
PREFIX ?= usr/local
VERSION := $(shell git describe --tags --always --dirty)
GOVERSION := $(shell go version)
BUILDTIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILDDATE := $(shell date -u +"%B %d, %Y")

BUILD_GOOS ?= $(shell go env GOOS)
BUILD_GOARCH ?= $(shell go env GOARCH)

RELEASE_ARTIFACTS_DIR := .release_artifacts
CHECKSUM_FILE := checksums.txt

$(RELEASE_ARTIFACTS_DIR):
	install -d $@

BUILDER_NAME := $(if $(BUILDER_NAME),$(BUILDER_NAME),$(shell git config user.name))
ifndef BUILDER_NAME
$(error "You must set environment variable BUILDER_NAME or set a user.name in your git configuration.")
endif

EMAIL := $(if $(BUILDER_EMAIL),$(BUILDER_EMAIL),$(shell git config user.email))
ifndef EMAIL
$(error "You must set environment variable BUILDER_EMAIL or set a user.email in your git configuration.")
endif

BUILDER := $(shell echo "${BUILDER_NAME} <${EMAIL}>")

PKG_RELEASE ?= 1
PROJECT_URL := "https://github.com/mrtazz/$(NAME)"
LDFLAGS := -X 'main.version=$(VERSION)' \
           -X 'main.buildTime=$(BUILDTIME)' \
           -X 'main.builder=$(BUILDER)' \
           -X 'main.goversion=$(GOVERSION)'

PACKAGES := $(shell find ./* -type d | grep -v vendor)
TEST_PKG ?= $(shell go list ./... | grep -v /vendor/)

CMD_SOURCES := $(shell find cmd -name main.go)
TARGETS := $(patsubst cmd/%/main.go,%,$(CMD_SOURCES))
MAN_SOURCES := $(shell find man -name "*.md")
MAN_TARGETS := $(patsubst man/man1/%.md,%,$(MAN_SOURCES))

INSTALLED_TARGETS = $(addprefix $(PREFIX)/bin/, $(TARGETS))
INSTALLED_MAN_TARGETS = $(addprefix $(PREFIX)/share/man/man1/, $(MAN_TARGETS))

%: cmd/%/main.go
	GOOS=$(BUILD_GOOS) GOARCH=$(BUILD_GOARCH) go build -ldflags "$(LDFLAGS)" -o $@ $<

%.1: man/man1/%.1.md
	sed "s/REPLACE_DATE/$(BUILDDATE)/" $< | pandoc -s -t man -o $@

all: require $(TARGETS) $(MAN_TARGETS)
.DEFAULT_GOAL:=all

binaries: $(TARGETS)

require:
	@echo "Checking the programs required for the build are installed..."
	@pandoc --version >/dev/null 2>&1 || (echo "ERROR: pandoc is required."; exit 1)

# development tasks
test:
	go test -v $(TEST_PKG)

benchmark:
	@echo "Running tests..."
	@go test -bench=. ${NAME}

# install tasks
$(PREFIX)/bin/%: %
	install -d $$(dirname $@)
	install -m 755 $< $@

$(PREFIX)/share/man/man1/%: %
	install -d $$(dirname $@)
	install -m 644 $< $@

install: $(INSTALLED_TARGETS) $(INSTALLED_MAN_TARGETS)

local-install:
	$(MAKE) install PREFIX=usr/local

# packaging tasks
packages: local-install rpm deb

deploy-packages: packages
	package_cloud push mrtazz/$(NAME)/el/8 *.rpm
	package_cloud push mrtazz/$(NAME)/debian/trixie *.deb
	package_cloud push mrtazz/$(NAME)/ubuntu/hirsute *.deb

vendor:
	go mod vendor

rpm: $(SOURCES)
	  fpm -t rpm -s dir \
    --name $(NAME) \
    --version $(VERSION) \
		--description "$(DESC)" \
    --iteration $(PKG_RELEASE) \
    --epoch 1 \
    --license MIT \
    --maintainer "Daniel Schauenberg <d@unwiredcouch.com>" \
    --url $(PROJECT_URL) \
    --vendor mrtazz \
    usr

deb: $(SOURCES)
	  fpm -t deb -s dir \
    --name $(NAME) \
    --version $(VERSION) \
		--description "$(DESC)" \
    --iteration $(PKG_RELEASE) \
    --epoch 1 \
    --license MIT \
    --maintainer "Daniel Schauenberg <d@unwiredcouch.com>" \
    --url $(PROJECT_URL) \
    --vendor mrtazz \
    usr

.PHONY: build-standalone
build-standalone: all $(RELEASE_ARTIFACTS_DIR)
	mv checkmake.1 $(RELEASE_ARTIFACTS_DIR)
	mv checkmake $(RELEASE_ARTIFACTS_DIR)/checkmake-$(VERSION).$(BUILD_GOOS).$(BUILD_GOARCH)
	cd $(RELEASE_ARTIFACTS_DIR) && shasum -a 256 checkmake-$(VERSION).$(BUILD_GOOS).$(BUILD_GOARCH) >> $(CHECKSUM_FILE)

.PHONY: github-release
github-release:
	gh release create $(VERSION) --title 'Release $(VERSION)' --notes-file docs/releases/$(VERSION).md $(RELEASE_ARTIFACTS_DIR)/*


# clean up tasks
clean: clean-docs clean-deps
	$(RM) -r ./usr
	$(RM) $(TARGETS)

clean-docs:
	$(RM) $(MAN_TARGETS)

.PHONY: all test rpm deb install local-install packages vendor clean-deps clean clean-docs binaries