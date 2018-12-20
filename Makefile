.DELETE_ON_ERROR:

FRCODE=/usr/libexec/frcode

all: ls-tree.txt filelist.txt path.txt

epoch.txt:
	date +%s  | tr -d '\n\r\t'>$@
	test -s $@

clean:
	rm -rf *.txt

path.txt:
	(cd ..; pwd) | tr -d '\n\r\t' >$@
	grep '^/' $@ 
	test -s $@

fileurl.txt:
	echo -n "file://" > $@
	cat hostname.txt >>$@
	cat path.txt >>$@
	test -s $@

hostname.txt:
	hostname | tr -d '\n\r\t' >$@
	test -s $@

rev-parse.txt:
	unset GIT_DIR; \
	       	git -C .. rev-parse --all | uniq | tee $@
	test -s $@

ls-tree.txt: rev-parse.txt
	unset GIT_DIR; \
	cat $< | xargs -n 1 git -C .. ls-tree | tee  $@
	test -s $@

filelist.txt:
	(cd ..; find .) | tee $@
	test -s $@

%.frcode: %.filelist
	cat $< | sort | uniq | ${FRCODE} >$@
	test -s $@

