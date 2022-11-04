#!/bin/bash

set -eo pipefail

xcodebuild -archivePath $PWD/build/"$NAME".xcarchive \
            -exportOptionsPlist .github/exportOptions.plist \
            -exportPath $PWD/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
