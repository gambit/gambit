# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
readonly testdir=${2:-tests}

while read -r line; do
    case "${line?}" in
        @deftypefn[[:blank:]]*)
            count=0
            line=${line#@deftypefn[[:blank:]]}
            trim=${line#[[:blank:]]}
            while [ ${#line} -gt ${#trim} ]; do
                line=$trim
                trim=${trim#[[:blank:]]}
            done
            lib=${line%%[[:blank:]]*}
            name=${line#$lib}
            trim=${name#[[:blank:]]}
            while [ ${#name} -gt ${#trim} ]; do
                name=$trim
                trim=${trim#[[:blank:]]}
            done
            name=${name#@/}
            trim=${name#[[:blank:]]}
            while [ ${#name} -gt ${#trim} ]; do
                name=$trim
                trim=${trim#[[:blank:]]}
            done
            name=${name%%[[:blank:]]*}
            test -d "$testdir"/"${lib:?}" || mkdir -p "$testdir"/"$lib" ;;
        @lisp)
            print=1
            file="$testdir"/"${lib:?}"/"${name:?}@t${count:?}"
            > "${file:?}" ;;
        @end[[:blank:]]lisp)
            count=$(( count + 1 ))
            print=0 ;;
        @end[[:blank:]]deftypefn)
            file=
            lib=
            name= ;;
        *)
            if [ "${print:-0}" -eq 1 ]; then
                line=${line%%@ok\{*\}*}
                line=${line%%@exception\{*\}*}
                line=${line%%@problem\{*\}*}
                trim=${line%[[:blank:]]}
                while [ ${#line} -gt ${#trim} ]; do
                    line=$trim
                    trim=${trim%[[:blank:]]}
                done
                printf '%s\n' "$line" >> "${file:?}"
            fi ;;
    esac
done < "${1:?procedure txi file}"
