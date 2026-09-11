// lib.typ
#import "@preview/in-dexter:0.7.2": *

#let index-start = index.with(index-type: indextype.Start)
#let index-end = index.with(index-type: indextype.End)

#let sourced-figure(img, caption: [], source: none) = block(breakable: false)[
  #figure(img, caption: caption)
  #if source != none [
    #align(center)[
      #text(size: 8pt, style: "italic")[Source: #link(source)[#source]]
    ]
  ]
]
