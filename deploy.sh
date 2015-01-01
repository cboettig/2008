#!/bin/bash
if [ ! -d _gh-pages ]; then
	git clone -b gh-pages . _gh-pages
	cd _gh-pages && git remote rm origin
	git remote add origin git@github.com:cboettig/2008.git
	git push -u origin gh-pages
	cd ..
# Control will enter here if $DIRECTORY exists.
else
	cd _gh-pages && git pull origin gh-pages && cd ..
fi
rsync -a _site/ _gh-pages/
cd _gh-pages && git add -A . && git commit -m 'Site updated' && git push

