git-all: .git-rev-parse-all \
	.git-rev-parse-branches \
	.git-rev-parse-tags \
	.git-rev-parse-remotes \
	.git-ls-tree \
	.git-check-attr \
	.git-config-remote \
	.git-config-branch \
	.git-dir \
	.git-clean

.git-rev-parse-all:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	unset GIT_DIR; \
	       	git rev-parse --all | uniq | tee $@
	test -s $@

.git-rev-parse-branches:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	unset GIT_DIR; \
	       	git rev-parse --branches | uniq | tee $@
	test -s $@

.git-rev-parse-tags:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	unset GIT_DIR; \
	       	git rev-parse --tags | uniq | tee $@
	-test -s $@

.git-rev-parse-remotes:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	unset GIT_DIR; \
	       	git rev-parse --remotes| uniq | tee $@
	test -s $@

.git-ls-tree: .git-rev-parse-all
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	unset GIT_DIR; \
	cat $< | xargs -n 1 git ls-tree -t -r --full-tree| sort -u -k 4 | tee  $@
	test -s $@

git-config:
	git config core.autocrlf input
	git config core.file true
	git config core.filemode false
	git config merge.ours.driver true
	git config merge.ours.name "Keep ours merge"
	git config pager.branch ""
	git config pager.config ""
	git config pager.diff ""
	git config pager.reflog ""

.git-check-attr:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	find . | git check-attr --stdin -a | tee $@

.git-config-remote:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	git config -l | grep '^remote\.' | tee $@

.git-config-branch:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	git config -l | grep '^branch\.' | tee $@

.git-dir:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	git rev-parse --git-dir | tee $@

.git-clean:
	echo $@ merge=ours>>.gitattributes
	sort -u -o .gitattributes .gitattributes
	echo $@ >>.gitignore
	sort -u -o .gitignore .gitignore
	git clean -n -d -x | tee $@

