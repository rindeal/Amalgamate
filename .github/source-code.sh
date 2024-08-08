#!/bin/bash

set -vex -o pipefail

test -n "${ASSET_BASENAME}"
test -n "${GH_TAG}"

cmd="${1}" ; shift
cmd_pack="pack"
cmd_upload="upload"

for type in 'zip' 'tar.gz' ; do
    archive="${ASSET_BASENAME}-source-code.${type}"
    case "${cmd}" in
        "${cmd_pack}" )
            pipx run git-archive-all --verbose "${archive}" | grep -v "/3rd/"
        ;;
        "${cmd_upload}" )
            label="Source code - complete (${type})"
            gh release upload --clobber "${GH_TAG}" "${archive}#${label}"
        ;;
        * )
            echo "Error: invalid command '${cmd}'" >&2
            exit 1
        ;;
    esac
done
