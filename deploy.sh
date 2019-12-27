#!/bin/bash

mkdir target

export SRC_PATH="/camunda/lib/camunda-ext*.jar"
docker run $REPO:$TRAVIS_JOB_ID bash -c "tar -cf - -C \$(dirname $SRC_PATH) \$(basename $SRC_PATH)" | tar -C ./target/ -xf -

if [[ "x$VERSION" == "x" ]]; then
  export VERSION=$(zipgrep -h -o "Implementation-Version: (.*)" ./target/camunda-ext-*.jar | cut -d \: -f 2 | tr -d "[:space:]")
fi

if [[ "x$COMMIT" == "x" ]]; then
  export BUILD=$(zipgrep -h -o "Implementation-Build: (.*)" ./target/camunda-ext-*.jar | cut -d \: -f 2 | tr -d "[:space:]"); export COMMIT=${BUILD::8}
fi

export PREV_DIR=$(pwd)
cd ..
git clone https://github.com/latera/camunda-ext.git master
cd master
export LATEST_MASTER_COMMIT=$(git log -n1 --pretty=format:'%H')
git checkout tags/$VERSION
export LATEST_COMMIT=$(git log -n1 --pretty=format:'%H')
cd $PREV_DIR

export BRANCH="$TRAVIS_BRANCH"
if [[ "$LATEST_MASTER_COMMIT" == "$LATEST_COMMIT" ]]; then
export BRANCH=master
fi

if [[ "x$BRANCH" == "xmaster" ]]; then
  docker tag $REPO:$TRAVIS_JOB_ID $REPO:latest && docker push $REPO:latest
fi;

if [[ "x$TRAVIS_TAG" != "x" ]]; then
  docker tag $REPO:$TRAVIS_JOB_ID $REPO:$TRAVIS_TAG && docker push $REPO:$TRAVIS_TAG
fi;

if [[ "x$VERSION" != "x" ]]; then
  docker tag $REPO:$TRAVIS_JOB_ID $REPO:$VERSION && docker push $REPO:$VERSION
fi

if [[ "x$VERSION" != "x" && "x$COMMIT" != "x" ]]; then
  docker tag $REPO:$TRAVIS_JOB_ID $REPO:$VERSION-$COMMIT && docker push $REPO:$VERSION-$COMMIT
fi