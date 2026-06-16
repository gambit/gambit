#!/usr/bin/env bash
mv '#.scm' backup.scm
cp coverage-test.scm '#.scm'
redirect="1>/dev/null"
if [[ $1 == "--debug" ]]; then
    redirect=""
fi
script="#!/usr/bin/env bash
if [[ \"\$(grep -c check \$1)\" == 0 ]]; then
    echo \" skipping \$1 \"
    exit 0
else
    if ../../gsi/gsi -:=../../ \$1 $redirect 2>tmp ;then
        cat tmp >>tested.txt
    fi
fi
"
echo "$script" > test.sh
chmod +x test.sh
find . -mindepth 2 -maxdepth 2 -type f -name '*.scm' -print -exec ./test.sh {} '&' \;
rm test.sh
cat tested.txt | sort | uniq > t.txt
mv t.txt tested.txt
mv backup.scm '#.scm'
echo "tested procedures are in tested.txt"
