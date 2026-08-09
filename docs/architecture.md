# Project Architecture

This repository is the reusable Typst package. It intentionally does not
contain a real person's resume. The only document content included in the
repository is the fictional John Doe starter under `template/`.

## Directory Layout

```text
src/
  lib.typ             Package entrypoint; re-exports the public API.
  resume.typ          The `resume` show-rule function and global layout.
  components.typ      Section components: edu, work, project, certificates, ...
  helpers.typ         Low-level helpers: linked-text, generic layouts, dates.
template/
  main.typ            John Doe starter copied by `typst init`.
docs/
  manual.typ          Package documentation source.
tests/
  snapshot/test.typ   Local component regression document.
typst.toml            Package metadata and template configuration.
```

Personal documents belong beside the repository or in a separate private
project. A sibling document can import the implementation during development:

```typst
#import "exp-resume-template/src/lib.typ": *
```

After publication, a document should import the package namespace instead:

```typst
#import "@preview/exp-resume:0.0.3": *
```

## Typst Flow

The document starts with `#show: resume.with(...)`. Typst passes the rest of
the document as the `body` argument to `resume`, which establishes global text,
page, link, heading, and paragraph rules before rendering that body.

The `resume` function renders the name and contact row. Components such as
`edu`, `work`, `project`, and `extracurriculars` return formatted content that
can be placed below level-two headings (`== Section`). The two generic helpers
use `h(1fr)` as a flexible spacer, which pushes dates or links to the right
edge without introducing visible table borders.

## Development Flow

1. Change the global layout in `src/resume.typ`, section components in
   `src/components.typ`, or shared helpers in `src/helpers.typ`.
2. Expose intentional customization knobs through `resume` or a component.
3. Update `template/main.typ` with fictional examples of the public API.
4. Run `just test` and `just doc`.
5. Run `just package out` to inspect the release contents.

## Package Release

`typst.toml` identifies `src/lib.typ` as the package entrypoint and
`template/main.typ` as the template entrypoint. A package stored at
`packages/preview/{name}/{version}` is imported as
`@preview/{name}:{version}`.

The release workflow packages the repository and pushes it to
`tahzeer/typst-packages`. It requires a `REGISTRY_TOKEN` GitHub secret with
write access to that repository. The package manifest and `.typstignore` both
exclude local build output and other non-package files.

## Versioning

The manifest uses [Semantic Versioning 2.0.0](https://semver.org/), as required
by the Typst package manifest rules. The release sequence is:

- `0.0.1`: initial development release.
- `0.0.2` / `0.0.3`: backward-compatible bug fixes.
- `0.1.0`: backward-compatible public feature; patch resets to `0`.
- `0.2.0`: incompatible change during the unstable `0.x` phase.
- `1.0.0`: first stable public API.
- `2.0.0`: incompatible change after stability; minor and patch reset to `0`.

Released versions are immutable. Every release must update the manifest,
changelog, documentation imports, and matching Git tag (`v0.0.3`, for example).

## Official References

- [Making a Template](https://typst.app/docs/tutorial/making-a-template/)
- [Typst Packages README](https://github.com/typst/packages#readme)
- [Package Manifest](https://github.com/typst/packages/blob/main/docs/manifest.md)
- [Package Submission Guidelines](https://github.com/typst/packages/blob/main/docs/README.md)
- [Typst Module Reference](https://typst.app/docs/reference/foundations/module/)
