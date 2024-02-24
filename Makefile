
ifeq ($(findstring rootless, $(shell docker info --format '{{.SecurityOptions}}')), )
DOCKERARGS = --net=host
else
DOCKERARGS = --volume=/tmp/.X11-unix/:/tmp/.X11-unix/
endif

.PHONY: help
help:
	@echo Beschikbare targets voor make:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[34m%-8s\033[0m %s\n", $$1, $$2}'

shell:	pre
	docker run $(DOCKERARGS) --rm -i -t \
		-e DISPLAY \
		-v $(PWD)/alpino:/alpino \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/src/sp-3.12.11-x86_64-linux-glibc2.5:/sp-3.12.11-x86_64-linux-glibc2.5 \
		-v $(PWD)/tmp:/tmp \
		-v $(PWD)/work:/work \
		localhost/alpino-devel:latest
	scripts/access.sh alpino alpino-in-docker/build/opt src/sp-* tmp work

distclean: pre
	rm -fr \
		alpino \
		alpino-in-docker/build/Alpino.tar.gz \
		alpino-in-docker/build/opt/alpinocorpus? \
		alpino-in-docker/build/opt/bin/alto* \
		alpino-in-docker/build/opt/bin/alud* \
		alpino-in-docker/build/opt/dact? \
		alpino-in-docker/build/opt/dbxml? \
		alpino-in-docker/build/opt/lib/XlibNoSHM.so \
		alpino-in-docker/build/opt/lib/alpinoviewer.bin \
		alpino-in-docker/build/opt/man/man1/alto.1 \
		work

step0:	pre ## update repo
	git pull

step1:	pre ## build docker environment
	build/build.sh

step2:	pre ## installeer sicstus
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/work/sp:/sp \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src/sp-3.12.11-x86_64-linux-glibc2.5:/sp-3.12.11 \
		localhost/alpino-devel:latest \
		/scripts/install-sp.sh

step3:	pre ## installeer en compileer Alpino
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpino:/alpino \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/work/cache:/cache \
		-v $(PWD)/work/sp:/sp \
		localhost/alpino-devel:latest \
		/scripts/install-alpino.sh
	cp `ls -rt alpino/Alpino*tar.gz | tail -n 1` alpino-in-docker/build/Alpino.tar.gz

step4:	pre ## installeer DbXML
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/dbxml:/dbxml \
		localhost/alpino-devel:latest \
		/scripts/install-dbxml.sh

step5:	pre ## installeer alto, alut alpinoviewer
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/cache:/cache \
		-v $(PWD)/work/tools:/tools \
		localhost/alpino-devel:latest \
		/scripts/install-tools.sh

step6:	pre ## installeer TrEd
	# momenteel wordt TrEd gecompileerd bij het maken van Alpino in Docker

step7:	pre ## installeer dact
	docker run $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/dact:/dact \
		localhost/alpino-devel:latest \
		/scripts/install-dact.sh

step8:	pre ## maak Alpino in Docker
	cd alpino-in-docker/build && ./build.sh

step9:	pre ## push Alpino in Docker
	@echo
	@echo -e '\e[1mVergeet niet af en toe oude versies te verwijderen, anders is ons quotum op\e[0m'
	@echo https://registry.webhosting.rug.nl/harbor/projects/57/repositories/alpino/artifacts-tab
	@echo
	cd alpino-in-docker/build && ./push.sh

pre:
	scripts/precheck.sh

