

VERSION=$(shell awk '/template_version/{print $$NF}' pantheon/pantheon.yaml)

release:
	@sed -e 's#\(<noop name="version">\)[0-9]\.[0-9]*#\1${VERSION}#' readme.md > new_readme.md
	@mv new_readme.md readme.md
