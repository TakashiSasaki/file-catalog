ifndef FRCODE
 FRCODE=$(shell which frcode)
else
 FRCODE=/usr/libexec/frcode
endif

%.githash: %.paths
	cat $< | xargs -n 1 git hash-object 2>&1| tee $@

%.frcode: %.urls
	cat $< | sort | uniq | ${FRCODE} >$@
	test -s $@

%.urls: %.frcode
	locate -d $< "" > $@

