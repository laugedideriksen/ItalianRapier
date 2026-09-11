// Wrapped as a function so this block can either compile on its own
// (standalone: true, the default -- pin this file as main with
// :LspTinymistPinMain) or be pulled into the master compiled document
// (standalone: false), which supplies its own #set document / #set page
// and prints a single consolidated bibliography instead of one per block.
//
// Everything else (title block, language/spacing/heading styling, the
// actual content) stays the same either way, per your answer that the
// title block should be reused regardless of context.
#let finding-the-guard(standalone: true) = {
  // ---- Metadata ----
  let doc-title = "Finding the Guard"
  let doc-version = "0.0.1."
  let author-name = "Lauge Dideriksen"
  let last-updated = "10 September 2026"

  // Document-level settings only make sense once per compiled PDF, so
  // these are no-ops when this block is included from the master.
  // (`set X if cond` is Typst's "set-if" rule -- see the Styling page in
  // the Typst docs -- and, unlike wrapping these in an `if { }` block,
  // it does NOT confine the effect to just the if-branch.)
  set document(title: doc-title, author: author-name) if standalone
  set page(paper: "a4", margin: 1in, numbering: "1") if standalone

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

  //set list(spacing: 0.25em)
  //set enum(spacing: 0.25em)

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
  // Reused whether standalone or included in the master (per your answer).
  // The author/date line is marked `outlined: false` so it doesn't clutter
  // the master's table of contents with a second entry under every block
  // title -- only the block title itself (level 1) shows up there.
  align(left)[
    = #doc-title (v#doc-version)
    #v(-0.8em)
    #heading(level: 2, outlined: false)[#author-name, #last-updated]
  ]
  v(1em)

  // ---- Body ----
  include "finding-the-guard_content.typ"

  // ---- Bibliography ----
  // Only printed standalone -- the master prints one consolidated
  // bibliography after all blocks instead.
  if standalone {
    show bibliography: set par(leading: base-leading)
    bibliography(
      "../zotero-library.bib",
      style: "chicago-author-date",
      title: "References",
    )
  }
}

// Entry point for standalone compilation, e.g. via :LspTinymistPinMain.
// This line's own output is simply discarded when the master document
// #imports this file instead of #including it -- import only pulls the
// `empty-hand-basics` name into scope, it doesn't render the file's
// top-level content.
#finding-the-guard()
