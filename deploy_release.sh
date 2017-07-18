#!/bin/bash

echo "Deploying the pod..."
pod repo add EngaugeTxPodSpecs https://github.com/medullan/engauge-tx-pod-specs.git
pod repo push EngaugeTxPodSpecs EngaugeTx.podspec --allow-warnings
echo "pod deploy complete."
