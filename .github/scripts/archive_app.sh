#!/bin/bash

set -eo pipefail

xcodebuild -project "$NAME".xcodeproj \
            -scheme "$NAME" \
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/"$NAME".xcarchive \
            clean archive | xcpretty
