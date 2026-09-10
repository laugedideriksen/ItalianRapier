#let developing-sensitivity-in-the-bind(standalone: true) = {
  let doc-title = "Developing Sensitivity in the Bind"
  let doc-version = "0.1.0"
  let author-name = "Lauge Dideriksen"
  let last-updated = "10 September 2026"

  set document(title: doc-title, author: author-name)
  set page(paper: "a4", margin: 1in, numbering: "1")

  // ---- Document language ----
  // Choose between: "en-GB" (UK English) or "de-AT" (Austrian German)
  let doc-language = "en-GB"
  let lang-settings = (
    "en-GB": (lang: "en", region: "GB"),
    "de-AT": (lang: "de", region: "AT"),
  ).at(doc-language)
  set text(..lang-settings, size: 12pt, font: "Adobe Garamond Pro")

  // ---- Line spacing ----
  // Choose between: "single", "onehalf", "double"
  let spacing-mode = "onehalf"


  let base-leading = 0.65em // Typst's default = single spacing
  let spacing-factor = (
    single: 1.0,
    onehalf: 1.5,
    double: 2.0,
  ).at(spacing-mode)

  set par(
    justify: true,
    leading: base-leading * spacing-factor,
    first-line-indent: 0.5in,
    spacing: base-leading * spacing-factor,
  )

  //#set list(spacing: 0.25em)
  //#set enum(spacing: 0.25em)

  show figure.caption: set text(size: 10pt)

  show heading.where(level: 1): set text(size: 24pt, weight: "regular")

  show heading.where(level: 2): set text(size: 18pt, weight: "regular")

  show heading.where(level: 3): set heading(numbering: "1.")
  show heading.where(level: 3): it => {
    set text(size: 17pt, weight: "regular")
    block(above: 1.2em, below: 0.8em)[
      #if it.numbering != none [
        #counter(heading).display((..nums) => numbering(
          "1.",
          nums.pos().last(),
        ))#h(-0pt)
      ]
      #it.body
    ]
  }

  show heading.where(level: 4): set heading(numbering: "1.1.")
  show heading.where(level: 4): it => {
    set text(
      size: 15pt,
      weight: "regular",
    )
    block(above: 1.2em, below: 0.8em)[
      #if it.numbering != none [
        #counter(heading).display((..nums) => numbering("1.1.", ..nums
          .pos()
          .slice(-2)))#h(-0pt)
      ]
      #it.body
    ]
  }

  show heading.where(level: 5): it => {
    set text(size: 13pt, weight: "regular")
    block(above: 1.2em, below: 0.8em)[
      #underline(it.body)
    ]
  }

  // ---- Title block ----
  align(left)[
    = #doc-title (v#doc-version)
    #v(-0.8em)
    #heading(level: 2, outlined: false)[#author-name, #last-updated]
  ]
  v(1em)

  // ---- Body ----

  include "developing-sensitivity-in-the-bind_content.typ"

  // ---- Bibliography ----
  // Always single-spaced/smaller, independent of spacing-mode above
  //#show bibliography: set text(size: 8pt)
  if standalone {
    show bibliography: set par(leading: base-leading)
    bibliography(
      "../zotero-library.bib",
      style: "chicago-author-date",
      title: "References",
    )
  }
}

#developing-sensitivity-in-the-bind()
