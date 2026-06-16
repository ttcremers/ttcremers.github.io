# ZonePub TODO

This is the working list.

Keep this practical.

Move tempting ideas that are not part of the next build step to `FUTURE_IDEAS.md`.

## Documentation

- [x] Create `zonepub/README.md`.
- [x] Create `zonepub/PRD.md`.
- [x] Create `zonepub/ARCHITECTURE.md`.
- [x] Create `zonepub/DECISIONS.md`.
- [x] Create `zonepub/TODO.md`.
- [x] Create `zonepub/FUTURE_IDEAS.md`.

## Validation before coding

- [ ] Confirm which metadata fields digiKam exports into JPEG files.
- [ ] Confirm whether digiKam can export selected files into a fixed folder easily.
- [ ] Confirm whether digiKam can call an external tool with selected files.
- [ ] Inspect current `content/work/**` structure.
- [ ] Inspect current `static/images/**` structure.
- [ ] Define collection mapping for existing project tags.
- [ ] Define duplicate detection rules for V1.
- [ ] Decide whether V1 requires SQLite or can start with filesystem state.

## MVP build steps

- [ ] Create basic ZonePub project skeleton.
- [ ] Add configuration file example.
- [ ] Add import folder scanner.
- [ ] Add metadata extraction using ExifTool.
- [ ] Add repository scanner for existing image references.
- [ ] Add duplicate detection.
- [ ] Add batch queue.
- [ ] Add simple review page.
- [ ] Add Markdown generator.
- [ ] Add image copy step.
- [ ] Add Git branch creation.
- [ ] Add commit step.
- [ ] Add pull request creation.
- [ ] Add README setup instructions for running locally.

## Manual test scenario

- [ ] Export one known green image from digiKam.
- [ ] Import it into ZonePub.
- [ ] Confirm metadata extraction.
- [ ] Confirm duplicate detection against existing website content.
- [ ] Review generated title, description, imageAlt, and tags.
- [ ] Generate Markdown without publishing.
- [ ] Create a test branch.
- [ ] Open a test pull request.
- [ ] Merge only after review.

## Later cleanup

- [ ] Decide what happens to `tools/jpgtomd.sh` after ZonePub works.
- [ ] Document how to recover from a failed batch.
- [ ] Document how to remove or skip queued items.
- [ ] Document how to handle metadata updates for already-published images.
