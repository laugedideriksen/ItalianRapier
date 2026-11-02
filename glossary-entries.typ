// glossary-entries.typ -- single source of truth for glossary terms.
//
//   key:     plain ASCII string used in the text, e.g. #gl("stesso-tempo")
//   term:    how the term is printed (headword and in running text)
//   foreign: true (default) sets the term in italics; false for English terms
//   def:     the definition (content)
//
// The definitions below are PLACEHOLDERS -- replace them with your own.
// Keep this file free of angle-bracket label syntax (scripts/labels.sh
// greps every .typ file for it).

#let glossary-entries = (
  "stringere": (
    term: "Stringere",
    def: [An ambiguous term central to Italian rapier fencing. See the chapter @stringere.],
  ),
  "volte": (
    term: "Volte",
    def: [],
    see: ("incartata",),
  ),
  "stesso-tempo": (
    term: "Stesso tempo",
    def: [TODO],
  ),
  "dui-tempi": (
    term: "Dui tempi",
    def: ['Two tempi'. Parry-riposte is an example of an action _a dui tempi_.],
  ),
  "incartata": (
    term: "Incartata",
    def: [A void performed by violently turning the body and catching one's weight on the back leg. Also known as *Volte*.],
    see: ("scanzo",),
  ),
  "passata": (
    term: "Passata",
    def: [TODO],
  ),
  "passata-sotto": (
    term: "Passata sotto",
    def: [TODO],
  ),
  "scanzo": (
    term: "Scanzo",
    def: [TODO],
  ),
  "drop-step": (
    term: "Drop step",
    foreign: false,
    def: [TODO],
  ),
  "guard": (
    term: "Guard",
    foreign: false,
    def: [TODO],
  ),
  "traverso": (
    term: "Traverso",
    def: [A lunge-like step diagonal or orthogonal to the fencing line.],
  ),
)
