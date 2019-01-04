.DELETE_ON_ERROR:

FIND_COMMAND:=$(shell which find.exe)
ifndef FIND_COMMAND
	FIND_COMMAND:=find
endif

XARGS_COMMAND:=$(shell which xargs.exe)
ifndef XARGS_COMMAND
	XARGS_COMMAND:=xargs
endif

%.depth1.dirs: %.depth0.dirs
	cat $< | $(XARGS_COMMAND) -n 1 -I{} $(FIND_COMMAND) {} -maxdepth 1 -mindepth 1 -type d | tee $@
	test -s $@

%.depth2.dirs: %.depth1.dirs
	cat $< | $(XARGS_COMMAND) -n 1 -I{} $(FIND_COMMAND) {} -maxdepth 1 -mindepth 1 -type d | tee $@
	test -s $@


%.dirs.ldjson: %.dirs
	jq -R . $< | tee $@

%.json: %.ldjson
	jq -s . $< | tee $@

%.md5.ldjson: %.md5
	jq -R . $< | tee $@

%.ldjson.md5: %.ldjson
	-rm $@
	cat $< | $(XARGS_COMMAND) -n 1 -I {} sh -c "echo -n {} | md5sum | awk '{print \$$1}' | tee -a $@"

%.dirs.x: %.dirs.json %.dirs.ldjson.md5.json
	jq -s -c 'transpose|.[]' $^ | tee $@

all: root.depth1.dirs.x
