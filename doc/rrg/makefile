default: gambit.html gambit.info gambit.txt

.PHONY: clean compile-adorn compile-exe default extraclean highlight highlight-cm

GSC ?= gsc
GSI ?= gsi
SCM ?= toolshed/examples/gauntlet.scm

html-common-deps = gambit.txi procedures/a/pairs-lists.txi \
 procedures/a/strings.txi toolshed/parenthesize-defs.sed

src-lib = ../../lib
lib-samples = _eval _io _kernel _module _nonstd _num _system _thread syntax-case sys

set-scm_to_html = \
if test -x scm-to-html; then\
    readonly scm_to_html=./scm-to-html;\
else\
    readonly scm_to_html='${GSI} -f scm-to-html.scm';\
fi

annotate-procedures-file = \
test -d procedures/a/ || mkdir -p procedures/a/;\
cd toolshed &&\
${GSI} -f annotate-txi.scm ../procedures/"$$txi" > ../procedures/a/"$$txi"

clean:
	rm -f *.html *.info *.tgz gambit.{txi,txt} toolshed/*.css toolshed/*.html\
		toolshed/macros+vars.txi
	rm -f -r procedures/a/ html-modules/ html-modules-cm/

extraclean: clean
	rm -f toolshed/adorn/adorn.o1 toolshed/scm-to-html

compile-adorn: toolshed/adorn/adorn.o1

compile-exe: toolshed/scm-to-html

toolshed/scm-to-html: toolshed/scm-to-html.scm toolshed/adorn/adorn.o1
	if test -e toolshed/scm-to-html.c; then rm toolshed/scm-to-html.c; fi &&\
	${GSC} -exe toolshed/scm-to-html.scm

toolshed/adorn/adorn.o1: toolshed/adorn/adorn.sld \
 toolshed/adorn/adornment.scm toolshed/adorn/binding-mesg-handlers.scm \
 toolshed/adorn/char-mesg-handlers.scm \
 toolshed/adorn/comment-mesg-handlers.scm toolshed/adorn/helpers.scm \
 toolshed/adorn/matching.scm toolshed/adorn/numeric-mesg-handlers.scm \
 toolshed/adorn/other-mesg-handlers.scm \
 toolshed/adorn/rt-syntax-handlers.scm \
 toolshed/adorn/symmetric-mesg-handlers.scm
	if test -e toolshed/adorn/adorn.c; then rm toolshed/adorn/adorn.c; fi &&\
	${GSC} -o $@ toolshed/adorn/adorn

gambit-samples.tgz: gambit-pristine.html gambit-css.html toolshed/scm-to-html \
                    .WAIT gambit.html gambit.cm.html gambit.info gambit.txt \
                    gauntlet.scm.html gauntlet.scm.cm.html html-modules \
                    html-modules-cm
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		mkdir -p $$tmp/gambit-samples/{adorn,lib} &&\
		cp gambit.{cm.html,html,info,txt} gambit-{pristine,css}.html \
			gauntlet.scm{,.cm}.html $$tmp/gambit-samples &&\
		cp -R html-modules html-modules-cm $$tmp/gambit-samples &&\
		cd toolshed &&\
		${set-scm_to_html} &&\
		for scm in ${lib-samples}; do\
			$${scm_to_html} ../${src-lib}/$${scm}.scm &&\
			$${scm_to_html} -c ../${src-lib}/$${scm}.scm &&\
			mv $${scm}.scm{,.cm}.html $$tmp/gambit-samples/lib;\
		done &&\
		for scm in adorn/*.scm adorn/*.sld; do\
			$${scm_to_html} $$(realpath "$${scm}") &&\
			$${scm_to_html} -c $$(realpath "$${scm}") &&\
			mv "$${scm##*/}"{,.cm}.html $$tmp/gambit-samples/adorn;\
		done &&\
		cd $$tmp &&\
		if test -n "$$(command -v pax)"; then\
			readonly archive='pax -w';\
		else\
			readonly archive='tar -c';\
		fi;\
		$$archive -z -f "$$OLDPWD"/../$@ gambit-samples;\
	}

gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

gambit.txt: gambit.txi
	texi2any -o $@ --plaintext gambit.txi

gambit-pristine.html: gambit-pristine.txi toolshed/macros+vars.txi
	texi2any -o $@ --html --no-split gambit-pristine.txi

gambit-pristine.txi: toolshed/macros+vars.txi

gambit-css.html: gambit-pristine.txi toolshed/gambit.css
	texi2any -o $@ --html --no-split --css-include=toolshed/gambit.css \
		gambit-pristine.txi

highlight: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	readonly scm=$$(realpath "${SCM}") &&\
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} "$$scm" &&\
	mv "$${scm##*/}".html ../"$$(basename ${SCM})".html

highlight-cm: toolshed/gambit-examples.cm.css toolshed/scm-to-html.scm
	readonly scm=$$(realpath "${SCM}") &&\
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} -c "$$scm" &&\
	mv "$${scm##*/}".cm.html ../"$$(basename ${SCM})".cm.html

toolshed/gambit.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm > gambit.css

toolshed/gambit.cm.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm -c > gambit.cm.css

toolshed/gambit-examples.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm -e > gambit-examples.css

toolshed/gambit-examples.cm.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm -c -e > gambit-examples.cm.css

toolshed/macros+vars.txi: toolshed/write-macros+vars.scm
	cd toolshed && ${GSI} -f write-macros+vars.scm > macros+vars.txi

gauntlet.scm.html: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} examples/gauntlet.scm &&\
	mv gauntlet.scm.html ../gauntlet.scm.html

gauntlet.scm.cm.html: toolshed/gambit-examples.cm.css toolshed/scm-to-html.scm
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} -c examples/gauntlet.scm &&\
	mv gauntlet.scm.cm.html ../gauntlet.scm.cm.html

html-modules: ${html-common-deps} toolshed/gambit.css
	test -d html-modules || mkdir -p html-modules
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=toolshed/gambit.css\
			gambit.txi &&\
		for f in $$tmp/*.html; do\
			sed -f toolshed/parenthesize-defs.sed "$$f"\
				> html-modules/"$${f##*/}";\
		done;\
	}

html-modules-cm: ${html-common-deps} toolshed/gambit.cm.css
	test -d html-modules-cm || mkdir -p html-modules-cm
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=toolshed/gambit.cm.css\
			gambit.txi &&\
		for f in $$tmp/*.html; do\
			sed -f toolshed/parenthesize-defs.sed "$$f"\
				> html-modules-cm/"$${f##*/}";\
		done;\
	}

gambit.html: ${html-common-deps} toolshed/gambit.css
	texi2any -o - --html --no-split --css-include=toolshed/gambit.css \
		gambit.txi | sed -f toolshed/parenthesize-defs.sed > $@

gambit.cm.html: ${html-common-deps} toolshed/gambit.cm.css
	texi2any -o - --html --no-split --css-include=toolshed/gambit.cm.css \
		gambit.txi | sed -f toolshed/parenthesize-defs.sed > $@

gambit.txi: gambit-pristine.txi procedures/a/pairs-lists.txi \
            procedures/a/strings.txi
	sed 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1a\//'\
		gambit-pristine.txi > $@

procedures/a/pairs-lists.txi: procedures/pairs-lists.txi toolshed/annotate-txi.scm
	readonly txi=pairs-lists.txi && ${annotate-procedures-file}

procedures/a/strings.txi: procedures/strings.txi toolshed/annotate-txi.scm
	readonly txi=strings.txi && ${annotate-procedures-file}
