prefix ?= /usr/local
bindir = $(prefix)/bin

.PHONY: all
all: build

.PHONY: build
## build: build an application
build:
	swift build -c release --disable-sandbox

.PHONY: install
## install: install the application
install: build
	install ".build/release/assetmate" "$(bindir)"

.PHONY: uninstall
## uninstall: remove the application
uninstall:
	rm -rf "$(bindir)/assetmate"

.PHONY: clean
## clean: clean build artifacts
clean:
	rm -rf .build

.PHONY: test
## test: launch unit tests
test:
	swift test

.PHONY: fmt
## fmt: reformat swift code
fmt:
	swift package plugin --allow-writing-to-package-directory swiftformat Sources Tests

.PHONY: help
## help: prints out help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
