#import "../config/thesis-config.typ": glpl, gl,
#import "../config/variables.typ": myTutor
#pagebreak(to:"odd")

= Descrizione stage<cap:descrizione-stage>
#text(style: "italic", [
    In questo capitolo viene approfondita l'organizzazione dello stage, descrivendo il progetto realizzato, la metodologia di lavoro adottata, il rapporto con l'azienda e l'analisi preventiva dei rischi.
])
#v(1em)

== Introduzione al progetto

Il progetto di stage si inserisce nel contesto dei servizi di telefonia aziendale offerti da Cinquenet ai propri clienti. L'azienda fornisce soluzioni di centralini virtuali PABX che gestiscono le comunicazioni telefoniche di numerose realtà aziendali. Tuttavia, mancava uno strumento che permettesse ai clienti finali di analizzare autonomamente i dati relativi alle proprie chiamate telefoniche.

L'obiettivo del progetto è stato lo sviluppo di una dashboard web che consentisse ai clienti di visualizzare statistiche dettagliate sulle chiamate effettuate e ricevute, con la possibilità di applicare filtri avanzati e generare report personalizzati. Il sistema doveva integrarsi con l'infrastruttura esistente dei centralini PABX, estraendo i dati dalle basi dati operative e presentandoli in formato accessibile e intuitivo.

La realizzazione è avvenuta completamente ex novo, progettando sia il backend per l'elaborazione dei dati che il frontend per la visualizzazione. La sfida principale è consistita nel comprendere la struttura complessa dei dati telefonici, identificare le informazioni rilevanti e progettare query efficienti per l'estrazione e l'aggregazione delle statistiche.

L'approccio scelto prevedeva la realizzazione di un MVP (Minimum Viable Product) funzionante nel minor tempo possibile, che includesse già le funzionalità base del sistema, anche se non ancora completamente ottimizzate. Questo prototipo iniziale sarebbe poi servito come base per successive iterazioni di miglioramento e ampliamento.

== Organizzazione del lavoro

Per lo sviluppo del progetto è stato adottato il Modello di Sviluppo Evolutivo, una metodologia particolarmente adatta quando i requisiti non sono completamente definibili a priori e si desidera ottenere rapidamente versioni utilizzabili del sistema.

=== Il Modello di Sviluppo Evolutivo

Il Modello Evolutivo è un approccio incrementale in cui gli incrementi successivi costituiscono versioni prototipali utilizzabili e valutabili dagli stakeholder. A differenza di modelli sequenziali rigidi, questo approccio permette di:
#v(0.5em)
- Rispondere a bisogni non inizialmente preventivabili: durante lo sviluppo possono emergere nuovi requisiti o modifiche a quelli esistenti
- Produrre prototipi utilizzabili: ogni iterazione rilascia una versione funzionante del sistema che può essere testata e valutata
- Ammettere iterazioni multiple: ogni fase può essere riattraversata più volte per raffinamenti successivi
- Gestire l'incertezza: particolarmente utile quando la complessità del dominio applicativo richiede esplorazione e apprendimento progressivo

\

#text(weight: "bold")[Schema generale del Modello Evolutivo:]

\
Il processo di sviluppo si articola in tre fasi principali:

\
/ 1. Analisi preliminare: 
Questa fase iniziale è dedicata all'identificazione dei requisiti fondamentali e alla definizione dell'architettura di base del sistema, progettata per essere modulare e facilitare future evoluzioni. Viene inoltre pianificato il percorso di sviluppo suddividendo il lavoro in passi incrementali, e si procede con uno studio approfondito del dominio applicativo, in particolare della struttura dati dei sistemi PABX e della logica delle chiamate telefoniche.

\
/ 2. Analisi e realizzazione iterativa: 
Il sistema viene progressivamente costruito attraverso cicli iterativi in cui l'analisi viene continuamente raffinata in base alle conoscenze acquisite. Ogni iterazione comprende progettazione, codifica e testing delle funzionalità, seguita dall'integrazione dei componenti sviluppati. Al termine di ogni ciclo, il lavoro viene validato attraverso sessioni di feedback con il tutor aziendale per verificare l'aderenza ai requisiti e identificare eventuali necessità di miglioramento.

\
/ 3. Rilascio di prototipi: 
Ogni iterazione produce una versione funzionante del sistema che viene valutata dal tutor aziendale e, nelle fasi più mature, dal cliente finale. I feedback raccolti guidano le iterazioni successive, orientando lo sviluppo verso le reali esigenze degli utilizzatori. Questo processo ciclico continua fino al raggiungimento di un livello di maturità soddisfacente per l'accettazione finale.

=== Applicazione del modello al progetto

Il lavoro è stato organizzato in sprint settimanali, cicli di sviluppo della durata di una settimana ciascuno, strutturati secondo le seguenti fasi:

\
/ Inizio sprint - Riunione di pianificazione: 
Ogni sprint iniziava con un incontro con il tutor aziendale in cui veniva effettuata una revisione del lavoro svolto nella settimana precedente, identificando eventuali criticità o problematiche emerse. Successivamente si procedeva alla definizione degli obiettivi dello sprint corrente e alla pianificazione dettagliata delle attività da svolgere.

\
/ Durante lo sprint:
La fase centrale dello sprint era dedicata allo sviluppo vero e proprio delle funzionalità pianificate, accompagnato da attività continue di testing e debug per garantire la qualità del codice. Durante questa fase erano frequenti confronti informali con il tutor per risolvere dubbi tecnici o richiedere chiarimenti.

\
/ Fine sprint - Riunione di review:
Al termine dello sprint veniva organizzata una sessione di review in cui le funzionalità implementate venivano dimostrate al tutor aziendale. Durante questo incontro si raccoglievano feedback e suggerimenti, si valutava il raggiungimento degli obiettivi prefissati e si identificavano le priorità per lo sprint successivo.

\
Nella fase iniziale del progetto, il supporto del tutor aziendale è stato fondamentale per acquisire le conoscenze necessarie sul dominio applicativo. Il tutor ha dedicato tempo significativo a spiegare la logica di funzionamento dei centralini PABX, illustrare la struttura del database e definire le modalità corrette di estrazione e interpretazione dei dati telefonici. Con il progredire dello stage e l'acquisizione di maggiore autonomia operativa, il ruolo del tutor si è progressivamente evoluto da formativo a consulenziale, focalizzandosi principalmente sulla validazione delle scelte progettuali e sulla definizione di nuovi requisiti emergenti.

== Vincoli

Lo sviluppo del progetto è stato soggetto a diversi vincoli:

\
/ Vincoli temporali:
#v(0.5em)
- Durata complessiva dello stage: 320 ore\
- Necessità di produrre un prototipo dimostrabile entro le prime settimane\
- Scadenze settimanali per il completamento degli sprint

\
/ Vincoli tecnologici:
#v(0.5em)
- Integrazione obbligatoria con l'infrastruttura esistente di Cinquenet\
- Utilizzo del database già in uso per i centralini PABX\
- Requisiti di performance per la gestione di grandi volumi di dati storici

\
/ Vincoli architetturali:
#v(0.5em)
- Necessità di un'architettura modulare per future estensioni\
- Personalizzazione grafica per ciascun cliente finale

== Pianificazione

La pianificazione iniziale del progetto ha seguito lo schema del Modello Evolutivo, suddividendo il lavoro in macro-fasi:

\
/ Settimane 1-2:: Analisi preliminare e setup

- Studio del dominio applicativo (telefonia PABX)
- Analisi della struttura del database esistente
- Definizione dei requisiti fondamentali
- Setup dell'ambiente di sviluppo

\
/ Settimane 3-5:: Primo prototipo (MVP)

- Progettazione dell'architettura del sistema
- Implementazione delle query base per l'estrazione dati
- Sviluppo dell'interfaccia utente minimale
- Prime funzionalità di filtraggio e visualizzazione
- Prima dimostrazione al cliente finale

\
/ Settimane 6-7:: Raffinamento e ottimizzazione

- Ottimizzazione delle performance delle query
- Miglioramento dell'accuratezza dei dati
- Ampliamento delle funzionalità di filtraggio
- Implementazione dell'esportazione dati
- Implementazione eventuali feedback ricevuti

\
/ Settimana 8:: Personalizzazione e finalizzazione

- Sviluppo del sistema di personalizzazione grafica
- Testing completo con dati reali
- Documentazione finale
- Preparazione della presentazione finale al cliente

== Analisi preventiva dei rischi

Durante la fase iniziale del progetto è stata condotta un'analisi dei rischi per identificare le potenziali criticità che avrebbero potuto compromettere il successo dello stage. Per ciascun rischio sono stati valutati la probabilità di occorrenza, l'impatto sul progetto e le strategie di mitigazione adottate.

\
/ R1 - Non rispetto delle tempistiche:
#v(0.5em)
- #text(weight: "bold")[Descrizione:] Impossibilità di completare le funzionalità pianificate entro le 320 ore di stage.
- #text(weight: "bold")[Probabilità:] Media
- #text(weight: "bold")[Impatto:] Alto
- #text(weight: "bold")[Cause potenziali:]

    - Sottostima della complessità tecnica
    - Difficoltà impreviste nell'integrazione con sistemi esistenti
    - Scarsa familiarità iniziale con il dominio applicativo

- #text(weight: "bold")[Strategie di mitigazione adottate:]

    - Adozione del Modello Evolutivo per rilasciare versioni funzionanti già dalle prime settimane
    - Pianificazione di sprint brevi (1 settimana) per identificare rapidamente eventuali ritardi
    - Definizione chiara delle priorità: focus sulle funzionalità core (MVP) prima delle funzionalità secondarie
    - Confronti settimanali con il tutor per ricalibrazione tempestiva degli obiettivi

\
/ R2 - Inaccuratezza dei dati mostrati:
#v(0.5em)
- #text(weight: "bold")[Descrizione:] Visualizzazione di statistiche e dati non corretti o fuorvianti per l'utente finale.
- #text(weight: "bold")[Probabilità:] Alta
- #text(weight: "bold")[Impatto:] Alto
- #text(weight: "bold")[Cause potenziali:]

    - Errata interpretazione della logica dei dati telefonici
    - Query SQL non corrette o incomplete
    - Mancata gestione di casi particolari nel dominio PABX
    - Problemi di aggregazione e calcolo delle statistiche

- #text(weight: "bold")[Strategie di mitigazione adottate:]

    - Sessioni approfondite con il tutor per comprendere la semantica dei dati PABX
    - Validazione incrociata dei risultati con report esistenti o conteggi manuali
    - Testing incrementale con dataset reali forniti dall'azienda
    - Revisione frequente delle query SQL con il tutor aziendale

\
/ R3 - Difficoltà nel recupero dei dati:
#v(0.5em)
- #text(weight: "bold")[Descrizione:] Complessità tecnica nell'estrazione efficiente dei dati dal database PABX.
- #text(weight: "bold")[Probabilità:] Media
- #text(weight: "bold")[Impatto:] Alto
- #text(weight: "bold")[Cause potenziali:]

    - Struttura del database complessa e non documentata
    - Performance scarse con query su grandi volumi di dati storici
    - Necessità di aggregazioni complesse

- #text(weight: "bold")[Strategie di mitigazione adottate:]

    - Fase iniziale dedicata esclusivamente allo studio del database
    - Creazione di query di test incrementali per validare la comprensione della struttura
    - Utilizzo di indici e ottimizzazioni progressive delle query

\
/ R4 - Scarsa esperienza con le tecnologie utilizzate:
#v(0.5em)
- #text(weight: "bold")[Descrizione:]  Limitata familiarità con alcuni strumenti, linguaggi o framework necessari per il progetto.
- #text(weight: "bold")[Probabilità:] Bassa
- #text(weight: "bold")[Impatto:] Medio
- #text(weight: "bold")[Cause potenziali:]

    - Tecnologie non approfondite durante il percorso universitario
    - Specificità degli strumenti utilizzati in azienda
    - Curva di apprendimento necessaria per essere produttivi

- #text(weight: "bold")[Strategie di mitigazione adottate:]

    - Studio autonomo preliminare delle tecnologie principali
    - Utilizzo di documentazione ufficiale e tutorial
    - Refactoring progressivo del codice man mano che la padronanza aumentava

\
/ R5 - Requisiti poco chiari o in evoluzione:
#v(0.5em)
- #text(weight: "bold")[Descrizione:]  Cambiamenti frequenti o ambiguità nei requisiti funzionali richiesti.
- #text(weight: "bold")[Probabilità:] Media
- #text(weight: "bold")[Impatto:] Medio
- #text(weight: "bold")[Cause potenziali:]

    - Necessità del cliente finale non completamente definite a priori
    - Feedback emergenti durante la visualizzazione dei prototipi
    - Nuove esigenze identificate durante lo sviluppo

- #text(weight: "bold")[Strategie di mitigazione adottate:]

    - Scelta del Modello Evolutivo proprio per gestire l'incertezza sui requisiti
    - Architettura modulare e flessibile per facilitare modifiche
    - Validazione frequente con il tutor e raccolta sistematica di feedback
    - Prioritizzazione dei requisiti: implementazione immediata dei requisiti certi, posticipazione di quelli incerti

\
/ R6 - Problemi di performance del sistema:
#v(0.5em)
- #text(weight: "bold")[Descrizione:]  Tempi di risposta inaccettabili per l'utente finale, specialmente con grandi volumi di dati.
- #text(weight: "bold")[Probabilità:] Media
- #text(weight: "bold")[Impatto:] Basso
- #text(weight: "bold")[Cause potenziali:]

    - Query SQL non ottimizzate
    - Mancanza di indici appropriati
    - Caricamento di troppi dati contemporaneamente
    - Elaborazioni pesanti lato client

- #text(weight: "bold")[Strategie di mitigazione adottate:]

    - Test di performance fin dalle prime versioni con dataset realistici
    - Ottimizzazione progressiva delle query più critiche
    - Implementazione di paginazione e lazy loading
    - Monitoring dei tempi di esecuzione delle query principali