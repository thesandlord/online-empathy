SHELL=/bin/bash

FREESPACE=$(shell df /home -B 1M | awk '{if ($$1 != "Filesystem") print $$4}')

CURRENTSTEP=$(shell cat .current_step 2> /dev/null || echo 0)
CURRENTSETPNAME=$(shell cat steps.yaml | shyaml get-value steps.$(CURRENTSTEP).name ~~EOF~~)
NEXTSETPNAME=$(shell cat steps.yaml | shyaml get-value steps.$$(( $(CURRENTSTEP) + 1 )).name ~~EOF~~)

ASCIINEMA := $(shell command -v asciinema 2> /dev/null)
SHYAML := $(shell command -v shyaml 2> /dev/null)
DIALOG := $(shell command -v dialog 2> /dev/null)

start: install printsession help asciinema

install:
	@echo "0" > .current_step
	@if [ $(FREESPACE) -lt 15 ] ; then (echo "ERROR! Not enough free disk space!"; echo ""; exit 1); fi
ifndef ASCIINEMA
	$(info    Installing Dependencies)
	@sudo pip3 install asciinema > /dev/null 2>&1
endif
ifndef SHYAML
	$(info    Installing Dependencies)
	@sudo pip3 install shyaml > /dev/null 2>&1
endif
ifndef DIALOG
	$(info    Installing Dependencies)
	@sudo apt-get install -y dialog > /dev/null 2>&1
endif

printsession:
	$(info    )
	$(info    )
	$(info    Starting Empathy Session:)
	@echo "$(shell cat steps.yaml | shyaml get-value name)"

asciinema:
	$(info    Loading...)
	@cat ~/.bashrc .rcfile > .temprc
	@asciinema rec .session.cast --overwrite -q -c "/bin/bash --rcfile .temprc"

help:
	$(info    )
	$(info    )
	$(info    Type "stop" to stop at any time)
	$(info    Type "check" to validate your work and move to the next step)
	$(info    Type "help" to print this message again)
	$(info    )
	$(info    )
	@cat steps.yaml | shyaml get-value steps.$(CURRENTSTEP).assignment
	@echo ''
	@echo ''
	@echo ''

check:
	@echo "$(CURRENTSETPNAME)"
	@make next

stop:
	@while [ -z "$$SUBMIT" ]; do \
        read -r -p "Do you want to submit this empathy session? [y/n]: " SUBMIT; \
    done ; \
	[ $$SUBMIT = "y" ] || [ $$SUBMIT = "Y" ] || [ $$SUBMIT = "Yes" ] || [ $$SUBMIT = "YES" ] || (echo "Exiting. If you change your mind, type 'make submit'. Type 'make -s start' to restart the session"; pkill asciinema;)
	@bash .submit.sh
	@rm -f .current_step
	@rm -f .temprc
	@pkill asciinema

next:
ifeq '$(NEXTSETPNAME)' '~~EOF~~'
	$(info    All Steps Finished!)
	@make stop
else
	@echo $$(( $(CURRENTSTEP) + 1 )) > .current_step
endif