.PHONY: all clean
.SUFFIXES: .md5 .ldjson .json

all: file-catalog.json

clean:
	-rm *.md5 *.ldjson *.json

file-catalog.md5:
	find .. -type f| xargs md5sum >$@

%.ldjson: %.md5
	cat $< 	| jq -R -c 'split("  ")|{"md5":.[0],"path":.[1]}' >$@

%.json: %.ldjson
	cat $< | jq -s>$@
