#!/bin/bash

LAST_COMMIT_MESSAGE=$(git name-rev --name-only HEAD)
LAST_COMMIT_HASH=$(git rev-parse --short HEAD)
echo "Fetching existing docs..."
echo -e "Host git.us1.engaugetx.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
git clone dokku@git.us1.engaugetx.com:iosdocs.engaugetx.com docs
echo "Generating documentation..."
jazzy --min-acl public
echo "Navigating to docs dir"
cd docs
git config --global user.name "Medullan Platform Solutions"
git config --global user.email "mps@medullan.com"
git add . 

git commit -m "Release for v$CIRCLE_TAG $LAST_COMMIT_HASH"
echo "Deploying docs..."
git push origin master
echo "Stepping out of docs dir"
cd ../
echo "Docs successfully deployed."

echo "Deploying the pod..."
pod repo add EngaugeTxPodSpecs https://github.com/medullan/engauge-tx-pod-specs.git
pod repo push EngaugeTxPodSpecs EngaugeTx.podspec --allow-warnings


