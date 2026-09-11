#import "@preview/in-dexter:0.7.2": *

#let index-start = index.with(index-type: indextype.Start)
#let index-end = index.with(index-type: indextype.End)

#let sourced-figure(img, caption: [], source: none, tag: none) = block(
  breakable: false,
)[
  #figure(img, caption: caption)#if tag != none { label(tag) }
  #if source != none [
    #align(center)[
      #text(size: 8pt, style: "italic")[Source: #link(source)[#source]]
    ]
  ]
]

#let block-layout(
  body,
  doc-title: "",
  doc-version: "",
  last-updated: none,
  author-name: "Lauge Dideriksen",
  doc-language: "en-GB",
  spacing-mode: "onehalf",
  standalone: true,
) = {
  let todays-date = if last-updated != none {
    last-updated.display("[day padding:none] [month repr:long] [year]")
  } else { "" }

  // Document-level settings only make sense once per compiled PDF, so
  // these are no-ops when this block is included from the master.
  set document(title: doc-title, author: author-name) if standalone
  set page(paper: "a4", margin: 1in, numbering: "1") if standalone

  // ---- Document language ----
  // Choose between: "en-GB" (UK English) or "de-AT" (Austrian German)
  let lang-settings = (
    "en-GB": (lang: "en", region: "GB"),
    "de-AT": (lang: "de", region: "AT"),
  ).at(doc-language)
  set text(..lang-settings, size: 12pt, font: "Adobe Garamond Pro")

  // ---- Line spacing ----
  // Choose between: "single", "onehalf", "double"
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

  show figure.caption: set text(size: 10pt)
  show link: it => text(fill: rgb("#0000ff"), it)

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
  // Reused whether standalone or included in the master.
  align(left)[
    = #doc-title (v#doc-version)
    #if standalone {
      v(-0.8em)
      heading(level: 2, outlined: false)[#author-name, #todays-date]
    }
  ]
  v(1em)

  // ---- Body ----
  body

  // ---- Bibliography ----
  // Only printed standalone -- the master prints one consolidated
  // bibliography after all blocks instead.
  if standalone {
    show bibliography: set par(leading: base-leading)
    bibliography(
      "zotero-library.bib",
      style: "chicago-author-date",
      title: "References",
    )
  }
}
