.DELETE_ON_ERROR:
.PHONY: all clean
.SUFFIXES: .md5 .ldjson .json

$(eval BRANCH=$(shell git symbolic-ref --short HEAD|sed -n -r '/^[0-9a-fA-F]{32}$$/p'))
ifndef BRANCH
  $(info Branch name is not 32 hex chars)
else
  $(info BRANCH=${BRANCH})
endif
FILELIST=.${BRANCH}.filelist
DIRLIST=.${BRANCH}.dirlist

ifndef OURS 
#$(error OURS is not defined)
endif

ifndef THEIRS
#$(error THEIRS is not defined)
endif

check-directories:
	test -d ${OURS}
	test -d ${THEIRS}

new-branch:
	$(eval md5_1=$(shell dd if=/dev/random bs=8192 count=100 | md5sum | cut -d " " -f 1))
	$(eval md5_2=$(shell dd if=/dev/random bs=8192 count=100 | md5sum | cut -d " " -f 1))
	test ${md5_1} != ${md5_2}
	git branch -m ${md5_1}

cd.dirs: 
	find . -type d | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

cd.files: 
	find . -type f | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@


epoch.txt:
	date +%s  | tr -d '\n\r\t'>$@
	test -s $@

cd.dir:
	pwd | tr -d '\n\r\t' >$@
	grep '^/' $@ 
	test -s $@

root.fileurl: hostname.txt cd.dir
	echo -n "file://" > $@
	cat $(firstword $^) >>$@
	cat $(lastword $^) >>$@
	test -s $@

hostname.txt:
	hostname | tr -d '\n\r\t' >$@
	test -s $@

all.relpaths:
	find . | sed -n -r 's/^\.+\/+//p' > $@
	test -s $@
	wc $@

all.fileurls: root.fileurl all.relpaths
	cat $(lastword $^)| sed -n -r 's#^([^\/].+)$$#$(shell cat $(firstword $^))/\1#p' >$@
	@tail $@

cd.md5sum:
	find . -type f| xargs md5sum >$@

%.ldjson: %.md5sum
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

%.json: %.ldjson
	cat $< | jq -s >$@

