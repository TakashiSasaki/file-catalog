all: ls-tree.txt filelist.txt

clean:
	rm -rf *.txt

rev-parse.txt:
	unset GIT_DIR; \
	       	git -C .. rev-parse --all | uniq | tee $@

ls-tree.txt: rev-parse.txt
	unset GIT_DIR; \
	cat $< | xargs -n 1 git -C .. ls-tree | tee  $@

filelist.txt:
	(cd ..; find .) | tee $@
	
