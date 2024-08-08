#!/bin/bash

set -vex -o pipefail

test -n "${ASSET_BASENAME}"
test -n "${GH_TAG}"

cmd="${1}" ; shift
cmd_pack="pack"
cmd_upload="upload"

archives=( "${ASSET_BASENAME}-source-code"{.zip,.tar.gz} )

for archive in "${archives[@]}" ; do
    case "${cmd}" in
        "${cmd_pack}" )
            pipx run git-archive-all --verbose "${archive}" | grep -v "/3rd/"
        ;;
        "${cmd_upload}" )
            label="Source code - complete (${archive#*.})"
            gh release upload --clobber "${GH_TAG}" "${archive}#${label}"
        ;;
        * )
            echo "Error: invalid command '${cmd}'" >&2
            exit 1
        ;;
    esac
done
