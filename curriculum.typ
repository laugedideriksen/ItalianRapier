#import "balance-and-voiding/balance-and-voiding.typ": balance-and-voiding
#import "empty-hand-basics/empty-hand-basics.typ": empty-hand-basics
#import "developing-sensitivity-in-the-bind/developing-sensitivity-in-the-bind.typ": (
  developing-sensitivity-in-the-bind,
)
#import "addressing-weaknesses/addressing-weaknesses.typ": addressing-weaknesses
// #import "next-block/next-block.typ": next-block

#import "@preview/in-dexter:0.7.2": *

#let blocks = (
  balance-and-voiding,
  empty-hand-basics,
  addressing-weaknesses,
  // next-block,
)

// ---- Compiled document metadata ----
#let doc-title = "Italian Rapier"
#let doc-subtitle = "Drills, Lessons, and Principles"
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
#set page(numbering: none)
#align(center + horizon)[
  #text(size: 32pt, weight: "regular")[#doc-title]
  #if doc-subtitle != none [
    #v(0.5em)
    #text(size: 18pt, style: "italic")[#doc-subtitle]
  ]
  #v(2.5em)
  #text(size: 14pt)[#author-name]
  #v(0.3em)
  #text(size: 12pt)[Last Updated: #todays-date]
]
#pagebreak()

#show heading.where(level: 1): set text(size: 24pt, weight: "regular")

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
#set page(numbering: "i")
#counter(page).update(1)
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
#include "preface.typ"

// ---- Body ----
// Chapter numbering (level 3 in each block) runs continuously across the
// whole compiled document rather than restarting per block, since Typst's
// heading counter is shared document-wide by default.
#set page(numbering: "1")
#counter(page).update(1)
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
#columns(2)[#make-index(title: [Index], outlined: true)]
