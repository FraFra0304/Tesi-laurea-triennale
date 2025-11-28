#import "data/requirements_list.typ": *

#pagebreak(to:"odd")

= Conclusione<cap:conclusione>
#text(style: "italic", [
    Il presente capitolo analizza i risultati conseguiti durante lo stage presso Cinquenet S.r.l., valutando il raggiungimento degli obiettivi, le competenze acquisite e le prospettive future del sistema sviluppato.
])
#v(1em)

== Raggiungimento degli obiettivi

Il progetto di stage aveva come obiettivo principale lo sviluppo di una dashboard web per la visualizzazione delle statistiche delle chiamate effettuate e ricevute tramite i centralini virtuali PABX offerti da Cinquenet S.r.l. Al termine del periodo di stage, è possibile affermare che tutti gli obiettivi prefissati al #link(<cap:analisi_dei_requisiti>)[capitolo 3] durante l'analisi dei requisiti sono stati raggiunti con successo.

=== Requisiti funzionali

#[
#show figure: set block(breakable: true)
#set table(
  align: (center+horizon, left+horizon, center+horizon),
  columns: (auto, auto, auto),
)
#v(1em)

#figure(
    table(
      align: (center+horizon, left+horizon, center+horizon),
      table.header([*Codice*], [*Descrizione*], [*Risultato*]),
      ..getFunzionali().flatten().chunks(2).map(row => (row.at(0), row.at(1), "Soddisfatto")).flatten()
    ),
    caption: "Raggiungimento dei requisti funzionali.",
)
<tab:raggiungimento-requisiti-funzionali>
]

#pagebreak()

=== Requisiti non funzionali

#[
#show figure: set block(breakable: true)
#set table(
  align: (center+horizon, left+horizon, center+horizon),
  columns: (auto, auto, auto),
)
#v(1em)

#figure(
    table(
      align: (center+horizon, left+horizon, center+horizon),
      table.header([*Codice*], [*Descrizione*], [*Risultato*]),
      ..getNonFunzionali().flatten().chunks(2).map(row => (row.at(0), row.at(1), "Soddisfatto")).flatten()
    ),
    caption: "Raggiungimento dei requisti non funzionali.",
)
<tab:raggiungimento-requisiti-non-funzionali>
]

#pagebreak()

=== Riepilogo dei risultati

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    table.header([*Tipologia*], [*Quantità*], [*Soddisfatti*]),
    [*Funzionali*], [*#{getFunzionali(getLen: true).at(0)+getFunzionali(getLen: true).at(1)+getFunzionali(getLen: true).at(2)}*], [*#{getFunzionali(getLen: true).at(0)+getFunzionali(getLen: true).at(1)+getFunzionali(getLen: true).at(2)}*],
    [Funzionali Obbligatori], [#getFunzionali(getLen: true).at(0)], [#getFunzionali(getLen: true).at(0)],
    [Funzionali Desiderabili], [#getFunzionali(getLen: true).at(1)], [#getFunzionali(getLen: true).at(1)],
    [Funzionali Opzionali], [#getFunzionali(getLen: true).at(2)], [#getFunzionali(getLen: true).at(2)],
    
    [*Non Funzionali*], [*#{getNonFunzionali(getLen: true).at(0)+getNonFunzionali(getLen: true).at(1)}*], [*#{getNonFunzionali(getLen: true).at(0)+getNonFunzionali(getLen: true).at(1)}*],
    [Non Funzionali Qualitativi], [#getNonFunzionali(getLen: true).at(0)], [#getNonFunzionali(getLen: true).at(0)],
    [Non Funzionali Vincoli], [#getNonFunzionali(getLen: true).at(1)], [#getNonFunzionali(getLen: true).at(1)],
    [*Totale*],
    [*#{getFunzionali(getLen: true).at(0)+getFunzionali(getLen: true).at(1)+getFunzionali(getLen: true).at(2)+getNonFunzionali(getLen: true).at(0)+getNonFunzionali(getLen: true).at(1)}*],
    [*#{getFunzionali(getLen: true).at(0)+getFunzionali(getLen: true).at(1)+getFunzionali(getLen: true).at(2)+getNonFunzionali(getLen: true).at(0)+getNonFunzionali(getLen: true).at(1)}*],
    align: (center+horizon)
  ),
  caption: "Riepilogo dei requisiti soddisfatti."
)<tab:requisiti-soddisfatti>

== Competenze acquisite

L'esperienza di stage ha permesso l'acquisizione di competenze significative in tre ambiti principali, ciascuno dei quali ha contribuito in modo complementare alla formazione professionale complessiva.

=== Competenze tecniche

Sul piano tecnico, il progetto ha consentito un approfondimento sostanziale dei sistemi PABX e del protocollo SIP, comprendendo le logiche di routing delle chiamate, la struttura dei Call Detail Record e le modalità di estrazione e interpretazione dei dati telefonici. Lo sviluppo full-stack con Node.js e Express ha consolidato la capacità di progettare API RESTful robuste e sicure, mentre l'implementazione di design pattern quali Builder, Repository, Factory e Chain of Responsibility ha fornito strumenti concreti per affrontare problemi di complessità crescente mantenendo il codice manutenibile. Particolare attenzione è stata dedicata all'ottimizzazione delle query SQL per grandi volumi di dati, sperimentando tecniche come Common Table Expressions, window functions e indicizzazione strategica per garantire tempi di risposta adeguati anche su dataset estesi.

=== Competenze metodologiche

Dal punto di vista metodologico, l'adozione dello sviluppo evolutivo con iterazioni settimanali ha permesso di comprendere concretamente i benefici di un approccio incrementale. La pratica costante di rilasciare versioni funzionanti al termine di ogni sprint, raccogliendo feedback immediato dal tutor aziendale, ha evidenziato l'importanza della validazione continua in contesto aziendale. Questa metodologia ha inoltre insegnato a gestire l'incertezza iniziale sui requisiti, raffinando progressivamente le funzionalità sulla base delle esigenze reali emerse durante l'utilizzo.

=== Competenze professionali

Sul piano professionale, l'esperienza ha sviluppato la capacità di bilanciare scelte tecnologiche con il contesto aziendale specifico. Operare in un'azienda specializzata in hardware e telecomunicazioni, con competenze di sviluppo software limitate, ha richiesto di privilegiare soluzioni consolidate e facilmente manutenibili rispetto a tecnologie all'avanguardia ma potenzialmente complesse da gestire nel lungo periodo. Questa consapevolezza costituisce una competenza trasversale fondamentale, poiché nel contesto lavorativo reale le decisioni tecniche non possono prescindere dalla valutazione delle risorse disponibili e dalla sostenibilità a lungo termine delle soluzioni adottate.

== Valutazione critica e sviluppi futuri

=== Limitazioni del sistema attuale

A progetto concluso, è possibile individuare alcune limitazioni architetturali e funzionali che, seppur non invalidanti rispetto agli obiettivi raggiunti, costituiscono opportunità di miglioramento per future iterazioni del sistema.

Dal punto di vista dell'accesso ai dati, il sistema opera su un sottoinsieme di tabelle replicate localmente dal database del centralino PABX. Questa scelta architetturale, pur garantendo performance ottimali e isolamento dal sistema telefonico in produzione, limita le possibilità analitiche a quanto contenuto nei soli _Call Detail Record_. Funzionalità avanzate come l'integrazione con le registrazioni audio, il tracking dettagliato dei trasferimenti di chiamata o le statistiche di performance per agente risultano irrealizzabili senza accesso completo all'infrastruttura del vendor.

Sul fronte del frontend, l'assenza di un framework strutturato come React o Vue.js, pur giustificata dalla necessità di manutenibilità da parte di personale non specializzato, potrebbe rendere complessa l'evoluzione dell'interfaccia verso funzionalità più interattive. La gestione dello stato applicativo lato client, attualmente distribuita tra variabili globali e sessione, beneficerebbe di un approccio più centralizzato in caso di espansione significativa delle funzionalità.

Relativamente al testing, la copertura automatizzata si concentra principalmente sulla validazione delle API backend attraverso test manuali con Postman. L'assenza di test unitari sistematici e di test end-to-end automatizzati rappresenta un'area di miglioramento per garantire maggiore robustezza in scenari di manutenzione evolutiva.

=== Possibili evoluzioni future

L'evoluzione del sistema potrebbe beneficiare di diversi miglioramenti strutturali e funzionali, subordinati all'ottenimento di autorizzazioni e risorse aggiuntive.

L'accesso completo al database del centralino permetterebbe di implementare funzionalità di analisi significativamente più avanzate. Sarebbe possibile integrare un player audio per l'ascolto diretto delle registrazioni, implementare sistemi di trascrizione automatica delle conversazioni, e sviluppare metriche di qualità del servizio basate sull'analisi del sentiment. Queste evoluzioni trasformerebbero il sistema da strumento di reporting a piattaforma di business intelligence per le telecomunicazioni.

L'implementazione di dashboard configurabili con widget personalizzabili consentirebbe a ciascun cliente di costruire viste specifiche per le proprie esigenze operative. Analisi comparative tra periodi temporali o tra sedi differenti fornirebbero insight strategici, mentre sistemi di alerting basati su soglie configurabili permetterebbero notifiche proattive al verificarsi di condizioni anomale.

Dal punto di vista tecnologico, l'adozione di un framework frontend moderno migliorerebbe l'esperienza utente e faciliterebbe l'implementazione di funzionalità real-time come aggiornamenti live delle statistiche. L'introduzione di una suite di testing automatizzato, comprendente test unitari, di integrazione e end-to-end, garantirebbe maggiore affidabilità durante le fasi di manutenzione evolutiva del sistema.

== Considerazioni finali

L'esperienza di stage ha rappresentato un momento formativo fondamentale nel percorso accademico, permettendo il confronto diretto con le dinamiche reali dello sviluppo software in contesto aziendale. Il completamento di tutti i requisiti previsti, compresi quelli inizialmente considerati opzionali, dimostra l'efficacia dell'approccio metodologico adottato e la validità delle scelte architetturali effettuate in fase di progettazione.

Particolarmente formativa è stata la necessità di operare entro i vincoli di sicurezza e accesso ai dati imposti dall'infrastruttura aziendale. La scelta di mantenere una replica locale dei CDR anziché interrogare direttamente il database del centralino, pur introducendo complessità nella sincronizzazione, ha rappresentato una soluzione che bilancia requisiti di performance, sicurezza e disponibilità del servizio. Queste limitazioni hanno stimolato soluzioni creative e ottimizzazioni che hanno reso il sistema più efficiente e robusto.

La collaborazione con il tutor aziendale si è rivelata determinante per apprendere la complessità del dominio telecomunicazioni e comprendere le reali esigenze degli utenti finali. Il supporto intensivo nella fase iniziale, dedicato a spiegare la logica di funzionamento dei centralini PABX e la struttura del database, ha posto le basi per uno sviluppo consapevole e orientato ai requisiti effettivi. La progressiva evoluzione del rapporto da formativo a consulenziale ha inoltre permesso di sviluppare autonomia decisionale mantenendo un costante confronto sulle scelte progettuali.

Il progetto ha prodotto un sistema completo, attualmente in produzione, che genera valore tangibile per l'azienda ospitante e i suoi clienti. Questa concretezza del risultato, unita alle competenze tecniche e metodologiche acquisite, conferma il mio interesse per lo sviluppo di applicazioni web enterprise e fornisce una solida base per l'ingresso nel mondo del lavoro nel settore informatico.