#set document(title: "exp-resume Manual")
#set page(paper: "us-letter", margin: 1in)
#set text(font: "New Computer Modern", size: 10pt)
#set heading(numbering: "1.")

#let pkg = "exp-resume"
#let version = "0.3.0"

= Introduction

#pkg is a small Typst package for writing an ATS-friendly resume. It
configures a clean one-page layout, a name and contact row, and a set of
components for the common resume sections. Personal documents should be kept
outside the repository and import either the published package or the local
clone.

= Installation

Publish the package to the Typst package repository, then create a new
document from the template:

```sh
typst init @preview/#pkg:#version
```

During development a sibling document can import the implementation from a
local clone:

```typst
#import "exp-resume-template/src/lib.typ": *
```

= Quick Start

The document starts with `#show: resume.with(...)`, which applies the global
rules and renders the name and contact row. The rest of the document is the
body:

```typst
#import "@preview/#pkg:#version": *

#show: resume.with(
  person: (
    name: "John Doe",
    email: "john.doe@example.com",
  ),
  page: (accent-color: "#26428b"),
)

== Experience

#employer(
  company: "Example Corporation",
  location: "Example City, EX",
)[
  #role(
    title: "Software Engineer",
    dates: dates-helper(start-date: "Jun 2024", end-date: "Present"),
  )
  - Replace this placeholder with an accomplishment.
]

== Skills

#skills(
  category: "Languages",
  items: "Python, Go, TypeScript, SQL, Bash",
)
```

Lines that start with `==` are formatted into small-caps section headings with
a rule underneath.

= Resume Configuration

Defaults live in `config.typ` as four dictionaries: `default-person`,
`default-placement`, `default-page`, and `default-spacing`. Pass a partial
dictionary to override one group:

```typst
#show: resume.with(
  person: (
    name: "John Doe",
    email: "john.doe@example.com",
  ),
  placement: (name: center, contact: center),
  page: (accent-color: "#26428b"),
  spacing: (block-spacing: 0.85em),
)
```

Empty person fields are skipped. The template shows the full set.

== Person

#table(
  columns: (auto, 1fr),
  [*Key*], [*Role*],
  [`name`], [Shown as the title and stored as the document author],
  [`pronouns`], [Contact row],
  [`location`], [Contact row],
  [`phone`], [Contact row, linked with `tel:` and not underlined],
  [`email`], [Contact row, linked with `mailto:`],
  [`email-text`], [Optional display text for the email link],
  [`github`], [Contact row, linked with `https://`],
  [`github-text`], [Optional display text for the GitHub link],
  [`linkedin`], [Contact row, linked with `https://`],
  [`linkedin-text`], [Optional display text for the LinkedIn link],
  [`personal-site`], [Contact row, linked with `https://`],
  [`personal-site-text`], [Optional display text for the personal site link],
)

== Placement

#table(
  columns: (auto, 1fr),
  [*Key*], [*Role*],
  [`name`], [Alignment of the name. Default: left],
  [`contact`], [Alignment of the contact row. Default: left],
)

== Page

#table(
  columns: (auto, 1fr),
  [*Key*], [*Role*],
  [`font`], [Body font. Default: "New Computer Modern"],
  [`font-size`], [Body size. Default: 10pt],
  [`name-size`], [Name size. Default: 20pt],
  [`accent-color`], [Headings and links. Default: `"#000000"`],
  [`paper`], [Page paper. Default: `"us-letter"`],
  [`margin`], [Space between the page edge and the content. Default: 0.5in],
  [`lang`], [Document language. Default: `"en"`],
)

== Spacing

#table(
  columns: (auto, 1fr),
  [*Key*], [*Role*],
  [`line-spacing`], [Space between lines inside a paragraph. Default: 0.5em],
  [`block-spacing`], [Space between paragraphs and above an entry header. Default: 0.85em],
  [`item-spacing`], [Space under an entry title before its bullets, and between certificate and skill rows. Default: 0.75em],
  [`after-header`], [Space under the name and contact. Default: 0.25em],
  [`section-rule`], [Line under a section title. Default: `0.75pt`],
)

= Section Components

Each component is placed directly below a `== Section` heading. Pass Typst
content to style a field: `title: emph[Engineer]` is italic, and a quoted
string is printed as written. School, company, project name, certificate name,
skill category, and activity are already bold, so `emph` on those is bold
italic. Link addresses stay plain strings. `dates-helper` joins strings, so
wrap its result, as in `dates: emph(dates-helper(...))`. Bullets and the
summary take normal Typst markup.

== Summary

A paragraph under the heading. It uses the same justified body text as the
rest of the resume.

```typst
== Summary

Backend engineer experienced in scaling distributed services.
```

== Education

```typst
#edu(
  institution: "Example University",
  location: "Example City, EX",
  dates: dates-helper(start-date: "Aug 2020", end-date: "May 2024"),
  degree: "Bachelor of Science, Computer Science",
)
```

The institution and location sit on the first line. The degree and dates sit
on the second. The institution is bold. The location, degree, and dates are
regular.

== Experience

`employer` is the same two-line header as a single job. The company is bold
on the left and the location is regular on the right. The title and the
dates are regular. A later role repeats that title line, with the same
`block-spacing` above it as any other entry header.

```typst
#employer(
  company: "Example Corporation",
  location: "Remote",
)[
  #role(
    title: "Senior Software Engineer",
    dates: dates-helper(start-date: "Jun 2024", end-date: "Present"),
  )
  - Built reliable services and shipped measurable improvements.

  #role(
    title: "Software Engineer",
    dates: dates-helper(start-date: "Jun 2022", end-date: "May 2024"),
  )
  - Shipped the first version of the service.
]
```

== Projects

```typst
#project(
  name: "Example Project",
  technologies: "Python, FastAPI, Redis",
  links: (
    (url: "github.com/johndoe/example-project", text: "Github"),
    (url: "example.com", text: "Live"),
  ),
)
```

Pass multiple `links` as `(url, text)` dictionaries. They are joined with
` ∙ ` and shown on the right.

== Certificates

One row per call. Consecutive rows share the `item-spacing` length.

```typst
#certificates(
  name: "Example Certification",
  issuer: "Example Institute",
  url: "example.com/cert",
  url-text: "Certificate",
  date: "Jun 2024",
)
```

== Skills

One row per call, same spacing path as certificates:

```typst
#skills(
  category: "Languages",
  items: "Python, Go, TypeScript, SQL, Bash",
)
```

== Extracurricular Activities

```typst
#extracurriculars(
  activity: "Example Open Source Group",
  dates: dates-helper(start-date: "Jan 2022", end-date: "Present"),
)
```

= Generic Helpers

These helpers provide layout without section-specific formatting and can be
used to build custom entries.

== dates-helper

Formats a start and end date with an en dash. Pass only an end date to omit
the dash:

```typst
#dates-helper(start-date: "Jun 2024", end-date: "Present")
```

== linked-text

Renders `value` as a hyperlink when a `link-prefix` is given, optionally using
`text` as the visible label:

```typst
#linked-text("example.com", link-prefix: "https://")
```

== generic-one-by-two

Places `left` and `right` on one line, with `right` pushed to the right edge.
By default uses `block-spacing` above and `item-spacing` below. Pass `spacing: <length>` to set
both sides explicitly.

```typst
#generic-one-by-two(left: "Title", right: "Date")
```

== generic-two-by-two

Places two pairs on two lines, with each right-hand cell pushed to the right
edge. Both rows use the body size. Same default above/below behavior as
`generic-one-by-two`.

```typst
#generic-two-by-two(
  top-left: "Title",
  top-right: "Date",
  bottom-left: "Company",
  bottom-right: "Location",
)
```
