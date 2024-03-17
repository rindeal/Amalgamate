#!/bin/sh

set -evx

test -n "${CHECKSUM_PATH}"

echo "<details>"
echo "<summary>"
echo "<h2>Checksums</h2>"
echo "<sub><sup>(click here to toggle section visibility)</sup></sub>"
echo "</summary>"
echo
echo "Verify donwloaded files using this command:"
echo '```sh'
echo 'sha256sum --check --ignore-missing '"$(basename "${CHECKSUM_PATH}")"
echo '```'
echo
echo "Or directly using a checksum value from the table below like this:"
echo '```sh'
echo 'echo $HASH $FILEPATH | sha256sum --check -'
echo '```'
echo
echo "File | SHA-256"
echo "--- | ---"
awk '{print $2, "|", $1}' < "${CHECKSUM_PATH}"
echo
echo "</details>"
echo
