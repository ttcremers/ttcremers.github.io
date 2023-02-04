#!/bin/bash
set -euxo pipefail

if [[ $# -lt 2 ]] ; then
  echo './jpgtomd.sh <images-directory> <target-markdown-directory>'
  exit 1
fi

IMG_DIR=$1
MD_DIR=$(realpath "${2}")

if [ ! -d "${IMG_DIR}" ]
then
  echo "Not a directory: ${IMG_DIR}"
  exit 1
fi

if [ ! -d "${MD_DIR}" ]
then
  echo "Not a directory: ${MD_DIR}"
  exit 1
fi

cd "${IMG_DIR}"

files=(*.jpg)
i=0
for f in "${files[@]}"; do
    i=$(( i + 1 ))
    fileTitle=$(echo "${f}" | sed 's/^\(.*\)-TheodoorThomas\.jpg/\1/g')
    humanTitle=$(echo "${fileTitle}" |  tr '_-' ' ')
    basefilename=$(basename "${IMG_DIR}")
    cat > "${MD_DIR}/${basefilename}-${fileTitle}-${i}.md" << EOT
---
images:
- /images/life-in-contrast/${f}
title: ${humanTitle}
weight: ${i}
tags:
- archive
- life-in-contrast
- work
hideExif: true
---
EOT
done
