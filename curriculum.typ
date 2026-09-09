// ============================================================
// Master compiled document.
//
// Assumed layout (this file sits at the project root, a sibling of every
// block's subdirectory and of the shared bib file -- matching what the
// block templates already assume via their own "../zotero-library.bib"):
//
//   curriculum.typ                       <- this file
//   zotero-library.bib
//   empty-hand-basics/
//     empty-hand-basics.typ
//     empty-hand-basics_content.typ
//     *.png
//   <next-block>/
//     <next-block>.typ
//     <next-block>_content.typ
//     ...
//
// To add a block once you've applied the same "wrap in a function with a
// `standalone` parameter" treatment to its template file (see
// empty-hand-basics.typ for the pattern): add an #import line below, and
// add the function to the `blocks` array.
//
// Relative paths in Typst (image(), include(), bibliography(), ...)
// resolve relative to the file they're WRITTEN in, not relative to
// whichever file is being compiled -- so nothing in the block templates
// or content files needs to change for this to work. The one thing that
// does need to stay true: everything (this file, every block directory,
// the bib file) must live under the same Typst project root (in your
// case, wherever tinymist's `.git` root-marker resolves to), or you'll
// hit a "path would escape the project root" error.
// ============================================================

#import "empty-hand-basics/empty-hand-basics.typ": empty-hand-basics
#import "addressing-weaknesses/addressing-weaknesses.typ": addressing-weaknesses
// #import "next-block/next-block.typ": next-block

#import "@preview/in-dexter:0.7.2": *

#let blocks = (
  empty-hand-basics,
  addressing-weaknesses,
  // next-block,
)

// ---- Compiled document metadata ----
// TODO: fill in a real title (and subtitle, if you want one).
#let doc-title = "[Compiled Curriculum Title]"
#let doc-subtitle = none // e.g. [A Complete Curriculum for Italian Rapier]
#let author-name = "Lauge Dideriksen"
#let todays-date = (
  datetime.today().display("[day padding:none] [month repr:long] [year]")
)

#set document(title: doc-title, author: author-name)
#set page(paper: "a4", margin: 1in, numbering: "1")

// ---- Document language ----
// Choose between: "en-GB" (UK English) or "de-AT" (Austrian German)
#let doc-language = "en-GB"
#let lang-settings = (
  "en-GB": (lang: "en", region: "GB"),
  "de-AT": (lang: "de", region: "AT"),
).at(doc-language)
#set text(..lang-settings, size: 12pt, font: "Adobe Garamond Pro")

// ---- Front page ----
// A minimal starting point -- title, optional subtitle, author, date.
#align(center + horizon)[
  #text(size: 32pt, weight: "regular")[#doc-title]
  #if doc-subtitle != none [
    #v(0.5em)
    #text(size: 18pt, style: "italic")[#doc-subtitle]
  ]
  #v(2.5em)
  #text(size: 14pt)[#author-name]
  #v(0.3em)
  #text(size: 12pt)[#todays-date]
]
#pagebreak()

// ---- Table of Contents numbering fix ----
// Each block's own heading show rules (level 3/4) number themselves
// correctly *inline*, by deliberately dropping the leading zero(s) that
// come from levels 1-2 having no numbering of their own (their
// `nums.pos().last()` / `.slice(-2)` trick). Typst's #outline() doesn't
// know about that trick and would otherwise print "0.0.1. Principles"
// instead of "1. Principles" -- this reapplies the same fix to the ToC.
// Level 4 covers both numbered headings ("Drills") and ones explicitly
// marked `numbering: none` ("How To Use this Document", "Terminology",
// etc. -- carried over from the original \section*{} in the LaTeX
// source); only reach for the counter when there's a number to compute,
// since an unnumbered heading's counter value isn't level-shaped the
// same way and would error on the slice below.
#show outline.entry.where(level: 3): it => {
  let prefix = if it.element.numbering != none {
    numbering("1.", counter(heading).at(it.element.location()).last())
  } else {
    it.prefix()
  }
  link(it.element.location(), it.indented(prefix, it.inner()))
}
#show outline.entry.where(level: 4): it => {
  let prefix = if it.element.numbering != none {
    numbering("1.1.", ..counter(heading).at(it.element.location()).slice(-2))
  } else {
    it.prefix()
  }
  link(it.element.location(), it.indented(prefix, it.inner()))
}

// ---- Front matter ----
// depth: 4 keeps the run-in "Dui Tempi" / "Stesso Tempo" / "Free Play"
// headings (level 5) out of the contents listing; raise it if you want
// them included after all.
#outline(title: [Table of Contents], depth: 4)
#pagebreak()
#outline(title: [Table of Figures], target: figure)
#pagebreak()

// ---- Body ----
// Chapter numbering (level 3 in each block) runs continuously across the
// whole compiled document rather than restarting per block, since Typst's
// heading counter is shared document-wide by default.
#for (i, b) in blocks.enumerate() [
  #b(standalone: false)
  #if i < blocks.len() - 1 [#pagebreak()]
]

// ---- Bibliography ----
// Single, consolidated bibliography covering every block. Always
// single-spaced/smaller, independent of each block's own spacing-mode.
#pagebreak()
#show bibliography: set par(leading: 0.65em)
#bibliography(
  "zotero-library.bib",
  style: "chicago-author-date",
  title: "References",
)

// ---- Index ----
// Entries are marked by hand in the *content* files with #index[term] /
// #index-main[term] (in-dexter's package). Each content file that wants
// to mark terms needs its own `#import "@preview/in-dexter:0.7.2": *` at
// the top -- imports don't propagate from this file into files pulled in
// via #include, only into files that #import this one. None of your
// content files have any #index[] marks yet, so this page will render
// empty until you start adding them.
#pagebreak()
#make-index(title: [Index], outlined: true)
