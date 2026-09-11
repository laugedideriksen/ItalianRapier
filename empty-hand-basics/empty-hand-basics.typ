#import "../lib.typ": block-layout

#let empty-hand-basics(standalone: true) = block-layout(
  include "empty-hand-basics_content.typ",
  doc-title: "Empty Hand Basics",
  doc-version: "1.3.1",
  last-updated: datetime(year: 2026, month: 9, day: 9),
  standalone: standalone,
)

#empty-hand-basics()
