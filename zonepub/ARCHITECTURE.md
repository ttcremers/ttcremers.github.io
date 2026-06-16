# ZonePub Architecture

ZonePub is a local publishing assistant.

It is not part of the public website runtime.

The public website remains a static Hugo site hosted on GitHub Pages.

## System context

```text
digiKam
  ↓ export selected images
ZonePub on local machine / muddermilk
  ↓ writes files into local repo checkout
Git branch + pull request
  ↓ merge
GitHub Pages Hugo build
  ↓
zone.photos
```

## Why local?

ZonePub solves an authoring and publishing problem, not a public website problem.

The public site does not need dynamic logic.

Running ZonePub locally keeps the website simple and avoids turning hosting into infrastructure work.

A local tool can:

- read exported files
- inspect the local repository
- show a review UI
- run Git commands
- create pull requests
- stay private

## Why not run this next to the website?

Moving the website to a dynamic host just to run publishing logic would make the public site more fragile.

GitHub Pages is currently useful because it is boring, free, static, and reliable.

The missing piece is not runtime behavior.

The missing piece is a better publishing workflow before content reaches GitHub Pages.

## Main responsibilities

ZonePub has five responsibilities:

1. Import exported image files.
2. Extract metadata.
3. Compare against existing published content.
4. Present a reviewable batch.
5. Generate Git changes and a pull request.

Everything else is secondary.

## Boundaries

### digiKam

Owns the archive.

Owns curation state.

Owns descriptive metadata.

### ZonePub

Owns the local publishing queue.

Owns batch review.

Owns generation of publication artifacts.

### Git repository

Owns published source content.

Records publication history.

### Hugo

Builds the static website.

### GitHub Pages

Hosts the static website.

## Data flow

### Import

The user exports selected images from digiKam to a configured import folder.

ZonePub reads the folder and creates queue items.

### Metadata extraction

ZonePub reads embedded metadata and/or sidecars.

It turns metadata into proposed Hugo front matter.

### Duplicate detection

ZonePub scans existing Markdown files in the repository.

It checks existing image paths, filenames, slugs, and optional hashes.

### Review

The user reviews the batch locally.

The user can decide whether to publish, skip, or fix metadata in digiKam and re-export.

### Publish

ZonePub writes image and Markdown files to the repository.

ZonePub creates a Git branch and pull request.

## State

ZonePub may use local state for the queue.

SQLite is enough for V1 if state is needed.

The queue is not authoritative archive data.

It is temporary publishing state.

If the queue is lost, the source images and metadata still exist in digiKam and can be exported again.

## Repository awareness

ZonePub must understand the current website repository.

It should know:

- where image files live
- where Markdown files live
- which project tags map to which collection paths
- which images are already referenced
- whether a target path already exists

This repository awareness is what prevents duplicate publication.

## Suggested path conventions

Existing site conventions should be respected.

Example image paths:

```text
static/images/life-in-contrast/...
static/images/life-in-tone/...
static/images/phart/...
```

Example Markdown paths:

```text
content/work/life-in-contrast/...
content/work/life-in-tone/...
content/work/phart/...
```

Exact mappings should be configured, not hard-coded everywhere.

## Configuration

ZonePub should use a small config file.

Example concepts:

```yaml
repository:
  root: ~/sites/zone.photos

import:
  folder: ~/zonepub/import

collections:
  life-in-contrast:
    image_dir: static/images/life-in-contrast
    content_dir: content/work/life-in-contrast
  life-in-tone:
    image_dir: static/images/life-in-tone
    content_dir: content/work/life-in-tone
```

This keeps future reuse possible for other Hugo sites.

## Failure modes

ZonePub should be conservative.

If unsure, it should warn and stop rather than publish.

Examples:

- duplicate suspected
- collection cannot be determined
- target file already exists
- required metadata is missing
- Git working tree is dirty
- branch already exists
- GitHub authentication unavailable

## AI boundary

AI may later suggest descriptions, titles, alt text, or tags.

But AI must not be required.

The non-AI workflow must remain fully functional.

AI output should be treated as suggestions, not source of truth.

## Future reuse

ZonePub starts as a Zone Photos tool.

The design should not make reuse impossible.

Other Hugo sites may later benefit from the same pattern:

```text
source app / local archive
  ↓
local publishing assistant
  ↓
Git PR
  ↓
static website
```

Do not abstract too early.

Just avoid hard-coding unnecessary assumptions.
