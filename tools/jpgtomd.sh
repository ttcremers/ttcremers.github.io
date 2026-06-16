#!/bin/bash
set -euo pipefail

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

slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

title_from_filename() {
  local filename=$1
  basename "${filename}" .jpg \
    | sed -E 's/^zonephotos-//; s/-[0-9]+$//' \
    | sed -E 's/-/ /g' \
    | sed -E 's/\b(.)/\u\1/g'
}

frontmatter_escape() {
  echo "$1" | sed 's/"/\\"/g'
}

cd "${IMG_DIR}"

shopt -s nullglob
files=(*.jpg *.jpeg *.JPG *.JPEG)
i=0
for f in "${files[@]}"; do
    i=$(( i + 1 ))

    embedded_title=$(exiftool -S -s -Title "${f}" 2>/dev/null || true)
    object_name=$(exiftool -S -s -ObjectName "${f}" 2>/dev/null || true)
    headline=$(exiftool -S -s -Headline "${f}" 2>/dev/null || true)
    caption=$(exiftool -S -s -Description "${f}" 2>/dev/null || true)
    city=$(exiftool -S -s -City "${f}" 2>/dev/null || true)
    country=$(exiftool -S -s -Country "${f}" 2>/dev/null || true)

    title="${embedded_title:-${object_name:-${headline:-$(title_from_filename "${f}")}}}"
    title=$(frontmatter_escape "${title}")

    description="${caption:-Fine art photography by Thomas T. Cremers.}"
    description=$(frontmatter_escape "${description}")

    location_parts=()
    [[ -n "${city}" ]] && location_parts+=("${city}")
    [[ -n "${country}" ]] && location_parts+=("${country}")
    location="$(IFS=', '; echo "${location_parts[*]:-}")"

    image_alt="${title}"
    if [[ -n "${location}" ]]; then
      image_alt="${image_alt}, photographed in ${location}"
    fi
    image_alt="${image_alt} | Zone Photos"
    image_alt=$(frontmatter_escape "${image_alt}")

    md_slug=$(slugify "${title}")
    if [[ -z "${md_slug}" ]]; then
      md_slug=$(basename "${f}" | sed -E 's/\.[^.]+$//' | slugify)
    fi

    mapfile -t tags < <(
      {
        exiftool -sep ',' -S -s -Subject "${f}" 2>/dev/null | tr ',' '\n'
        exiftool -sep ',' -S -s -Keywords "${f}" 2>/dev/null | tr ',' '\n'
        [[ -n "${city}" ]] && echo "${city}"
        [[ -n "${country}" ]] && echo "${country}"
      } \
        | sed -E 's/^ +| +$//g' \
        | sed '/^$/d' \
        | while read -r tag; do slugify "${tag}"; done \
        | sed '/^$/d' \
        | sort -u
    )

    cat > "${MD_DIR}/${md_slug}-${i}.md" << EOT
---
images:
- /images/$(basename "${IMG_DIR}")/${f}
title: "${title}"
description: "${description}"
imageAlt: "${image_alt}"
tags:
$(printf -- "- %s\n" "${tags[@]}")hideExif: true
hideTitle: true
hideDate: true
---
EOT
done
