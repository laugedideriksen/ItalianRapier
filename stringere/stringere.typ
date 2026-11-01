#import "../lib.typ": block-layout

#let stringere(standalone: true) = block-layout(
  include "stringere_content.typ",
  doc-title: "Stringere",
  doc-version: "0.0.1",
  last-updated: datetime(year: 2026, month: 10, day: 19),
  standalone: standalone,
  tag: "stringere",
)

#stringere()
