#import "../config/thesis-config.typ": glpl
#import "data/requirements_list.typ": *

#pagebreak(to:"odd")



= Analisi dei requisiti

_In questo capitolo vengono analizzati e approfonditi i requisiti individuati per la realizzazione del progetto di dashboard per l'analisi delle chiamate telefoniche._

== Introduzione ai requisiti

I requisiti del sistema sono stati identificati attraverso un processo di analisi condotto in collaborazione con il tutor aziendale e, successivamente, validati con il cliente finale durante la presentazione del primo prototipo funzionante. Questi sono stati suddivisi in due macro categorie principali:
#v(1em)
/ Requisiti funzionali: Rappresentano le funzionalità che il sistema deve offrire per rispondere alle esigenze degli utenti finali, definendo le operazioni che la dashboard deve essere in grado di svolgere. Si suddividono in:

  - *Obbligatori*: indispensabili per il corretto funzionamento del sistema e per soddisfare le necessità primarie degli utenti
  - *Desiderabili*: non strettamente necessari, tuttavia se implementati garantiscono una migliore esperienza utente e una maggiore usabilità del software
  - *Opzionali*: la loro aggiunta non è essenziale per il funzionamento base del sistema, vengono implementati se rimane tempo a disposizione al termine dello sviluppo delle funzionalità prioritarie
#v(1em)
/ Requisiti non funzionali: Di questa categoria fanno parte i requisiti qualitativi e quelli di vincolo. I primi garantiscono una qualità maggiore del software dal punto di vista delle prestazioni, usabilità, affidabilità e sicurezza. I requisiti di vincolo invece stabiliscono limitazioni o condizioni che il sistema deve rispettare, come tecnologie da utilizzare, standard aziendali o normative da seguire.

== Tracciamento dei requisiti

Per garantire una classificazione chiara e sistematica, i requisiti raccolti sono stati categorizzati in base alla loro tipologia e priorità, utilizzando la seguente notazione:

#figure(
  table(
    columns: (auto, auto),
    align: left,
    [*Sigla*], [*Significato*],
    [F], [Funzionale],
    [N], [Non funzionale],
    [Q], [Qualitativo],
    [V], [Vincolo],
    [O], [Obbligatorio],
    [D], [Desiderabile],
    [P], [Opzionale],
  ),
  caption: [Legenda per la classificazione dei requisiti]
)

Ogni requisito è stato identificato secondo il seguente schema di codifica:

#align(center)[
  #text(size: 14pt, weight: "bold")[R-XY-N]
]

dove:
- *R* indica che si tratta di un requisito
- *X* indica se il requisito è funzionale (F) o non funzionale (N)
- *Y* indica il livello di importanza se il requisito è funzionale, oppure la tipologia se è non funzionale:
  - se X = F, allora Y può assumere i valori O (obbligatorio), D (desiderabile) o P (opzionale)
  - se X = N, allora Y può assumere i valori Q (qualitativo) o V (vincolo)
- *N* identifica in maniera univoca il requisito all'interno della sua macro categoria

#pagebreak()

== Requisiti funzionali

Di seguito vengono elencati i requisiti funzionali identificati per il sistema di dashboard.

#[
#show figure: set block(breakable: true)
#set table(
  align: (center+horizon, left+horizon, center+horizon),
  columns: (auto, auto),
)
#v(1em)

#figure(
    table(
      align: (center+horizon, left+horizon),
      table.header([*Codice*], [*Descrizione*]),
      ..getFunzionali().flatten()
    ),
    caption: "Tracciamento dei requisti funzionali.",
)
<tab:requisiti-funzionali>
]

#pagebreak()

== Requisiti non funzionali

I requisiti non funzionali definiscono gli aspetti qualitativi e i vincoli tecnici del sistema.

#[
#show figure: set block(breakable: true)
#set table(
  align: (center+horizon, left+horizon, center+horizon),
  columns: (auto, auto),
)
#v(1em)
#figure(
    table(
      align: (center+horizon, left+horizon),
      table.header([*Codice*], [*Descrizione*]),
      ..getNonFunzionali().flatten()
    ),
    caption: "Tracciamento dei requisti non funzionali.",
)
<tab:requisiti-non-funzionali>
]


== Riepilogo dei requisiti

La tabella seguente riporta il riepilogo quantitativo dei requisiti identificati durante la fase di analisi.


#figure(
  table(
    columns: (1fr, auto),
    align: (left, center),
    [*Tipologia*], [*Quantità*],
    [Requisiti funzionali], [#getFunzionali(getLen: true).sum()],
    [#h(1em) - Obbligatori], [#getFunzionali(getLen: true).at(0)],
    [#h(1em) - Desiderabili], [#getFunzionali(getLen: true).at(1)],
    [#h(1em) - Opzionali], [#getFunzionali(getLen: true).at(2)],
    [Requisiti non funzionali], [#getNonFunzionali(getLen: true).sum()],
    [#h(1em) - Qualitativi], [#getNonFunzionali(getLen: true).at(0)],
    [#h(1em) - Di vincolo], [#getNonFunzionali(getLen: true).at(1)],
    table.hline(),
    [*Totale*], [*#{getFunzionali(getLen: true).sum()+getNonFunzionali(getLen: true).sum()}*],
  ),
  caption: [Riepilogo dei requisiti di progetto]
)

/*
#figure(
  table(
    columns: (auto, 1fr, 1fr, auto, auto),
    table.header([*Tipo*], [*Mandatory*], [*Desirable*],[*Optional*], [*Somma*]),
    [Functional], [#getFunzionali(getLen: true).at(0)], [#getFunzionali(getLen: true).at(1)], [#getFunzionali(getLen: true).at(2)], [#getFunzionali(getLen: true).sum()],
    [Qualitative], [#getQR(getLen: true).at(0)], [#getQR(getLen: true).at(1)], [#getQR(getLen: true).at(2)], [#getQR(getLen: true).sum()],
    [Constraint], [#getCR(getLen: true).at(0)], [#getCR(getLen: true).at(1)], [#getCR(getLen: true).at(2)], [#getCR(getLen: true).sum()],
    [*Totale*],
      [*#{getFunzionali(getLen: true).at(0)+getQR(getLen: true).at(0)+getCR(getLen: true).at(0)}*],
      [*#{getFunzionali(getLen: true).at(1)+getQR(getLen: true).at(1)+getCR(getLen: true).at(1)}*],
      [*#{getFunzionali(getLen: true).at(2)+getQR(getLen: true).at(2)+getCR(getLen: true).at(2)}*],
      [*#{getFunzionali(getLen: true).sum()+getQR(getLen: true).sum()+getCR(getLen: true).sum()}*],
    align: (center+horizon)
  ),
  caption: "Riepilogo dei requisiti."
)<tab:riepilogo-requisiti>
*/