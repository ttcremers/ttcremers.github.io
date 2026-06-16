# ZonePub

ZonePub is the planned local publishing assistant for the Zone Photos website.

It exists to bridge the gap between digiKam, Hugo, and GitHub Pages.

Zone Photos is a static Hugo website. GitHub Pages is intentionally simple: it builds and serves the site, but it cannot run custom publishing logic. digiKam is where the real image archive lives. ZonePub sits between them as a small local workflow tool.

The goal is not to create a second DAM, a cloud service, or an AI-dependent black box.

The goal is to make publishing selected portfolio images from digiKam to Zone Photos repeatable, reviewable, and boring.

## One sentence

ZonePub turns curated, metadata-rich images from digiKam into Hugo image pages and GitHub pull requests.

## Why this exists

The old workflow was based on `tools/jpgtomd.sh`:

```text
digiKam / Lightroom metadata
        ↓
exported JPEG files
        ↓
jpgtomd.sh
        ↓
Hugo Markdown image pages
        ↓
GitHub Pages
```

That worked, but it is easy to forget because publishing only happens occasionally.

It also leaves future Tommy and future G3 with too much archaeology:

- Which images should be published?
- Which metadata fields are expected?
- Which tags drive the website structure?
- Which images are already on the site?
- How do we avoid publishing the same image twice?
- How does the generated Markdown relate to the source metadata?

ZonePub is intended to make that explicit.

## Core principle

Metadata belongs in digiKam.

Not in Hugo.

Not in ZonePub.

Not in generated Markdown as the long-term source of truth.

The Hugo Markdown is a publication artifact. It may be edited for website-specific reasons, but the real descriptive metadata should live with the source image in digiKam/XMP/IPTC.

## Curatorial workflow

The photo archive uses color labels as an intentional cooling-down and selection process.

```text
Blue   = reviewed, potential
Yellow = selected
Green  = portfolio
```

The intent is:

1. Import and review new work.
2. Mark promising images blue.
3. After distance and time, review blue images.
4. Promote some to yellow, keep some blue, remove labels from others.
5. A few times per year, review yellow images.
6. Promote only the strongest images to green.
7. Green images may enter the Zone Photos publishing workflow.

This is deliberate. Distance from the work makes judgment better.

ZonePub should respect this.

It should not try to publish every good-looking image.

It should help publish images that have already survived the curatorial process.

## Project and tag model

Zone Photos has historically used tags and tag pages as website structure.

Important project-like tags include:

- `life-in-contrast`
- `life-in-tone`
- `my-poland`
- `phart`

These are not merely technical tags. They are artistic projects or viewing directions.

Other tags describe subject, style, process, or location:

- `black-and-white`
- `monochrome`
- `street-photography`
- `fine-art-photography`
- `fine-art-portraiture`
- `portrait`
- `conceptual-photography`
- `the-hague`
- `poland`
- `westland`

Some tags are useful internally but probably not important for website SEO or navigation, for example camera/gear tags such as `leica`.

ZonePub should preserve useful metadata, but the website should prioritize tags that help visitors and search engines understand the work.

## What ZonePub should do

ZonePub should run locally, probably on `muddermilk`, with a local checkout of this repository.

Example local checkout:

```text
~/sites/zone.photos/
```

The ZonePub code should live inside this repository:

```text
zonepub/
  README.md
  app/
  templates/
  static/
  config.example.yaml
```

This keeps the publishing logic versioned with the website it publishes to.

ZonePub should:

1. Receive or discover exported images from digiKam.
2. Read embedded metadata from the image and/or sidecar files.
3. Determine the intended collection/project.
4. Detect whether the image already exists on the website.
5. Queue new or changed images for review.
6. Show a local review page with image, title, description, alt text, tags, and target paths.
7. Generate Hugo Markdown and copy image files into the repo.
8. Create a Git branch.
9. Commit the generated files.
10. Push the branch to GitHub.
11. Open a pull request.
12. Let the user review, rebase if needed, and merge.
13. Let GitHub Pages build and deploy the static site.

## What ZonePub should not do

ZonePub should not become the archive.

It should not store authoritative metadata.

It should not silently overwrite digiKam metadata.

It should not require AI to function.

It should not publish directly to `master`.

It should not rename existing indexed image files unless there is a redirect strategy.

It should not try to replace digiKam.

## Static site, dynamic workshop

The website stays static.

The publishing workflow can be dynamic.

```text
digiKam
  ↓
ZonePub local workflow
  ↓
Git branch + pull request
  ↓
Hugo build on GitHub Pages
  ↓
zone.photos
```

This keeps the public site simple and robust.

The dynamic logic stays local, understandable, and replaceable.

## Metadata fields

ZonePub should prefer metadata already embedded in the image or available through sidecars.

Useful fields:

- Title
- ObjectName
- Headline
- Description
- Subject
- Keywords
- City
- Country
- Color label
- Rating
- Pick/reject state if available

The generated Hugo front matter should include:

```yaml
images:
- /images/<collection>/<filename>.jpg
title: "Human-readable descriptive title"
description: "One or two sentence description of the image."
imageAlt: "Useful visual description for accessibility and image search."
tags:
- life-in-contrast
- black-and-white
- street-photography
- the-hague
hideExif: true
hideTitle: true
hideDate: true
```

## Titles are not necessarily artwork titles

For many photographs, especially street photography, formal artwork titles may feel wrong.

That is fine.

For the website, `title` can be a descriptive publication title rather than an artistic title.

Example:

```text
Black and white street photograph of two people waiting outside a building
```

This is not meant to replace the artistic silence of the image.

It is a practical label for publishing, accessibility, and search.

## Duplicate detection

ZonePub must know what is already on the website.

It should scan the local repository for existing image references in Hugo Markdown.

Detection should consider:

- existing `images:` paths in `content/work/**/*.md`
- target image path
- filename
- file hash
- optional original source filename or source identifier, if available later

If an image already exists, ZonePub should treat the item as an update candidate, not as a new publication.

The review UI should clearly show:

```text
new image
existing image
possible duplicate
metadata update only
```

## Review-first publishing

Publishing should not be automatic.

A batch should be reviewed before files are committed.

The review page should show:

- thumbnail
- source filename
- target image path
- target Markdown path
- title
- description
- imageAlt
- tags
- detected project/collection
- duplicate status
- warnings

Only after review should ZonePub create commits and a pull request.

## Git workflow

Normal work happens on short-lived branches.

Do not commit directly to `master`.

ZonePub-generated branches should use a predictable name, for example:

```text
publish/zone-photos-2026-06-16
```

A generated pull request should explain:

- how many images were added
- how many image pages were added
- how many metadata-only updates were made
- which collections/tags were touched
- whether duplicate warnings were found

The user reviews and merges the pull request.

GitHub Pages then builds and deploys the site.

## AI assistance

AI may be useful later, but ZonePub must not depend on it.

Possible optional AI-assisted tasks:

- suggest better `imageAlt`
- suggest concise descriptions
- suggest missing tags
- identify weak generic titles

AI suggestions must be reviewed by the user.

The source of truth remains digiKam metadata and the user's curatorial judgment.

## Possible implementation shape

A first implementation can be simple:

- Python
- FastAPI or Flask
- SQLite queue
- ExifTool for metadata extraction
- plain HTML templates
- local Git checkout
- GitHub CLI or GitHub API for pull request creation

Suggested structure:

```text
zonepub/
  README.md
  app/
    main.py
    metadata.py
    repository.py
    queue.py
    publisher.py
  templates/
    index.html
    batch.html
    item.html
  static/
  config.example.yaml
  requirements.txt
```

No cloud queue.

No Kubernetes.

No public API unless explicitly needed.

## digiKam integration ideas

Start simple.

Possible input paths:

### Option A: export folder watcher

1. User exports selected green images from digiKam into a configured folder.
2. ZonePub watches or scans that folder.
3. ZonePub reads metadata and queues items for review.

This is likely the simplest first version.

### Option B: digiKam external tool

1. User selects an image in digiKam.
2. User invokes a `Send to ZonePub` tool/action.
3. digiKam or a wrapper script sends the exported file to ZonePub.

This may be nicer later, if digiKam exposes enough external-tool functionality.

### Option C: direct digiKam database access

Avoid this at first.

It may be powerful, but it couples ZonePub to digiKam internals.

Use only if export-based workflows are too clumsy.

## Existing legacy script

`tools/jpgtomd.sh` is the old publishing helper.

It is still useful as reference and may remain useful for batch generation.

ZonePub is intended to replace the manual ritual around that script, not necessarily delete it immediately.

## Future Tommy checklist

If you are reading this months or years later and have forgotten everything:

1. digiKam is the archive brain.
2. Green images are portfolio candidates.
3. ZonePub is only the publishing workshop.
4. The website is static Hugo on GitHub Pages.
5. Metadata should be fixed in digiKam first.
6. Export or send selected images to ZonePub.
7. Review the batch in ZonePub.
8. Let ZonePub create a branch and PR.
9. Review the PR.
10. Merge.
11. Wait for GitHub Pages to deploy.

Do not panic.

The system is meant to be small.

If it feels mysterious, improve this README before changing the code.
