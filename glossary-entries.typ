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
    def: [A somewhat ambiguous term central to Italian rapier fencing, meaning something like 'constraining'.],
  ),
  "volte": (
    term: "Volte",
    def: [],
    see: ("incartata",),
  ),
  "inquartata": (
    term: "Inquartata",
    def: [],
    see: ("incartata",),
  ),
  "stesso-tempo": (
    term: "stesso tempo",
    def: [A counter done 'in one time'.],
  ),
  "dui-tempi": (
    term: "a dui tempi",
    def: [To do something, usually a reaction, 'in two tempi'. Parry-riposte is an example of an action _a dui tempi_.],
  ),
  "incartata": (
    term: "Incartata",
    def: [Also *Volte* or *Inquartata*. A void performed by violently turning the body and catching one's weight on the back leg. ],
    see: ("scanzo",),
  ),
  "passata": (
    term: "Passata",
    def: [],
  ),
  "passata-sotto": (
    term: "Passata sotto",
    def: [],
  ),
  "scanzo": (
    term: "Scanzo",
    def: [A void performed by violently turning the body and catching one's weight on the front foot.],
    see: ("incartata",),
  ),
  "drop-step": (
    term: "Drop step",
    foreign: false,
    def: [],
  ),
  "guard": (
    term: "Guard",
    foreign: false,
    def: [],
  ),
  "traverso": (
    term: "Traverso",
    def: [A lunge-like step diagonal or orthogonal to the fencing line.],
  ),
  "terza": (
    term: "Terza",
    def: [A position/orientation of the hand and blade, such that the true edge faces the ground.],
  ),
  "cavazione": (
    term: "Cavazione",
    def: [en: 'disengage'. To free one's blade from an opponent's bind by moving it from the inside to the outside, or vice versa, under the opponent's blade. A disengage can either finish by re-entering the bind (in a dominant position), attacking with a thrust in opposition, or displacing the opponent's blade with a battuta.],
  ),
  "contracavazione": (
    term: "Contracavazione",
    def: [en: 'counterdisengage'. An idiomatic counter to an opponent's disengaging. As the opponent disengages, before they re-enter the bind or attack in opposition, the fencer does a disengage of their own.],
    see: ("cavazione",),
  ),
  "stoccatta": (
    term: "Stoccatta",
    def: [In Capo Ferro: a thrust in _terza_; in Saviolo: any thrust where the fingernails on the rapier-hand face in- or upwards.],
  ),
  "thrust-in-opposition": (
    term: "Thrust in opposition",
    def: [A thrust were the fencer's blade remains in contact with the opponent's. This can be either to displace it or to prevent a direct counter.],
  ),
  "divertimento": (
    term: "Divertimento",
    def: [Displacing the opponent's blade by pressing it out of line. This is often used to provoke a reaction.],
  ),
  "void": (
    term: "Void",
    def: [de: 'Körperparade'. Avoiding an attack by moving the body out of the way, while staying in range. Often combined with a counter _stesso tempo_.],
  ),
)
