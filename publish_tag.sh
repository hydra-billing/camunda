#!/bin/bash

mkdir target
export SRC_PATH="/camunda/lib/camunda-ext*.jar"
docker run $REPO:$TRAVIS_JOB_ID bash -c "tar -cf - -C \$(dirname $SRC_PATH) \$(basename $SRC_PATH)" | tar -C ./target/ -xf -

export SRC_PATH="/camunda/webapps/pizza*.war"
docker run $REPO:$TRAVIS_JOB_ID bash -c "tar -cf - -C \$(dirname $SRC_PATH) \$(basename $SRC_PATH)" | tar -C ./target/ -xf -

if [[ "x$VERSION" == "x" ]]; then
  export VERSION=$(zipgrep -h -o "Implementation-Version: (.*)" ./target/camunda-ext-*.jar | cut -d \: -f 2 | tr -d "[:space:]")
fi

if [[ "x$COMMIT" == "x" ]]; then
  export BUILD=$(zipgrep -h -o "Implementation-Build: (.*)" ./target/camunda-ext-*.jar | cut -d \: -f 2 | tr -d "[:space:]"); export COMMIT=${BUILD::8}
fi

if [[ "x$VERSION" != "x" ]]; then
  git tag -d "$VERSION"
  git tag "$VERSION"
  git remote add origin-travis "https://${GITHUB_TOKEN}@github.com/$REPO.git" > /dev/null 2>&1
  git push --tags -f --set-upstream origin-travis --quiet
  exit 0
fi