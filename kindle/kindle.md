# Running Celestia on a jailbroken Kindle Paperwhite 2021

Will it work?


Notes Kindle Celestia:

- Better don't use the prebuild alpine as it's too old and the apk package won't work.
- Build it yourself or use mine
- not enough space to build
- create a alpine env with 10GB disk
- build there copy the binary.
- create smaller alpine image. 
- copy binary on it

Cross compile:



Install crosscompiler
`sudo apt-get install gcc-arm-linux-gnueabi`

`nano Makefile`

```
## build: Build celestia-node binary.
build:
	@echo "--> Building Celestia"
	@GOOS=linux GOARCH=arm go build -o build/ ${LDFLAGS} ./cmd/celestia
.PHONY: build
```

`make build`

`build/celestia version`

```
Semantic version: v0.9.3-dev
Commit: 7f556f06e175267e0dd60b444a68554f592710a0
Build Date: Mo 8. Mai 23:45:52 CEST 2023
System version: arm/linux
Golang version: go1.20.4
```

copy to kindle

todo...