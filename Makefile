PREFIX?=/usr/local

TEMPORARY_FOLDER=./tmp_portable_kanji
OSNAME=${shell uname -s}

dependencies:
ifeq ($(OSNAME),Darwin)
	$(shell brew install gd)
endif

build: dependencies
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

test:
	swift test

lint:
	swiftlint

clean:
	swift package clean

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/Kanji" "$(PREFIX)/bin/kanji"

portable_zip: build
	mkdir -p "$(TEMPORARY_FOLDER)"
	cp -f ".build/release/Kanji" "$(TEMPORARY_FOLDER)/kanji"
	cp -f "LICENSE" "$(TEMPORARY_FOLDER)"
	(cd $(TEMPORARY_FOLDER); zip -r - LICENSE kanji) > "./portable_kanji.zip"
	rm -r "$(TEMPORARY_FOLDER)"

