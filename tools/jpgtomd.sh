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
    fileTitle=$(echo "${f}" | sed 's/zonephotos-\(.*\)-[0-9]\+\.jpg/\1/g')
    readarray -d, -t TAGS < <(exiftool -sep ',' -S -subject "${f}" | sed -e 's/^Subject: //g')
    cat > "${MD_DIR}/${fileTitle}-${i}.md" << EOT
---
images:
- /images/$(basename "${IMG_DIR}")/${f}
title: ${fileTitle}
tags:
$(printf -- "- %s\n" "${TAGS[@]}")
hideExif: true
hideTitle: true
hideDate: true
---
EOT
done
