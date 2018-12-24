.DELETE_ON_ERROR:

ifndef SRC
$(error SRC is not defined)
endif

ifndef DST
$(error DST is not defined)
endif

check-src:
	test -d ${SRC}

check-dst:
	test -d ${DST}


git-config:
	git config --system pager.reflog ""
	git config --system pager.branch ""
	git config --system pager.diff ""

