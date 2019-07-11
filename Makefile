SHELL=/bin/bash

BASEDIR=$(shell cat /tmp/.empathybasedir 2>/dev/null || pwd)
FREESPACE=$(shell df /home -B 1M | awk '{if ($$1 != "Filesystem") print $$4}')

CURRENTSTEP=$(shell cat $(BASEDIR)/.current_step 2> /dev/null || echo 0)
NEXTSETPNAME=$(shell cat $(BASEDIR)/steps.yaml | shyaml get-value steps.$$(( $(CURRENTSTEP) + 1 )).name ~~EOF~~)

start: install printsession asciinema

install:
	@echo "0" > .current_step
	@if [ $(FREESPACE) -lt 15 ] ; then (echo "ERROR! Not enough free disk space!"; echo ""; exit 1); fi
	@echo "Installing Dependencies"
	@sudo pip3 install shyaml > /dev/null 2>&1 & sudo pip3 install asciinema > /dev/null 2>&1 & wait

printsession:
	$(info    )
	$(info    )
	$(info    Starting Empathy Session:)
	@echo "$(shell cat $(BASEDIR)/steps.yaml | shyaml get-value name)"

asciinema:
	$(info    Terminal Screen Recorder is Loading...)
	@echo $(shell pwd) > /tmp/.empathybasedir
	@cat ~/.bashrc $(BASEDIR)/.rcfile > $(BASEDIR)/.temprc
	@sed -i 's~{MAKEPATH}~$(BASEDIR)/Makefile~g' $(BASEDIR)/.temprc
	@asciinema rec .session.cast --overwrite -q -c "/bin/bash --rcfile .temprc"

help:
	@echo ''
	@echo ''
	@echo "Challenge: $(shell cat $(BASEDIR)/steps.yaml | shyaml get-value steps.$(CURRENTSTEP).name ~~EOF~~)"
	@echo ""
	@echo "Your Assignment:"
	@cat $(BASEDIR)/steps.yaml | shyaml get-value steps.$(CURRENTSTEP).assignment
	@echo ''
	@echo ''
	@echo ''
	@echo 'Type "stop" to stop at any time'
	@echo 'Type "next" to move to the next step'
	@echo 'Type "help" to print this message again'
	@echo ''
	@echo ''

check:
	@make -f $(BASEDIR)/Makefile next

stop:
	@while [ -z "$$SUBMIT" ]; do \
        read -r -p "Do you want to submit this empathy session? [y/n]: " SUBMIT; \
    done ; \
	[ $$SUBMIT = "y" ] || [ $$SUBMIT = "Y" ] || [ $$SUBMIT = "Yes" ] || [ $$SUBMIT = "YES" ] || (echo "Exiting. If you change your mind, type 'make submit'. Type 'make -s start' to restart the session"; pkill asciinema;)
	@make submit
	@rm -f $(BASEDIR)/.current_step
	@rm -f $(BASEDIR)/.temprc
	@pkill asciinema

next:
ifeq '$(NEXTSETPNAME)' '~~EOF~~'
	$(info    )
	$(info    )
	$(info    All Steps Finished!)
	$(info    )
	$(info    )
	@make -f $(BASEDIR)/Makefile stop
else
	@echo $$(( $(CURRENTSTEP) + 1 )) > $(BASEDIR)/.current_step
	@make -f $(BASEDIR)/Makefile help
endif

submit:
	@bash $(BASEDIR)/.submit.sh