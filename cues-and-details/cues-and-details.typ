#import "../lib.typ": block-layout

#let cues-and-details(standalone: true) = block-layout(
  include "cues-and-details_content.typ",
  doc-title: "Cues and Details",
  doc-version: "0.0.1",
  last-updated: datetime(year: 2026, month: 10, day: 19),
  standalone: standalone,
  tag: "cues-and-details",
)

#cues-and-details()
