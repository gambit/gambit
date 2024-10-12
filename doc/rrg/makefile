# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
default: info html-monolith txt

html-monolithic-phonies := html-monolith html-pristine-monolith \
                           html-parens-monolith html-css-monolith \
                           html-css-parens-monolith html-css-color-monolith

html-modular-phonies := html-modules html-pristine-modules html-css-modules \
                        html-parens-modules html-css-modules \
                        html-css-parens-modules html-css-color-modules

html-sample-phonies := samples sample color-samples color-sample html-samples \
 html-sample html-color-samples html-color-sample color-html-samples \
 color-html-sample

html-monoliths := gambit.html gambit-css.html gambit-parens.html \
 gambit-css-color-parens.html gambit-pristine.html gambit-css-color.html

html-stamps := html/.stamp html-css/.stamp html-css-color/.stamp \
 html-css-color-parens/.stamp html-css-parens/.stamp html-pristine/.stamp

html-samples := gambit-color-samples.html gcs-css-color-parens.html \
 gcs-css-color.html gcs-css.html gcs-css-parens.html \
 gcs-parens.html gcs-pristine.html

html-for-dist-dev := ${html-monoliths} ${html-samples} html/.stamp

.PHONY: default all all-html html-all all-html-monoliths html-monoliths-all \
 all-html-modules html-all-modules all-monoliths monoliths-all clean \
 clean-intermediate mostlyclean info txt epub ${html-monolithic-phonies} \
 ${html-modular-phonies} ${html-sample-phonies} tests clean-tests \
 clean-samples dist dist-dev

all: gambit.info gambit.txt ${html-monoliths} ${html-stamps} ${html-samples}
all-html html-all: ${html-monoliths} ${html-stamps}
all-html-monoliths html-all-monoliths: ${html-monoliths}
all-html-modules html-all-modules: ${html-stamps}
all-monoliths monoliths-all: gambit.info gambit.txt ${html-monoliths}

clean: clean-intermediate clean-samples clean-tests
	rm -fr html/ html-parens/ html-css/ html-css-parens/
	rm -f gambit.info gambit.txt gambit.html gambit-parens.html \
		gambit-css.html gambit-css-parens.html gambit.epub \
		gambit-doc.tgz gambit-doc-dev.tgz

clean-intermediate mostlyclean: clean-intermediate-samples
	rm -fr html-pristine/ html-css-color/ html-css-color-parens/ procedures/c/
	rm -f gambit-spans.txi gambit-pristine.html gambit-css-color.html \
		gambit-css-color-parens.html toolshed/gambit.css \
		toolshed/colorize.sed

clean-samples clean-sample: clean-intermediate-samples
	rm -f gambit-color-samples.html

clean-intermediate-samples clean-samples-intermediate:
	rm -fr toolshed/c/
	rm -f gcs-css-color-parens.html gcs-css-color.html gcs-css.html \
		gcs-css-parens.html gcs-parens.html gcs-pristine.html

clean-tests:
	rm -fr tests/

# .NOTPARALLEL is not necessary when using GNU Make.
.NOTPARALLEL: dist dist-dev
dist-dev dev-dist: clean gambit-doc-dev.tgz
dist: clean gambit-doc.tgz

gambit-doc-dev.tgz: gambit.info gambit.txt ${html-for-dist-dev}
	tar -czf $@ -s '%html/\..*%%' -s '_^_gambit-doc/_' \
		gambit.info gambit.txt gambit*.html gcs*.html html/

gambit-doc.tgz: gambit.info gambit.txt gambit.html html/.stamp
	tar -czf $@ -s '%html/\..*%%' -s '_^_gambit-doc/_' \
		gambit.{info,txt} gambit.html html/

tests: tests/.stamp
tests/.stamp: procedures/*.txi toolshed/extract-tests.sh
	for txi in procedures/*.txi; do\
		sh -efu toolshed/extract-tests.sh "$$txi" tests;\
	done
	touch $@

gambit.txi: prose/* procedures/*.txi toolshed/copying.txi toolshed/macros.txi \
            toolshed/vars.txi toolshed/licenses/LICENSE-2.0.txt \
            toolshed/licenses/lgpl-2.1.texi

gambit.txi:
	test -f $@ && touch $@

info: gambit.info
gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

txt: gambit.txt
gambit.txt: gambit.txi
	texi2any -o $@ --plaintext gambit.txi

epub: gambit.epub
gambit.epub: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

html: html-monolith
html-monolith: gambit.html
gambit.html: gambit-css-color-parens.html
	ln -f gambit-css-color-parens.html $@

html-modules: html/.stamp
html/.stamp: html-css-color-parens/.stamp
	mkdir -p html/
	for f in html-css-color-parens/*.html html-css-color/*.css; do\
		ln -f "$$f" html/"$${f#*/}";\
	done
	touch $@

html-pristine-monolith: gambit-pristine.html
gambit-pristine.html: gambit.txi toolshed/gambit.css
	texi2any -o $@ --html --no-split gambit.txi

html-parens-monolith: gambit-parens.html
gambit-parens.html: gambit-pristine.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-pristine.html > $@

html-css-monolith: gambit-css.html
gambit-css.html: gambit.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css --no-split \
		gambit.txi

html-css-parens-monolith: gambit-css-parens.html
gambit-css-parens.html: gambit-css.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-css.html > $@

html-css-color-monolith: gambit-css-color.html
gambit-css-color.html: gambit-spans.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css --no-split \
		gambit-spans.txi

html-css-color-parens-monolith: gambit-css-color-parens.html
gambit-css-color-parens.html: gambit-css-color.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-css-color.html > $@

gambit-spans.txi: gambit.txi procedures/c/.stamp
	sed 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1c\//' gambit.txi > $@

procedures/c/.stamp: procedures/c/pairs-lists.txi
	touch $@

procedures/c/pairs-lists.txi: procedures/pairs-lists.txi toolshed/colorize.sed
	mkdir -p procedures/c/
	sed -f toolshed/colorize.sed procedures/pairs-lists.txi > $@

toolshed/colorize.sed: toolshed/colorize.sed.sh
	sh -efu toolshed/colorize.sed.sh > $@

toolshed/colorize.sed.sh: toolshed/data/char-names toolshed/data/chars-to-dim \
 toolshed/data/homogeneous-vectors toolshed/data/html-char-refs \
 toolshed/data/sharp-objects toolshed/data/syntax-words
	test -f $@ && touch $@

toolshed/gambit.css: toolshed/gambit.css.in toolshed/make-css.sh
	sh -efu toolshed/make-css.sh toolshed/gambit.css.in > $@

toolshed/make-css.sh: toolshed/data/*-colors

toolshed/vars.txi: toolshed/html-char-refs.txi

${html-sample-phonies}: ${html-samples}
gambit-color-samples.html: gcs-css-color-parens.html
	ln -f gcs-css-color-parens.html $@

gcs-pristine.html: toolshed/color-samples.txi
	texi2any -o $@ --html --no-split toolshed/color-samples.txi

gcs-parens.html: gcs-pristine.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gcs-pristine.html > $@

gcs-css.html: toolshed/color-samples.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css \
		--no-split toolshed/color-samples.txi

gcs-css-parens.html: gcs-css.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gcs-css.html > $@

gcs-css-color.html: toolshed/c/color-samples.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css \
		--no-split toolshed/c/color-samples.txi

gcs-css-color-parens.html: gcs-css-color.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gcs-css-color.html > $@

toolshed/c/color-samples.txi: toolshed/color-samples.txi toolshed/colorize.sed
	mkdir -p toolshed/c/
	sed -f toolshed/colorize.sed toolshed/color-samples.txi > $@

toolshed/color-samples.txi: toolshed/macros.txi toolshed/vars.txi
	test -f $@ && touch $@

color-samples-spans.txi: toolshed/color-samples.txi toolshed/colorize.sed
	sed -f toolshed/colorize.sed toolshed/color-samples.txi > $@

html-pristine-modules: html-pristine/.stamp
html-pristine/.stamp: gambit.txi
	texi2any -o html-pristine --html gambit.txi
	touch $@

html-parens-modules: html-parens/.stamp
html-parens/.stamp: html-pristine/.stamp toolshed/parenthesize-defs.sed
	mkdir -p html-parens/
	for h in html-pristine/*.html; do\
		sed -f toolshed/parenthesize-defs.sed "$$h"\
			> html-parens/"$${h#*/}";\
	done
	touch $@

html-css-modules: html-css/.stamp
html-css/.stamp: gambit.txi toolshed/gambit.css
	texi2any -o html-css --html --css-ref=gambit.css gambit.txi
	cp toolshed/gambit.css html-css/gambit.css
	touch $@

html-css-color-modules: html-css-color/.stamp
html-css-color/.stamp: gambit-spans.txi toolshed/gambit.css
	texi2any -o html-css-color --html --css-ref=gambit.css gambit-spans.txi
	cp toolshed/gambit.css html-css-color/gambit.css
	touch $@

html-css-parens-modules: html-css-parens/.stamp
html-css-parens/.stamp: html-css/.stamp toolshed/parenthesize-defs.sed
	mkdir -p html-css-parens/
	for h in html-css/*.html; do\
		sed -f toolshed/parenthesize-defs.sed "$$h"\
			> html-css-parens/"$${h#*/}";\
	done
	cp html-css/*.css html-css-parens/
	touch $@

html-css-color-parens-modules: html-css-color-parens/.stamp
html-css-color-parens/.stamp: html-css-color/.stamp toolshed/parenthesize-defs.sed
	mkdir -p html-css-color-parens/
	for h in html-css-color/*.html; do\
		sed -f toolshed/parenthesize-defs.sed "$$h"\
			> html-css-color-parens/"$${h#*/}";\
	done
	cp html-css-color/*.css html-css-color-parens/
	touch $@
