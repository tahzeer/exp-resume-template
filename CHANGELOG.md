# Exp Resume Changelog

## [v0.1.0](https://github.com/tahzeer/exp-resume-template/releases/tag/v0.1.0)

### Added
- `#skills(category: "", items: "")` section component (same row rhythm as `#certificates`)
- `default-spacing` export and `resume.with(spacing: (...))` overrides
- `src/spacing.typ` with named tokens (`leading`, `gap`, `row`, section chrome, link/rule styles)

### Changed
- Entry headers use `gap` above and `row` below; lists use `block(above: row)` so title/company → first bullet matches `row`
- Certificates and skills share an `info-row` helper spaced with `row`
- Soft-default paragraph rhythm is owned by `#resume` (`leading` / `gap`); documents should not need `#set par(...)` for normal use
- Generic helpers accept an optional `spacing` length override (`auto` inherits the defaults above)

### Docs
- Manual documents spacing keys, `#skills`, and removes the non-existent `edu-entry` helper
- README and architecture updated for `0.1.0` and `spacing.typ`

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
