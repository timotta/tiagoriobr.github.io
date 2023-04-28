install:
	pip install mynt==0.4

build:
	mynt gen -f . docs

start: build
	mynt serve docs