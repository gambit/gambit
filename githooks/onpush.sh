#!/bin/sh

COMMIT=`git rev-parse HEAD`

success()
{
  curl -X POST -H "Content-type: application/json" --data "{\"text\":\"<http://gambit.iro.umontreal.ca:8000|Build> of commit <https://github.com/udem-dlteam/gambit/commit/$COMMIT|$COMMIT> succeeded\"}" https://hooks.slack.com/services/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
}

failure()
{
  curl -X POST -H "Content-type: application/json" --data "{\"text\":\"<http://gambit.iro.umontreal.ca:8000|Build> of commit <https://github.com/udem-dlteam/gambit/commit/$COMMIT|$COMMIT> failed\"}" https://hooks.slack.com/services/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
}

if ( rm -rf gsc-boot boot \
     && ./configure --enable-single-host CC="gcc-8" \
     && make -j \
     && make check ) ; then
    success
else
    failure
fi
