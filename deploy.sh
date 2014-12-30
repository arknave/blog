#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

cd $DIR
if [ `pwd` != "$DIR" ]
then
    echo "Can't get into the right directory"
    exit 1
fi

COMMIT=$(git log -1 HEAD --pretty=format:%H)
SHA=${COMMIT:0:8}

cp -r _site/* deploy

cd deploy

git add --all
git commit -m "generated from $SHA" -q
git push origin master --force -q

