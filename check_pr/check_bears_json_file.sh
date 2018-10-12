#!/usr/bin/env bash

set -e

BRANCH_NAME="$TRAVIS_PULL_REQUEST_BRANCH"

RED='\033[0;31m'
GREEN='\033[0;32m'

command -v ajv >/dev/null 2>&1 || { echo >&2 "I require ajv (https://github.com/jessedc/ajv-cli) but it's not installed. Aborting."; exit 2; }

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
JSON_SCHEMA="$SCRIPT_DIR/bears-schema.json"
if [ ! -f $JSON_SCHEMA ]; then
    echo "> The json schema ($JSON_SCHEMA) cannot be found."
    exit 2
else
    echo "> JSON schema path: $JSON_SCHEMA"
fi

if [ -e "bears.json" ]; then
    if ajv test -s $JSON_SCHEMA -d bears.json --valid ; then
        echo "> bears.json is valid in $BRANCH_NAME"
    else
        RESULT="$BRANCH_NAME [FAILURE] (bears.json is invalid)"
        >&2 echo -e "$RED $RESULT"
        exit 1
    fi
else
    RESULT="$BRANCH_NAME [FAILURE] (bears.json does not exist)"
    >&2 echo -e "$RED $RESULT"
    exit 1
fi

RESULT="$BRANCH_NAME [OK]"
echo -e "$GREEN $RESULT"
