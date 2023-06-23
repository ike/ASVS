latest: 5.0

all: 5.0 4.0

4.0-LANGS := $(shell cd 4.0 && git status --porcelain | sed 's/[ A-Z?]\+ \"\?4.0\///g' | sed 's/\/.*//g' | sed -n '/^\(ar\|de\|en\|es\|fr\|pt\|ru\|zh-cn\)/p' | tr '\n' ' ')

5.0: docker
	docker run --rm -v "`pwd`/5.0:/data:rw" -v "`pwd`/docker:/scripts:rw" -e "TARGET=all" -e "FORMATS=$(FORMATS)" crossdiver/asvs-document-builder
5.0-clean: docker
	docker run --rm -v "`pwd`/5.0:/data:rw" -v "`pwd`/docker:/scripts:rw" -e "TARGET=clean" -e "FORMATS=$(FORMATS)" crossdiver/asvs-document-builder

4.0: docker
	docker run --rm -v "`pwd`/4.0:/data:rw" -v "`pwd`/docker:/scripts:rw" -e "TARGET=4.0" -e "FORMATS=$(FORMATS)" -e "LANGS=$(4.0-LANGS)" crossdiver/asvs-document-builder
4.0-clean: docker
	docker run --rm -v "`pwd`/4.0:/data:rw" -v "`pwd`/docker:/scripts:rw" -e "TARGET=clean" -e "FORMATS=$(FORMATS)" crossdiver/asvs-document-builder

.PHONY: docker 5.0 5.0-clean 4.0 4.0-clean
#docker:
	#if ! docker image inspect crossdiver/asvs-document-builder:latest --format="checking docker image" &> /dev/null; then \
		#docker pull crossdiver/asvs-document-builder
	#fi;

# docker build --build-arg CERT_FILE=docker/cert --tag asvs/document-builder:latest --network host docker; \
