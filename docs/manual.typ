#set document(title: "exp-resume Manual")
#set page(paper: "us-letter", margin: 1in)
#set text(font: "New Computer Modern", size: 10pt)
#set heading(numbering: "1.")

#let pkg = "exp-resume"
#let version = "0.0.2"

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
  author: "John Doe",
  email: "john.doe@example.com",
  accent-color: "#26428b",
)

== Experience

#work(
  title: "Software Engineer",
  company: "Example Corporation",
  location: "Example City, EX",
  dates: dates-helper(start-date: "Jun 2024", end-date: "Present"),
)
- Replace this placeholder with an accomplishment.
```

Lines that start with `==` are formatted into small-caps section headings with
a rule underneath.

= Resume Configuration

The `resume` function accepts the following parameters:

#table(
  columns: (auto, 1fr),
  [*Parameter*], [*Description*],
  [author], [Your name, shown as a level-one heading],
  [location], [City and country or region, shown in the contact row],
  [email], [Email address, linked with `mailto:`],
  [email-text], [Optional display text for the email link],
  [github], [GitHub handle, linked with `https://`],
  [github-text], [Optional display text for the GitHub link],
  [linkedin], [LinkedIn handle, linked with `https://`],
  [linkedin-text], [Optional display text for the LinkedIn link],
  [phone], [Phone number, linked with `tel:`],
  [personal-site], [Personal site, linked with `https://`],
  [personal-site-text], [Optional display text for the personal site link],
  [accent-color], [Color for headings and links, defaults to black],
  [font], [Body font, defaults to "New Computer Modern"],
  [paper], [Page paper, defaults to "us-letter"],
  [font-size], [Body font size, defaults to 10pt],
  [author-font-size], [Name size, defaults to 20pt],
  [lang], [Document language, defaults to "en"],
  [pronouns], [Optional pronouns, shown in the contact row],
  [author-position], [Alignment of the name, defaults to left],
  [personal-info-position], [Alignment of the contact row, defaults to left],
)

Parameters that are optional can be omitted or set to `""`. The template
contains commented example values.

= Section Components

Each component is placed directly below a `== Section` heading. Bold and
italic emphasis inside the argument strings is preserved.

== Summary

#raw("summary", lang: "typst") renders a justified paragraph below a heading:

```typst
== Summary

#summary[Backend engineer experienced in scaling distributed services.]
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

Set `consistent: true` to move the dates to the top-right and the location to
the bottom-right, matching the other components.

== Work Experience

```typst
#work(
  title: "Software Engineer",
  company: "Example Corporation",
  location: "Example City, EX",
  dates: dates-helper(start-date: "Jun 2024", end-date: "Present"),
)
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

```typst
#certificates(
  name: "Example Certification",
  issuer: "Example Institute",
  url: "example.com/cert",
  url-text: "Certificate",
  date: "Jun 2024",
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

These helpers do not apply any formatting beyond layout and can be used to
build custom entries.

== dates-helper

Formats a start and end date with an em dash. Pass only an end date to omit
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

Places `left` and `right` on one line, with `right` pushed to the right edge:

```typst
#generic-one-by-two(left: "Title", right: "Date")
```

== generic-two-by-two

Places two pairs on two lines, with each right-hand cell pushed to the right
edge:

```typst
#generic-two-by-two(
  top-left: "Title",
  top-right: "Date",
  bottom-left: "Company",
  bottom-right: "Location",
)
```

== edu-entry

Renders a single education row of `year`, `institution`, and `grade`, with the
cells spread across the line:

```typst
#edu-entry(year: "2020", institution: "Example University", grade: "B.Tech")
```
