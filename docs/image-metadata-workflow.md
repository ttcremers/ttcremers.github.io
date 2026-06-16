# Image metadata workflow

Zone Photos image pages are generated from image files and their embedded metadata.

## Current approach

The `tools/jpgtomd.sh` script reads JPEG files and creates Hugo Markdown files for image pages.

The script now prefers embedded metadata where available:

- `Title`
- `ObjectName`
- `Headline`
- `Description`
- `Subject`
- `Keywords`
- `City`
- `Country`

It writes the following Hugo front matter:

- `title`
- `description`
- `imageAlt`
- `tags`
- `images`

## Recommended image metadata before import

Before generating Markdown, enrich exported JPEG files with metadata using a photo manager or `exiftool`.

Useful fields:

- Title: human-readable artwork title
- Description: one-sentence image description or caption
- Subject / Keywords: searchable concepts and tags
- City: location where relevant
- Country: location where relevant

Good keywords are specific, consistent, and useful for discovery.

Examples:

- `black-and-white`
- `street-photography`
- `fine-art-photography`
- `fine-art-portraiture`
- `conceptual-photography`
- `the-hague`
- `poland`
- `westland`
- `portrait`
- `monochrome`

Avoid weak or inconsistent tags such as:

- `final`
- `photoshoot`
- misspellings such as `composit` instead of `composite`

## Image filenames

Do not rename existing indexed image files without a redirect plan.

GitHub Pages does not support server-side 301 redirects for image files. Hugo aliases work for HTML pages, but not for old image URLs.

If image filenames are renamed later, use a redirect layer such as Cloudflare Redirect Rules or Bulk Redirects so old indexed image URLs keep working.

## Practical workflow

1. Curate/export selected JPEG files.
2. Add embedded metadata to the files.
3. Run `tools/jpgtomd.sh <images-directory> <target-markdown-directory>`.
4. Review generated titles, descriptions, alt text, and tags.
5. Commit Markdown and image files together.
6. Request indexing for important new image/collection pages in Google Search Console.
