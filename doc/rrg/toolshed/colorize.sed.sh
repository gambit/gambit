# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
readonly chars="$(sort -r toolshed/data/char-names)" # longest first
readonly sharps="$(<toolshed/data/sharp-objects)"
readonly syntax="$(<toolshed/data/syntax-words)"
readonly vectors="$(<toolshed/data/homogeneous-vectors)"

readonly punct=\[\'',\\`)([:blank:][]'
readonly ident='[-[:alnum:]!$%&*+./:<=>?@^_~]'

readonly box='@hashchar{}@ampchar{}'
readonly char='@hashchar{}@backslashchar{}'

# We only want to colorize the text to the left of "@ok{".  Store all
# text to the right of "@ok{" in the hold space; at the end, use a
# substitution to remove that text from the pattern space.
printf '%s\n' '/^@lisp$/,/^@end lisp$/ {
  /@ok{/ {
    h
    x
    s/^.*@ok{//
    x
  }'

printf '  %s\n' '/#./ {'

# Wrap each #!sharp in @sharp{}.
for s in $sharps; do
    printf '    %s\n' \
           "s/^#!$s/@sharp{@hashchar{}@U{0021}$s}/" \
           "s/\\($punct\\)#!$s/\\1@sharp{@hashchar{}@U{0021}$s}/g"
done

# wrap each #\character in @char{}.
for s in $chars 'x[[:xdigit:]]\{1,\}' 'u[[:xdigit:]]\{4\}' 'U[[:xdigit:]]\{8\}'; do
    printf '    %s\n' \
           "s/^#\\\\\\($s\\)/@char{$char\\1}/" \
           "s/\\($punct\\)#\\\\\\($s\\)/\\1@char{$char\2}/g"
done

printf '    %s\n' \
       "s/^#\\\\\"/@char{$char@U{0022}}/" \
       "s/\\($punct\\)#\\\\\"/\\1@char{$char@U{0022}}/g" \
       "s/^#\\\\\\(.\\)/@char{$char\\1/" \
       "s/\\($punct\\)#\\\\\\(.\\)/\\1@char{$char\2}/g"

# Wrap each Boolean in @boolean{}.
for s in true false f t; do
    printf '    %s\n' \
           "s/^#\\($s\\)/@boolean{@hashchar{}$s}/" \
           "s/\\($punct\\)#$s/\\1@boolean{@hashchar{}$s}/g"
done

# Wrap each #& in @box{}.
printf '    %s\n' \
       "s/^#&/@box{$box}/g" \
       "s/\\($punct\\)#&/\\1@box{$box}/g"

# Avoid dimming empty vectors.
for s in $vectors ''; do
    printf '    %s\n' \
           "s/^#$s(\\([[:blank:]]*\\))/@hashchar{}$s@U{0028}\\1@U{0029}/" \
           "s/\\($box\\)#$s(\\([[:blank:]]*\\))/\\1@hashchar{}$s@U{0028}\\1@U{0029}/" \
           "s/\\($punct\\)#$s(\\([[:blank:]]*\\))/\\1@hashchar{}$s@U{0028}\\2@U{0029}/g"
done

printf '  %s\n' '}'

# Avoid dimming the empty list.
printf '  %s\n' \
       "s/^(\\([[:blank:]]*\\))/@U{0028}\\1@U{0029}/" \
       "s/\\(@box{$box}\\)(\\([[:blank:]]*\\))/\\1@U{0028}\\2@U{0029}/g" \
       "s/\\($punct\\)(\\([[:blank:]]*\\))/\\1@U{0028}\\2@U{0029}/g" \

# Wrap each special syntactic form in @syntax{}.
for form in $syntax; do
    case "$form" in
        *\**) s="${form%%\**}\\*${form##*\*}" ;;
        *)    s="$form" ;;
    esac

    printf '  %s\n' \
           "s/\\(([[:blank:]]*\\)$s\\\$/\\1@syntax{$s}/g" \
           "s/\\(([[:blank:]]*\\)$s\\([])[:blank:]]\\)/\\1@syntax{$s}\\2/g"
done

# Wrap each keyword: in @keyword{}.
printf '  %s\n' \
       "s/^\\($ident\\{1,\\}:\\)\\($punct\\)/@keyword{\\1}\\2/g" \
       "s/\\($punct\\)\\($ident\\{1,\\}:\\)\\($punct\\)/\\1@keyword{\\2}\\3/g" \
       "s/\\($punct\\)\\($ident\\{1,\\}:\\)\\($punct\\)/\\1@keyword{\\2}\\3/g" \
       "s/\\($punct\\)\\($ident\\{1,\\}:\\)\$/\\1@keyword{\\2}/g"

# Dim vectors.
for s in $vectors ''; do
    printf '  %s\n' \
           "s/#$s(/@paren{@hashchar{}$s@U{0028}}/g"
done

# Dim circular lists.
printf '  %s\n' \
       's/#\([[:digit:]]\{1,\}=\)(/@paren{@hashchar{}\1@U{0028}}/g'

# Dim other "punctuation" characters.
printf '  %s\n' \
       "s/'/@paren{@U{0027}}/g" \
       's/`/@paren{@U{0060}}/g' \
       's/,/@paren{@comma{}}/g' \
       's/(/@paren{@U{0028}}/g' \
       's/)/@paren{@U{0029}}/g' \
       's/\[/@paren{@U{005B}}/g' \
       's/]/@paren{@U{005D}}/g' \
       's/@atchar{}/@paren{@atchar{}}/g' \
       's/^\.[[:blank:]]/@paren{@U{002E}}/' \
       's/\([[:blank:]]\)\.\([[:blank:]]\)/\1@paren{@U{002E}}\2/' \
       's/\([[:blank:]]\)\.$/\1@paren{@U{002E}}/'

# Wrap each "string" in @string{}.
printf '  %s\n' \
       's/\\"/@backslashchar{}@U{0022}/g' \
       's/"\([^"]*\)"/@string{"\1"}/g'

# Add back the part we've been keeping in the hold space.
printf '  %s\n' \
       '/@ok{/ {' \
       '  s/@ok{.*$/@ok{/' \
       '  G' \
       '  s/\n//' \
       '}'

# Wrap comments last so they may occur to the right of "@ok{..}".
printf '  %s\n' 's/\([[:blank:]]\);\(.*\)$/\1@codecomment{;\2}/
}'
