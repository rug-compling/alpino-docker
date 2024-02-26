
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
	docker run $(DOCKERARGS) --rm -i -t \
		-e DISPLAY \
		-v $(PWD)/alpino:/alpino \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/src/sp-3.12.11-x86_64-linux-glibc2.5:/sp-3.12.11-x86_64-linux-glibc2.5 \
		-v $(PWD)/tmp:/tmp \
		-v $(PWD)/work:/work \
		localhost/alpino-devel:latest
	scripts/access.sh alpino alpino-in-docker/build/opt src/sp-* tmp work

distclean:
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

step0:	## deze repo bijwerken
	git pull

step1:	## maak/update het image dat in de volgende stappen gebruikt wordt
	build/build.sh

step2:	step1 ## installeer SICStus
	docker run $(DOCKERARGS) --rm -t \
		-v $(PWD)/work/sp:/sp \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src/sp-3.12.11-x86_64-linux-glibc2.5:/sp-3.12.11 \
		localhost/alpino-devel:latest \
		/scripts/install-sp.sh

step3:	step2 ## installeer Alpino en maak alpino/Alpino*.tar.gz
	docker run $(DOCKERARGS) --rm -t \
		-v $(PWD)/alpino:/alpino \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/work/cache:/cache \
		-v $(PWD)/work/sp:/sp \
		localhost/alpino-devel:latest \
		/scripts/install-alpino.sh
	cp `ls -rt alpino/Alpino*tar.gz | tail -n 1` alpino-in-docker/build/Alpino.tar.gz

step4:	step1 ## installeer DbXML
	docker run $(DOCKERARGS) --rm -t \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/dbxml:/dbxml \
		localhost/alpino-devel:latest \
		/scripts/install-dbxml.sh

step5:	step4 ## installeer alto, alud, alpinoviewer en maak work/tools/alto/alto*.AppImage
	docker run $(DOCKERARGS) --rm -t \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/cache:/cache \
		-v $(PWD)/work/tools:/tools \
		localhost/alpino-devel:latest \
		/scripts/install-tools.sh

step6:	step1 ## installeer TrEd
	if [ ! -f alpino-in-docker/build/tred_2.5236_all.deb ]; \
		then wget -O alpino-in-docker/build/tred_2.5236_all.deb https://ufal.mff.cuni.cz/tred/tred_2.5236_all.deb; fi

step7:	step4 ## installeer Dact
	docker run $(DOCKERARGS) --rm -t \
		-v $(PWD)/alpino-in-docker/build/opt:/opt \
		-v $(PWD)/scripts:/scripts \
		-v $(PWD)/src:/src \
		-v $(PWD)/work/dact:/dact \
		localhost/alpino-devel:latest \
		/scripts/install-dact.sh

step8:	step3 step5 step6 step7 ## maak image van Alpino in Docker
	cd alpino-in-docker/build && ./build.sh

step9:	step8 ## push image van Alpino in Docker naar de server
	@echo
	@echo -e '\e[1mVergeet niet af en toe oude versies te verwijderen, anders is ons quotum op\e[0m'
	@echo https://registry.webhosting.rug.nl/harbor/projects/57/repositories/alpino/artifacts-tab
	@echo
	cd alpino-in-docker/build && ./push.sh

