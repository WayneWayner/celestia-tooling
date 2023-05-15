# Running Celestia on a jailbroken Kindle Paperwhite 2021

# Description
How to run a celestia light node on a Kindle Paperwhite 2021

Medium article: todo

Notes:

- Read the medium article
- Better don't use the prebuild alpine as it's too old and the apk package won't work.
- Build it yourself or use mine
- Kindle don't have enough storage to build the app itself
- Build it on a beefier machine like your PC via a cross compiler
- Copy the binary to your kindle

# Cross compile



Install crosscompiler
`sudo apt-get install gcc-arm-linux-gnueabi`

Edit makefile
`nano Makefile`

```
## build: Build celestia-node binary.
build:
	@echo "--> Building Celestia"
	@GOOS=linux GOARCH=arm go build -o build/ ${LDFLAGS} ./cmd/celestia
.PHONY: build
```
Build 
`make build`

Check if it build successfully 
`build/celestia version`

```
Semantic version: v0.9.3-dev
Commit: 7f556f06e175267e0dd60b444a68554f592710a0
Build Date: Mo 8. Mai 23:45:52 CEST 2023
System version: arm/linux
Golang version: go1.20.4
```

# Copy to kindle

## Option A: 
Use transfer.sh (recommended)

## Option B: 
Connect to your PC and copy the binary

Search binary on kindle

