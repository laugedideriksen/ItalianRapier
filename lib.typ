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

#let link-and-ref-style(body) = {
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading {
      // Which block does a given location belong to?
      let block-at(loc) = {
        let found = query(selector(<block-title>).before(loc))
        if found.len() > 0 { found.last().value } else { none }
      }
      let target-block = block-at(el.location())
      let cross = (
        target-block != none and target-block != block-at(it.location())
      )
      let plain = it.supplement == auto
      if el.level == 1 and plain {
        link(el.location(), emph(if target-block != none { target-block } else {
          el.body
        }))
      } else if el.numbering != none and el.level in (3, 4) {
        let nums = counter(heading).at(el.location())
        let n = if el.level == 3 { numbering("1", nums.last()) } else {
          numbering("1.1", ..nums.slice(-2))
        }
        let sup = if plain { el.supplement } else { it.supplement }
        link(el.location())[#sup #n#if cross [ of #emph(target-block)]]
      } else if el.numbering == none {
        let text = if plain { ['#el.body'] } else { it.supplement }
        link(el.location())[#text#if cross [ in #emph(target-block)]]
      } else { it }
    } else { it }
  }
  // Only external URLs are blue; internal links keep the text colour.
  show link: it => if type(it.dest) == str {
    underline(text(fill: rgb("#0000ff"), it))
  } else { text(fill: green, it) }

  body
}

#let block-layout(
  body,
  doc-title: "",
  doc-version: "",
  last-updated: none,
  author-name: "Lauge Dideriksen",
  doc-language: "en-GB",
  spacing-mode: "onehalf",
  standalone: true,
  tag: none,
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

  show: link-and-ref-style

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
    block(above: 1.5em, below: 0.8em)[
      #if it.numbering != none [
        #counter(heading).display((..nums) => numbering("1.1.", ..nums
          .pos()
          .slice(-2)))#h(-0pt)
      ]
      #it.body
    ]
  }

  show heading.where(level: 5): it => {
    set text(size: 13pt, weight: "bold")
    block(above: 1.5em, below: 0.8em)[
      //      #underline(it.body)
      #it.body
    ]
  }

  [#metadata(doc-title) <block-title>]

  // ---- Title block ----
  // Reused whether standalone or included in the master.
  align(left)[
    #heading(
      level: 1,
    )[#doc-title (v#doc-version)#if standalone { footnote[This document is part of a collection of texts on Italian rapier fencing, and may reference parts that are not included here. The current version of the full collection can be found on #link("https://github.com/laugedideriksen/ItalianRapier").] }]#if (
      tag != none
    ) { label(tag) }
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
