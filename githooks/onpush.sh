#!/bin/sh

COMMIT=$(git rev-parse HEAD)
COMMIT_SHORT=$(git rev-parse --short HEAD)
SUBJECT=$(git show -s --pretty=format:'%s')
AUTHOR=$(git show -s --pretty=format:'%an')
BRANCH=$(git rev-parse --abbrev-ref HEAD)

result() {
    SLACK_HOOK=https://hooks.slack.com/services/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

    curl -s -X POST -H 'Content-type: application/json' \
        -d "{\"text\": \"<http://gambit.iro.umontreal.ca:8000|Build> of commit <https://github.com/udem-dlteam/gambit/commit/$COMMIT|$COMMIT_SHORT> $1\", \"attachments\": [{\"color\": \"$2\", \"title\": \"$SUBJECT\", \"title_link\": \"https://github.com/udem-dlteam/gambit/commit/$COMMIT\", \"fields\": [{\"title\": \"Author\", \"value\": \"$AUTHOR\", \"short\": true}, {\"title\": \"Branch\", \"value\": \"$BRANCH\", \"short\": true}]}]}" $SLACK_HOOK
}

if (rm -rf gsc-boot boot && \
    ./configure --enable-single-host CC="gcc-8" && \
    make -j && make check); then
    result succeeded good
else
    result failed warning
fi
