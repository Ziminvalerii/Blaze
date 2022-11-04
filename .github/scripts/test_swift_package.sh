#!/bin/bash

set -eo pipefail

cd "$NAME"-package; swift test --parallel; cd ..
