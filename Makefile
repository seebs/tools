.PHONY: dep pi crossbuild install release test cover cover-pkg cover-viz

DEP := $(shell command -v dep 2>/dev/null)
VERSION := $(shell git describe --tags 2> /dev/null || echo unknown)
IDENTIFIER := $(VERSION)-$(GOOS)-$(GOARCH)
CLONE_URL=github.com/pilosa/tools
PKGS := $(shell cd $(GOPATH)/src/$(CLONE_URL); go list ./... | grep -v vendor)
BUILD_TIME=`date -u +%FT%T%z`
LDFLAGS="-X github.com/pilosa/tools.Version=$(VERSION) -X github.com/pilosa/tools.BuildTime=$(BUILD_TIME)"

default: test pi

$(GOPATH)/bin:
	mkdir $(GOPATH)/bin

dep: $(GOPATH)/bin
	go get -u github.com/golang/dep/cmd/dep

vendor: Gopkg.toml
ifndef DEP
	make dep
endif
	dep ensure
	touch vendor

Gopkg.lock: dep Gopkg.toml
	dep ensure

test: vendor
	go test $(PKGS) $(TESTFLAGS)

cover: vendor
	mkdir -p build/coverage
	echo "mode: set" > build/coverage/all.out
	for pkg in $(PKGS) ; do \
		make cover-pkg PKG=$$pkg ; \
	done

cover-pkg:
	mkdir -p build/coverage
	touch build/coverage/$(subst /,-,$(PKG)).out
	go test -coverprofile=build/coverage/$(subst /,-,$(PKG)).out $(PKG)
	tail -n +2 build/coverage/$(subst /,-,$(PKG)).out >> build/coverage/all.out

cover-viz: cover
	go tool cover -html=build/coverage/all.out

pi: vendor
	go build -ldflags $(LDFLAGS) $(FLAGS) $(CLONE_URL)/cmd/pi

crossbuild: vendor
	mkdir -p build/pi-$(IDENTIFIER)
	make pi FLAGS="-o build/pi-$(IDENTIFIER)/pi"
	cp LICENSE README.md build/pi-$(IDENTIFIER)
	tar -cvz -C build -f build/pi-$(IDENTIFIER).tar.gz pilosa-$(IDENTIFIER)/
	@echo "Created release build: build/pi-$(IDENTIFIER).tar.gz"

release:
	make crossbuild GOOS=linux GOARCH=amd64
	make crossbuild GOOS=linux GOARCH=386
	make crossbuild GOOS=darwin GOARCH=amd64

install: vendor
	go install -ldflags $(LDFLAGS) $(FLAGS) $(CLONE_URL)/cmd/pi
