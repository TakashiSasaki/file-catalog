.DELETE_ON_ERROR:

FIND_COMMAND:=$(shell which find.exe)
ifndef FIND_COMMAND
	FIND_COMMAND:=find
endif

XARGS_COMMAND:=$(shell which xargs.exe)
ifndef XARGS_COMMAND
	XARGS_COMMAND:=xargs
endif

%.depth1.dirs: %.dirs
	cat $< | $(XARGS_COMMAND) -n 1 -I{} $(FIND_COMMAND) {} -maxdepth 1 -mindepth 1 | tee $@
	test -s $@

%.depth2.dirs: %.depth1.dirs
	cat $< | $(XARGS_COMMAND) -n 1 -I{} $(FIND_COMMAND) {} -maxdepth 1 -mindepth 1 | tee $@
	test -s $@

