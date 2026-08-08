#let linked-text(value, link-prefix: "", text: "") = {
  if value != "" {
    let display = if text != "" {
      text
    } else {
      value
    }

    if link-prefix != "" {
      link(link-prefix + value)[#display]
    } else {
      display
    }
  }
}

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  email-text: "",
  github: "",
  github-text: "",
  linkedin: "",
  linkedin-text: "",
  phone: "",
  personal-site: "",
  personal-site-text: "",
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  // How far section body content is indented relative to the section title
  section-content-inset: 4pt,
  lang: "en",
  body,
) = {

  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: lang,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: (0.5in),
    paper: paper,
  )

  // Link styles: underline with a small gap under the glyphs (Jake-style).
  // `offset` is layout, not font-dependent; applies to every link site-wide.
  show link: it => {
    if type(it.dest) == str and it.dest.starts-with("tel:") {
      it
    } else {
      underline(offset: 4pt, stroke: 0.8pt + luma(35%), it)
    }
  }

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 600,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info
  pad(
    top: 0em,
    bottom: 0.25em,
    align(personal-info-position)[
      #{
        let items = (
          linked-text(pronouns),
          linked-text(phone, link-prefix: "tel:"),
          linked-text(location),
          linked-text(email, link-prefix: "mailto:", text: email-text),
          linked-text(linkedin, link-prefix: "https://", text: linkedin-text),
          linked-text(github, link-prefix: "https://", text: github-text),
          linked-text(personal-site, link-prefix: "https://", text: personal-site-text),
        )
        items.filter(x => x != none).join(" | ")
      }
    ],
  )

  // Main body: content indented under section titles; titles + rules stay full width
  set par(justify: true)

  pad(left: section-content-inset, {
    show heading.where(level: 2): it => {
      pad(left: -section-content-inset)[
        #set text(weight: 400)
        #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
        #line(length: 100% + section-content-inset, stroke: 0.8pt + luma(35%))
      ]
    }
    body
  })
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature because ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  if start-date == "" {
    end-date
  } else {
    start-date + " " + sym.dash.em + " " + end-date
  }
}

// Summary section component: renders a justified paragraph of 2-3 lines
#let summary(body) = {
  set par(justify: true)
  body
}

// Section components below
#let edu(
  institution: "",
  dates: "",
  degree: "",
  gpa: "",
  location: "",
  // Makes dates on upper right like rest of components
  consistent: false,
) = {
  if consistent {
    // edu-constant style (dates top-right, location bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree),
      bottom-right: emph(location),
    )
  } else {
    // original edu style (location top-right, dates bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: location,
      bottom-left: emph(degree),
      bottom-right: emph(dates),
    )
  }
}

#let work(
  title: "",
  dates: "",
  company: "",
  location: "",
) = {
  generic-two-by-two(
    top-left: strong(title),
    top-right: dates,
    bottom-left: company,
    bottom-right: emph(location),
  )
}

// Project links: links: ((url: "github.com/...", text: "Github"), ...)
#let project(
  name: "",
  technologies: "",
  links: (),
) = {
  let link-items = links
    .filter(item => item.at("url", default: "") != "")
    .map(item => linked-text(
      item.at("url"),
      link-prefix: "https://",
      text: item.at("text", default: ""),
    ))

  generic-one-by-two(
    left: {
      [*#name*#if technologies != "" [ #sym.dash.em #technologies]]
    },
    right: link-items.join([ ∙ ]),
  )
}

#let certificates(
  name: "",
  issuer: "",
  url: "",
  url-text: "",
  date: "",
) = {
  block(width: 100%, spacing: 0.65em)[
    *#name*, #issuer
    #if url != "" {
      [ (#linked-text(url, link-prefix: "https://", text: url-text))]
    }
    #h(1fr) #date
  ]
}

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: strong(activity),
    right: dates,
  )
}
