#!/bin/bash

set -vex

test -n "${ASSET_BASENAME}"
test -n "${GH_TAG}"
test -n "${WORK_DIR}"
test -n "${REPO_DIR}"

command -v pipx >/dev/null
command -v gh >/dev/null

archives=( "${ASSET_BASENAME}-source-code."{zip,tar.gz} )

cmd="${1}"
cmd_pack="pack"
cmd_upload="upload"

test "${cmd}" = "${cmd_pack}" || test "${cmd}" = "${cmd_upload}"

cd "${WORK_DIR}"

for arch in "${archives[@]}"
    case "${cmd}" in

        "${cmd_pack}" )
            pipx run git-archive-all --verbose -C "${REPO_DIR}" "${arch}" | grep -v "/3rd/"
        ;;

        "${cmd_upload}" )
            label="Source code full (${arch#*.})"
            gh release upload --clobber "${GH_TAG}" "${arch}#${label}"
        ;;

        * )
            exit 1
        ;;

    esac
done
