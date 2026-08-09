# Exp Resume Changelog

## [v0.0.3](https://github.com/tahzeer/exp-resume-template/releases/tag/v0.0.3)

- Tighten entry-header layout: wrap `generic-two-by-two` / `generic-one-by-two` in blocks with `below: 0.8em`, and nudge top/bottom row font sizes by `±0.25pt`
- Default `section-content-inset` from `4pt` to `2pt`; add a small gap under section rules (`bottom: -2pt`)
- Fix README sample image link and manual reference formatting

## [v0.0.2](https://github.com/tahzeer/exp-resume-template/releases/tag/v0.0.2)

- Split `src/` into `helpers.typ`, `components.typ`, `resume.typ` with `lib.typ` re-exporting
- Rename `tests/debug/` to `tests/snapshot/`
- Rename `scripts/*.sh` with explicit `.sh` extension
- Remove vestigial `gpa` parameter from `edu` (was accepted but never rendered)
- Fix typo in margin comment (`Reccomended` → `Recommended`)
- Remove redundant `set par(justify: true)` from `summary`
- Add `scripts/bump.sh` for version bumping across `*.typ` files and changelog
- Add `docs/manual.typ` with full API documentation
- Add `docs/architecture.md` with project structure, versioning policy, and references
- Add `.gitattributes` for binary file handling
- Consolidate to a single root `.gitignore`
- Pin CI to Typst 0.15 (pixel references are version-specific)

## [v0.0.1](https://github.com/tahzeer/exp-resume-template/releases/tag/v0.0.1)

Initial development release of the Exp Resume package and template.
