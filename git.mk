
git-rev-parse-all.githash:
	unset GIT_DIR; \
	       	git rev-parse --all | uniq | tee $@
	test -s $@

git-ls-tree.txt: git-rev-parse-all.githash
	unset GIT_DIR; \
	cat $< | xargs -n 1 git -C ls-tree | tee  $@
	test -s $@

git-config:
	git config pager.reflog ""
	git config pager.branch ""
	git config pager.diff ""
	git config core.autocrlf false
	git config core.filemode false

