#!/bin/sh

REPO="https://github.com/ashinn/irregex.git"

FILES="\
irregex/irregex.scm,irregex.scm \
irregex/irregex-utils.scm,test/irregex-utils.scm \
irregex/tests/test-irregex-from-gauche.scm,test/test-irregex-from-gauche.scm \
irregex/tests/test-irregex-pcre.scm,test/test-irregex-pcre.scm \
irregex/tests/test-irregex-scsh.scm,test/test-irregex-scsh.scm \
irregex/tests/test-irregex-utf8.scm,test/test-irregex-utf8.scm \
"

CORRECTIONS=""

rm -rf irregex

git clone "$REPO"

for f in $FILES ; do
  to="${f#*,}"
  from="${f%,$to}"
  if ! diff "$from" "$to" > /dev/null 2>&1 ; then
    if [ "$CORRECTIONS" = "" ] ; then
      echo "*** The irregex library files are not up to date. Here are the diffs:"
      echo
    fi
    echo "==================================================== $to"
    diff "$from" "$to"
    CORRECTIONS="${CORRECTIONS}
cp $from $to"
  fi
done

if [ "$CORRECTIONS" = "" ] ; then
  # cleanup
  echo "*** The irregex library is up to date."
  rm -rf irregex
  exit 0
else
  # report needed corrections
  echo "===================================================="
  echo
  echo "*** To upgrade the irregex library try these commands:"
  echo "$CORRECTIONS"
  echo
  exit 1
fi
