.DELETE_ON_ERROR:

FRCODE=/usr/libexec/frcode

all: ls-tree.txt filelist.txt path.txt

epoch.txt:
	date +%s  | tr -d '\n\r\t'>$@
	test -s $@

clean:
	rm -rf *.txt

cd.txt:
	(cd ..; pwd) | tr -d '\n\r\t' >$@
	grep '^/' $@ 
	test -s $@

leading-part.txt: hostname.txt cd.txt
	echo -n "file://" > $@
	cat hostname.txt >>$@
	cat cd.txt >>$@
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

relative-paths.txt:
	(cd ..; find .) | sed -n -r 's/^\.+\/+//p' > $@
	test -s $@
	wc $@

file-urls.txt: leading-part.txt relative-paths.txt
	cat relative-paths.txt | sed -n -r 's/^([^\/].+)$$/$(shell cat leading-part.txt)\/\1/p' >$@

%.frcode: %.urllist
	cat $< | sort | uniq | ${FRCODE} >$@
	test -s $@

%.urllist: %.frcode
	locate -d $< "" > $@


