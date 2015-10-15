
test:
	bats test/build.bats

run-build:
	./build.sh

bootstrap:
	sudo add-apt-repository -y ppa:duggan/bats
	sudo apt-get update
	sudo apt-get -y install bats


.PHONY: test run-build bootstrap
