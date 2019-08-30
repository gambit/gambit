#!/bin/sh

echo "*** compiling define-library.scm"

gsc define-library.scm

mkdir github.com
mkdir github.com/feeley

cd github.com/feeley

echo "*** cloning https://github.com/feeley/base64.git"

git clone https://github.com/feeley/base64.git

echo "*** cloning https://github.com/feeley/crypto.git"

git clone https://github.com/feeley/crypto.git

echo "*** cloning https://github.com/feeley/digest.git"

git clone https://github.com/feeley/digest.git

echo "*** cloning https://github.com/feeley/homovector.git"

git clone https://github.com/feeley/homovector.git

echo "*** cloning https://github.com/feeley/nonneg-integer.git"

git clone https://github.com/feeley/nonneg-integer.git

echo "*** cloning https://github.com/feeley/random.git"

git clone https://github.com/feeley/random.git

cd ../..

echo "*** compiling libraries"

gsc -e '(load "define-library")' github.com/feeley/base64/base64.sld

gsc -e '(load "define-library")' github.com/feeley/crypto/aes/aes.sld
gsc -e '(load "define-library")' github.com/feeley/crypto/rsa/rsa.sld

gsc -e '(load "define-library")' github.com/feeley/digest/digest.sld

gsc -e '(load "define-library")' github.com/feeley/homovector/homovector.sld

gsc -e '(load "define-library")' github.com/feeley/nonneg-integer/nonneg-integer.sld

gsc -e '(load "define-library")' github.com/feeley/random/random.sld

echo "*** done!"
