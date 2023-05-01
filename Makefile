install:
	pip install mynt==0.4

build:
	rm -rf docs
	mynt gen -f . docs
	cp CNAME docs/CNAME

start: build
	mynt serve docs