#!/bin/bash
LAST_COMMIT_HASH=$(git rev-parse --short HEAD)
TAG_VERSION=$CIRCLE_TAG
DOC_BRANCH=ios-$TAG_VERSION

if [ -z ${CIRCLE_TAG+x} ]; then
    echo "CIRCLE_TAG is unset";
    echo "Docs NOT deployed!!!";
    exit 1;
fi

echo "Generating documentation..."
jazzy --min-acl public

echo ""
echo "$(mkdir tmp)"
cd tmp
rm -rf mps-docs

echo ""
git config user.name "Medullan Platform Solutions"
git config user.email "mps@medullan.com"

git clone https://github.com/medullan/mps-docs
cd mps-docs
echo ""
echo "$(mkdir source/sdk/ios)"
git checkout -b $DOC_BRANCH

cp -rf ../../docs/ source/sdk/ios/

git add .
git commit -am "add iOS API docs ${TAG_VERSION}" -m "Release for v$TAG_VERSION - $LAST_COMMIT_HASH"
git push --set-upstream origin $DOC_BRANCH

STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  "https://api.github.com/repos/medullan/mps-docs/pulls" \
  -H 'cache-control: no-cache' \
  -H "Authorization: token ${ACCESS_TOKEN}" \
  -H 'content-type: application/json' \
  -d '{
  "title": "[AutoGenerated] iOS API Docs: v'"$TAG_VERSION"'",
  "head": "'"$DOC_BRANCH"'",
  "base": "develop",
  "body": "verify, merge and delete the branch",
  "maintainer_can_modify": true
}')

echo ""
echo "Status Code: $STATUS"
if [ $STATUS -ge 400 ]; then
    echo "Pull Request Failed"
    exit 1
else
    echo "Pull Request Created!"
fi