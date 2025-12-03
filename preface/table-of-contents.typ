#import "../config/constants.typ": figuresList, tablesList, sourceCodeList
#set page(numbering: "i")

#[
  #show outline.entry.where(level: 1): it => {
    linebreak()
    link(it.element.location(), strong(it))
    h(1fr)
  }
  #outline(
    depth: 5
  )
]

#pagebreak()

#outline(
  title: figuresList,
  target: figure.where(kind: image)
)

#v(6em)

#outline(
    title: tablesList,
    target: figure.where(kind: table),
)
