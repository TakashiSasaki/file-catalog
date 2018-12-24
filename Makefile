.DELETE_ON_ERROR:

ifndef OURS 
$(error OURS is not defined)
endif

ifndef THEIRS
$(error THEIRS is not defined)
endif

check-directories:
	test -d ${OURS}
	test -d ${THEIRS}

git-config:
	git config --system pager.reflog ""
	git config --system pager.branch ""
	git config --system pager.diff ""

