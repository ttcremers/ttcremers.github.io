# ZonePub PRD

This document describes the first useful version of ZonePub.

It is intentionally small.

ZonePub should first become a reliable local publishing workflow. Clever features can come later.

## Problem

Zone Photos is a static Hugo website hosted on GitHub Pages.

The photo archive, curation state, and image metadata live in digiKam.

Publishing portfolio images to the website currently requires remembering a fragile manual workflow around exported JPEG files, metadata, Hugo Markdown, Git branches, and pull requests.

Because publishing happens only occasionally, the workflow is easy to forget.

The result is friction.

Friction means fewer images get published, metadata becomes inconsistent, and future maintenance becomes archaeological work.

## Goal

ZonePub should make publishing selected portfolio images from digiKam to Zone Photos repeatable, reviewable, and safe.

It should help convert exported, metadata-rich images into Hugo image pages and a GitHub pull request.

## Non-goals for V1

V1 explicitly does not include:

- AI-generated descriptions
- AI tagging
- direct digiKam database integration
- cloud hosting
- public API
- multi-user support
- automatic publishing to `master`
- automatic pull request merging
- image renaming
- image-file redirect handling
- replacing digiKam
- becoming a second metadata database

## Users

### Primary user

Thomas Cremers.

The user manages the photo archive in digiKam, curates work over time, and publishes selected portfolio images to Zone Photos.

### Secondary users

Future maintainers such as Codex, G3, or future Tommy reading the repository with little context.

The system must be understandable from the repository documents alone.

## Source of truth

| Data | Source of truth |
| --- | --- |
| Image archive | digiKam |
| Descriptive metadata | digiKam / XMP / IPTC |
| Curation state | digiKam color labels |
| Published website content | Git repository |
| Public website | Hugo build on GitHub Pages |
| Publishing queue | ZonePub local state |

ZonePub does not own long-term metadata.

ZonePub is a publishing workshop.

## Curatorial model

The archive uses color labels as a staged selection process.

```text
Blue   = reviewed, potential
Yellow = selected
Green  = portfolio
```

V1 should assume that green images are the primary candidates for website publication.

V1 does not need to enforce this automatically if the first workflow uses an export folder, but the concept should guide the interface and documentation.

## MVP workflow

### 1. Export from digiKam

The user selects one or more portfolio images in digiKam and exports them to a configured ZonePub import folder.

Example:

```text
~/zonepub/import/
```

The exported files should include embedded metadata where possible.

### 2. Scan import folder

ZonePub scans the import folder and detects supported image files.

V1 may support JPEG only.

### 3. Extract metadata

For every image, ZonePub reads metadata using ExifTool or equivalent tooling.

Useful fields:

- Title
- ObjectName
- Headline
- Description
- Subject
- Keywords
- City
- Country
- Rating
- Color label, if available in exported metadata

### 4. Determine target collection

ZonePub determines the likely Hugo collection from metadata.

For V1, this can be based on known project-like tags:

- `life-in-contrast`
- `life-in-tone`
- `my-poland`
- `phart`

If no collection can be determined, the item should be flagged for manual review.

### 5. Detect duplicates

ZonePub scans the local Hugo repository to determine whether the image may already exist.

V1 duplicate signals:

- existing `images:` path in `content/work/**/*.md`
- same filename
- same or similar generated slug
- optional SHA256 file hash

The review UI should mark items as:

- new image
- existing image
- possible duplicate
- metadata update candidate

### 6. Review batch

ZonePub shows a local review page.

For every queued image, show:

- thumbnail
- source filename
- target image path
- target Markdown path
- title
- description
- imageAlt
- tags
- detected collection
- duplicate status
- warnings

The user must approve the batch before anything is committed.

### 7. Generate site files

After approval, ZonePub writes:

- image file into the correct `static/images/<collection>/` folder
- Hugo Markdown file into `content/work/<collection>/`

Generated Markdown should include:

```yaml
images:
- /images/<collection>/<filename>.jpg
title: "Descriptive title"
description: "Short description."
imageAlt: "Accessible visual description."
tags:
- life-in-contrast
- black-and-white
- street-photography
hideExif: true
hideTitle: true
hideDate: true
```

### 8. Create branch and pull request

ZonePub creates a short-lived Git branch.

Example:

```text
publish/zone-photos-2026-06-16
```

ZonePub commits the generated files, pushes the branch, and opens a pull request.

The pull request body should summarize:

- added images
- updated images
- generated Markdown pages
- touched collections
- warnings or duplicate concerns

### 9. User reviews and merges

The user reviews the pull request and merges manually.

GitHub Pages builds and deploys the static website.

## Acceptance criteria

V1 is useful when all of the following are true:

- A user can export JPEG files from digiKam into a folder.
- ZonePub can scan that folder.
- ZonePub can read useful metadata from each file.
- ZonePub can show a review page before publishing.
- ZonePub can detect obvious duplicates from the existing Hugo repo.
- ZonePub can generate Markdown and copy images into the correct repo paths.
- ZonePub can create a Git branch and commit changes.
- ZonePub can open a GitHub pull request.
- Nothing is published directly to `master`.
- The workflow can be understood from this repository without reading old chat history.

## MVP constraints

Keep V1 boring.

Prefer simple files, simple HTML, simple Python, and a local SQLite database if queue state is needed.

Do not build a framework cathedral.

Do not require AI.

Do not require a server on the public internet.

Do not couple V1 to digiKam internals unless the export-folder approach fails.

## Open questions

- Can digiKam export embedded title, description, keywords, city, country, and color label reliably?
- Can digiKam call an external tool with selected files in a comfortable way?
- Is an export-folder workflow good enough for V1?
- What exact metadata fields survive export from RAW/source files to JPEG?
- Which tags should map to which Hugo collection paths?
- Should ZonePub preserve original filenames or generate publication filenames for new images?
- How should ZonePub handle an existing image whose metadata changed in digiKam?
