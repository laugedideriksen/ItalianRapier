#import "../lib.typ": block-layout

#let balance-and-voiding(standalone: true) = block-layout(
  include "balance-and-voiding_content.typ",
  doc-title: "Balance and Voiding",
  doc-version: "1.2.0",
  last-updated: datetime(year: 2026, month: 9, day: 9),
  standalone: standalone,
)

#balance-and-voiding()
