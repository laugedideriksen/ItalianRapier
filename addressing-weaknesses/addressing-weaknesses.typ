#import "../lib.typ": block-layout

#let addressing-weaknesses(standalone: true) = block-layout(
  include "addressing-weaknesses_content.typ",
  doc-title: "Addressing Non-technical Weaknesses",
  doc-version: "0.0.1",
  last-updated: datetime(year: 2026, month: 9, day: 10),
  standalone: standalone,
  tag: "addressing-weaknesses",
)

#addressing-weaknesses()
