install:
	pip install mynt==0.4

build:
	rm -rf docs
	mynt gen -f . docs

start: build
	mynt serve docs