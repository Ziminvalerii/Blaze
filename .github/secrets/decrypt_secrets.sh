#!/bin/sh
set -eo pipefail

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/hyperinoProvisioningProfile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/hyperinoProvisioningProfile.mobileprovision


security create-keychain -p "" build.keychain
security import ./.github/secrets/Certificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "123" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain
