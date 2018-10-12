#!/usr/bin/env bash

BRANCH_NAME=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

branches_per_version_file_path="./releases/branches_per_version.json"

git checkout -qf master

FOUND=$(cat "$branches_per_version_file_path" | grep "$BRANCH_NAME");

if [ ! -z "$FOUND" ]; then
    RESULT="> $BRANCH_NAME [FAILURE] (the bug already exists in Bears)"
    echo -e "$RED""$RESULT"
    exit 1
fi

RESULT="> $BRANCH_NAME [OK]"
echo -e "$GREEN""$RESULT""$NC"
