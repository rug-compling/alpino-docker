
ifeq ($(findstring rootless, $(shell docker info --format '{{.SecurityOptions}}')), )
DOCKERARGS = --net=host
else
DOCKERARGS = --volume=/tmp/.X11-unix/:/tmp/.X11-unix/
endif

.PHONY: help
help:
	@echo Beschikbare targets voor make:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[34m%-8s\033[0m %s\n", $$1, $$2}'

shell:
	docker run -e $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/alpino:/alpino \
		-v $(PWD)/cache:/cache \
		-v $(PWD)/opt:/opt \
		-v $(PWD)/sp:/sp \
		-v $(PWD)/sp-3.12.11-x86_64-linux-glibc2.5:/sp-3.12.11-x86_64-linux-glibc2.5 \
		localhost/alpino-devel:latest
	scripts/access.sh alpino cache opt sp sp-*

step0:	## update repo
	git pull
	scripts/access.sh .

step1:	## build docker environment
	build/build.sh

step2:	## installeer sicstus
	scripts/access.sh sp sp-*
	rm -f sp-3.12.11-x86_64-linux-glibc2.5/platform.cache
	cp sp-3.12.11-x86_64-linux-glibc2.5/install.cache.in sp-3.12.11-x86_64-linux-glibc2.5/install.cache
	docker run -e $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/sp:/sp \
		-v $(PWD)/sp-3.12.11-x86_64-linux-glibc2.5:/sp-3.12.11-x86_64-linux-glibc2.5 \
		localhost/alpino-devel:latest \
		bash -c "cd /sp-3.12.11-x86_64-linux-glibc2.5 && ./InstallSICStus --batch"
	scripts/access.sh sp sp-*

step3:	## installeer en compileer Alpino
	if [ -d alpino ]; then scripts/access.sh alpino; fi
	docker run -e $(DOCKERARGS) --rm -i -t \
		-v $(PWD)/sp:/sp \
		-v $(PWD)/cache:/cache \
		-v $(PWD)/alpino:/alpino \
		-v $(PWD)/scripts:/scripts \
		localhost/alpino-devel:latest \
		/scripts/install-alpino.sh
	scripts/access.sh alpino cache
	cp `ls -rt alpino/Alpino*tar.gz | tail -n 1` alpino-in-docker/build/Alpino.tar.gz

step8:	## maak Alpino in Docker
	cd alpino-in-docker/build && ./build.sh

step9:	## push Alpino in Docker
	@echo
	@echo -e '\e[1mVergeet niet af en toe oude versies te verwijderen, anders is ons quotum op\e[0m'
	@echo https://registry.webhosting.rug.nl/harbor/projects/57/repositories/alpino/artifacts-tab
	@echo
	cd alpino-in-docker/build && ./push.sh

