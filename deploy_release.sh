#!/bin/bash

echo "Fetching existing docs..."
echo -e "Host git.us1.engaugetx.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
git clone dokku@git.us1.engaugetx.com:iosdocs.engaugetx.com docs
echo "Generating documentation..."
jazzy --min-acl public
echo "Navigating to docs dir"
cd docs
pwd
git add . 
git commit -m "Release"
echo "Deploying docs..."
git push origin master
echo "Stepping out of docs dir"
cd ../
pwd
echo "Docs successfully deployed."

echo "Deploying the pod..."
#pod repo add EngaugeTxPodSpecs https://github.com/medullan/engauge-tx-pod-specs.git
#pod repo push EngaugeTxPodSpecs EngaugeTx.podspec --allow-warnings
