#!/bin/bash
set -e
set -o pipefail

#LAST_COMMIT_HASH=$(git rev-parse --short HEAD)
#echo "Fetching existing docs..."
#echo -e "Host iosdocs.engaugetx.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
#git clone dokku@iosdocs.engaugetx.com:iosdocs.engaugetx.com docs

#echo "Generating documentation..."
#jazzy --min-acl public

#echo "Navigating to docs dir"
#cd docs

#echo "Deploying docs..."
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
#git add .
#git commit -m "Release for v$CIRCLE_TAG $LAST_COMMIT_HASH"
#git tag v$CIRCLE_TAG
#git push origin master --tags
#echo "Stepping out of docs dir"
#cd ../
#echo "Docs successfully deployed."

echo "Deploying the pod..."
pod repo add EngaugeTxPodSpecs https://github.com/medullan/engauge-tx-pod-specs.git
pod repo push EngaugeTxPodSpecs EngaugeTx.podspec --allow-warnings
echo "pod deploy complete."
