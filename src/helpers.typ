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

// Generic two by two component for resume
// `above` / `below` control the gap before and after the block (`auto` = par.spacing)
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
  above: auto,
  below: auto,
) = {
  block(width: 100%, above: above, below: 0.8em)[
    #text(size: 1em + 0.25pt)[#top-left #h(1fr) #top-right] \
    #text(size: 1em - 0.25pt)[#bottom-left #h(1fr) #bottom-right]
  ]
}

// Generic one by two component for resume
// `above` / `below` control the gap before and after the block (`auto` = par.spacing)
#let generic-one-by-two(
  left: "",
  right: "",
  above: auto,
  below: auto,
) = {
  block(width: 100%, above: above, below: 0.8em)[
    #left #h(1fr) #right
  ]
}

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