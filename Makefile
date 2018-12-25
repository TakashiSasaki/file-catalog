.DELETE_ON_ERROR:

$(eval BRANCH=$(shell git symbolic-ref --short HEAD|sed -n -r '/^[0-9a-fA-F]{32}$$/p'))
ifndef BRANCH
  $(error Branch name should be 32 hex chars)
else
  $(info BRANCH=${BRANCH})
endif
FILELIST=.${BRANCH}.filelist
DIRLIST=.${BRANCH}.dirlist

all: ${DIRLIST} ${FILELIST} .${BRANCH}.githash
	git add -f ${DIRLIST}
	git add -f ${FILELIST}

ifndef OURS 
#$(error OURS is not defined)
endif

ifndef THEIRS
#$(error THEIRS is not defined)
endif

check-directories:
	test -d ${OURS}
	test -d ${THEIRS}

git-config:
	git config --system pager.reflog ""
	git config --system pager.branch ""
	git config --system pager.diff ""

new-branch:
	$(eval md5_1=$(shell dd if=/dev/random bs=8192 count=100 | md5sum | cut -d " " -f 1))
	$(eval md5_2=$(shell dd if=/dev/random bs=8192 count=100 | md5sum | cut -d " " -f 1))
	test ${md5_1} != ${md5_2}
	git branch -m ${md5_1}

%.dirlist:
	find . -type d | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

%.filelist:
	find . -type f | sed -n -r 's/^.\/(.+)$$/\1/p' >$@
	head $@; tail $@

%.githash: %.filelist
	cat $< | xargs -n 1 git hash-object 2>&1| tee $@
