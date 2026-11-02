// glossary.typ -- glossary machinery. Terms themselves live in
// glossary-entries.typ. lib.typ imports and re-exports gl, gl-link and
// print-glossary, so content files keep using: #import "../lib.typ": *

#import "glossary-entries.typ": glossary-entries

// ---- Glossary ----
// Terms live in glossary-entries.typ. Mark them up in running text with
//   #gl("incartata")                        -> incartata
//   #gl("incartata", display: [incartate])  -> incartate (plural etc.)
// Every use is recorded, so the printed glossary only contains terms that
// actually occur in the current build (one block, or the whole collection).
#let _gl-used = state("glossary-used", ())

#let gl(key, display: auto) = {
  let e = glossary-entries.at(key, default: none)
  assert(e != none, message: "unknown glossary term: " + key)
  _gl-used.update(u => if key in u { u } else { u + (key,) })
  let shown = if display == auto { e.term } else { display }
  if e.at("foreign", default: true) { emph(shown) } else { shown }
}

// Link to another glossary entry (used by the "See" / "See also" lines).
// A pure link: it does not record usage, which is why entries named in a
// `see` field are printed automatically.
// Inside the glossary itself terms are set upright; only running text
// (#gl) italicises foreign terms.
#let gl-link(key, display: auto) = link(
  label("gl-entry-" + key),
  if display == auto { glossary-entries.at(key).term } else { display },
)

// Prints nothing when no terms were used (unless show-all: true), so it is
// safe to call in every build. Entries named in another entry's `see` field
// are printed too, so cross-links never dangle.
#let print-glossary(
  title: [Glossary],
  show-all: false,
  new-page: false,
) = context {
  let keys = if show-all { glossary-entries.keys() } else { _gl-used.final() }
  let changed = true
  while changed {
    changed = false
    for k in keys {
      for t in glossary-entries.at(k).at("see", default: ()) {
        if t not in keys {
          keys.push(t)
          changed = true
        }
      }
    }
  }
  if keys.len() > 0 {
    if new-page { pagebreak(weak: true) }
    heading(level: 1)[#title]
    set par(first-line-indent: 0pt, justify: false)
    set terms(hanging-indent: 1.5em, separator: [: ], tight: false)
    let sorted = keys.sorted(key: k => lower(glossary-entries.at(k).term))
    terms(..sorted.map(k => {
      let e = glossary-entries.at(k)
      let def = e.at("def", default: [])
      let see = e.at("see", default: ())
      let has-def = def not in ([], none)
      // "See also X" after a definition, plain "See X" when there is none.
      let see-line = if see.len() > 0 {
        let names = see.map(t => strong(gl-link(t))).join[, ]
        [#if has-def [See also] else [See] #names.]
      }
      let parts = ()
      if has-def { parts.push(def) }
      if see-line != none { parts.push(see-line) }
      terms.item(
        [#e.term#label("gl-entry-" + k)],
        if parts.len() == 0 { [] } else { parts.join([ ]) },
      )
    }))
  }
}
