# ZonePub Decision Log

This file records important decisions.

Add new entries when a design choice is made that future maintainers may question.

Use short entries.

The goal is not ceremony.

The goal is to prevent future archaeology.

## 2026-06-16: Metadata source of truth is digiKam

### Decision

The source of truth for image metadata is digiKam/XMP/IPTC.

Generated Hugo Markdown is a publication artifact.

### Alternatives considered

- Treat Hugo front matter as the source of truth.
- Store authoritative metadata in ZonePub.
- Edit exported JPEG metadata after export.

### Reason

The archive already lives in digiKam.

Metadata should be maintained where the source images are curated.

Exported JPEGs are publication artifacts and should not become the canonical metadata source.

## 2026-06-16: Keep Zone Photos static on GitHub Pages

### Decision

Do not move the public website to a dynamic host just to run publishing logic.

Keep Hugo and GitHub Pages as the public website path.

### Alternatives considered

- Move Hugo to a VPS or dynamic host.
- Run a Python service next to the public website.

### Reason

The problem is authoring and publishing, not public runtime behavior.

GitHub Pages is simple, free, and reliable.

ZonePub can run locally before content reaches GitHub.

## 2026-06-16: ZonePub lives in the website repository

### Decision

ZonePub documentation and future implementation should live in the Zone Photos repository under `zonepub/`.

### Alternatives considered

- Separate repository.
- Scripts under `tools/` only.
- Private local-only folder outside Git.

### Reason

The publishing workflow must be versioned with the website it publishes to.

Future maintainers should be able to clone the repo and understand how publishing works.

## 2026-06-16: Review before publishing

### Decision

ZonePub should show a local review page before writing final Git commits and opening a pull request.

### Alternatives considered

- Fully automatic import and publish.
- Direct commits from export folder.

### Reason

Photography publishing is curatorial.

The user should see title, description, tags, alt text, duplicate status, and target paths before publishing.

## 2026-06-16: AI is optional, not required

### Decision

ZonePub must work without AI.

AI may later suggest titles, tags, descriptions, or alt text.

### Alternatives considered

- Make AI-generated descriptions part of the core workflow.

### Reason

The user prefers understandable, single-responsibility systems.

AI-dependent black boxes should be avoided.

## 2026-06-16: Start with export-folder workflow

### Decision

V1 should start with exported images in a folder.

### Alternatives considered

- Direct digiKam database integration.
- digiKam MCP integration.
- digiKam external tool as the primary path.

### Reason

An export folder is simple, testable, and decoupled from digiKam internals.

Direct integration can be explored later if the export-folder workflow is too clumsy.
