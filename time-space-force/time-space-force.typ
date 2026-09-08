#set document(
  title: "Time---Space---Force",
  author: "Lauge Dideriksen",
)

#set page(
  paper: "a4",
  margin: 1in,
  numbering: "1",
)

#set text(
  font: "New Computer Modern",
  lang: "en",
  region: "GB",
  size: 11pt,
  hyphenate: true,
)

#set par(
  leading: 1em,
  justify: true,
)

#set list(spacing: 0.9em)

// Links: black by default, blue for bare URLs
#show link: it => text(fill: rgb("#0000ff"), it)

// Chapter-style level-1 headings
#show heading.where(level: 1): it => {
  set text(size: 24pt, weight: "regular")
  block(above: 1.5em, below: 1em)[
    #if it.numbering != none [
      #counter(heading).display("1.")#h(-10pt)
    ]
    #it.body
  ]
}
#show heading.where(level: 2): set text(size: 18pt, weight: "regular")
#show heading.where(level: 3): set text(size: 15pt, weight: "bold")
#show heading.where(level: 4): set text(
  size: 12pt,
  weight: "bold",
  style: "italic",
)
#show heading: set block(above: 1.2em, below: 0.8em)

#show raw.where(block: true): it => {
  set text(font: "Hack", size: 9pt)
  block(stroke: 0.5pt + black, inset: 8pt, width: 100%, it)
}

// #bibliography("zotero-library.bib", style: "chicago-author-date")

// ==================== Title block ====================

#align(left)[
  = Time---Space---Force
  #v(-1.0em)
  == Lauge Dideriksen
]
#v(1em)

// ==================== Body ====================


