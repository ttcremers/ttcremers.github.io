# ZonePub Future Ideas

This file is for good ideas that should not derail the MVP.

If an idea is interesting but not needed for the next useful version, put it here.

## AI-assisted metadata suggestions

ZonePub could later offer optional AI suggestions for:

- imageAlt
- concise descriptions
- missing tags
- weak generic titles
- SEO-focused wording

These suggestions should always be reviewed by the user.

AI must not become required for the basic workflow.

## digiKam external tool integration

A nicer workflow may be possible if digiKam can call an external tool or script for selected images.

Possible future action:

```text
Send to ZonePub
```

This could send selected files directly to the local ZonePub service.

## digiKam database integration

ZonePub could read the digiKam database directly to find green images, tags, ratings, and metadata.

This is powerful but risky.

It couples ZonePub to digiKam internals and should not be part of V1.

## digiKam MCP

If an MCP server for digiKam exists or is built later, ZonePub or an assistant could use it to inspect selected images and metadata.

This may be useful, but the publishing workflow should not depend on it.

## Multi-site support

The same pattern may later help with other Hugo sites, including artistiekportret.nl.

Possible future direction:

```text
source archive
  ↓
local publishing assistant
  ↓
Git PR
  ↓
static website
```

Do not abstract too early.

Zone Photos comes first.

## Metadata write-back assistance

ZonePub could later detect weak metadata and produce a report of suggested changes to make in digiKam.

It should not silently write authoritative metadata unless that workflow is explicitly designed and reviewed.

## Image filename strategy

Existing image filenames are often generic.

Renaming them may help image search, but it can break indexed image URLs.

Future filename changes need a redirect strategy, likely outside GitHub Pages.

Cloudflare Redirect Rules or Bulk Redirects could be explored.

## Batch quality reports

ZonePub could generate a quality report for a batch:

- missing title
- missing description
- missing location
- weak tags
- possible gear-only tags
- no project tag
- duplicate suspicion

## Collection landing page suggestions

ZonePub could later warn when a project/tag has many images but no useful landing page text.

Example:

- `life-in-contrast`
- `life-in-tone`
- `my-poland`
- `phart`

## Local preview build

ZonePub could run Hugo locally after generating a batch.

This would allow previewing the website before opening a pull request.

## Recovery tools

Useful later:

- clear queue
- retry failed batch
- remove one item from batch
- show last published batch
- compare batch against current master

## Import from existing website

ZonePub could scan existing Hugo content and build an internal index of already-published images.

This may help with duplicate detection and metadata update workflows.
