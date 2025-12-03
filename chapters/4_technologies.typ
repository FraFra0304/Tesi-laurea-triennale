#import "../config/thesis-config.typ": *
#import "../config/variables.typ": myTutor
#pagebreak(to:"odd")

= Tecnologie<cap:tecnologie>
#text(style: "italic", [
    In questo capitolo vengono presentate le tecnologie e gli strumenti utilizzati per lo sviluppo del progetto. Le scelte tecnologiche sono state effettuate sulla base dell'analisi dei requisiti del capitolo precedente, con particolare attenzione ai vincoli imposti dall'azienda ospitante e alla compatibilità con l'infrastruttura esistente.

    Per ogni tecnologia viene fornita una breve descrizione e vengono spiegate le motivazioni che hanno portato alla sua adozione nel contesto specifico del progetto. 
])
#v(1em)

#pagebreak()

== Linguaggi e Framework

=== HTML, CSS e JavaScript

#figure(
    image("../images/html_css_js.png", height: 15%),
    caption: [Logo HTML5, CSS3 e JavaScript]
) <logo_html_css_js>

HTML (HyperText Markup Language), CSS (Cascading Style Sheets) e JavaScript (@logo_html_css_js) sono i linguaggi fondamentali per lo sviluppo di applicazioni web. HTML fornisce la struttura semantica dei contenuti, CSS gestisce la presentazione visuale e il layout, mentre JavaScript implementa la logica interattiva e il comportamento dinamico dell'applicazione.

#v(1em)
/ Motivazioni della scelta:

La decisione di utilizzare le tecnologie web native, senza #gl("framework") moderni come React Angular o Vue.js, è stata guidata da specifici vincoli aziendali e caratteristiche del progetto:
#v(0.5em)
- #text(weight: "bold")[Vincolo aziendale:] L'azienda ospitante ha espresso la necessità di evitare l'adozione di framework complessi con curve di apprendimento ripide e dipendenze esterne. I dipendenti dell'azienda hanno una familiarità consolidata con HTML, CSS e JavaScript, rendendo più agevole la manutenzione e l'evoluzione del codice nel tempo.

- #text(weight: "bold")[Semplicità dell'interfaccia:] L'applicazione sviluppata presenta un'interfaccia utente relativamente semplice, che non richiede le funzionalità avanzate offerte dai framework moderni. L'uso diretto di HTML, CSS e JavaScript consente di mantenere il codice leggero e facilmente comprensibile.

- #text(weight: "bold")[Manutenibilità:] Per semplificare la manutenzione e lo sviluppo, sono state create classi JavaScript modulari e riutilizzabili per la generazione di elementi comuni come tabelle e grafici, garantendo coerenza nel codice senza la complessità aggiuntiva dei framework.

- #text(weight: "bold")[Prestazioni e scalabilità:] L'approccio nativo offre dimensioni ridotte dell'applicazione e tempi di caricamento più rapidi. Le tecnologie web standard mantengono inoltre una migliore compatibilità retroattiva con i browser, riducendo il rischio di obsolescenza del codice nel tempo.

=== Node.js

#figure(
    image("../images/nodejs.png", height: 15%),
    caption: [Logo Node.js]
) <logo_nodejs>

Node.js @nodejs (@logo_nodejs) è un ambiente di esecuzione JavaScript lato server che consente di sviluppare applicazioni scalabili e ad alte prestazioni. Viene utilizzato per gestire il backend dell'applicazione, inclusa la logica di business, la gestione delle richieste HTTP e l'interazione con il database.

#v(1em)
/ Motivazioni della scelta:

La scelta di Node.js per lo sviluppo del backend è stata motivata da diverse considerazioni tecniche e stategiche:
#v(0.5em)
- #text(weight: "bold")[Architettura API-first:] L'obiettivo del progetto era creare un backend basato su API RESTful che permettesse una netta separazione tra frontend e backend. Questa architettura facilita eventuali integrazioni future con altri sistemi software aziendali, consentendo di esporre le funzionalità del sistema telefonico attraverso endpoint ben definiti. Un'architettura basata su API rende inoltre il sistema più flessibile e manutenibile nel tempo.

- #text(weight: "bold")[Coerenza linguistica:] Mantenere JavaScript come linguaggio principale sia per il frontend che per il backend semplifica lo sviluppo e la manutenzione del codice. Gli sviluppatori possono lavorare su entrambe le parti dell'applicazione senza dover imparare linguaggi diversi, riducendo la curva di apprendimento e migliorando la produttività del team.

- #text(weight: "bold")[Ecosistema npm:] Node.js beneficia di npm, uno dei registri di pacchetti più grandi e attivi al mondo. Questo ecosistema offre una vasta gamma di librerie e strumenti che accelerano lo sviluppo, consentendo di integrare funzionalità complesse con facilità.

- #text(weight: "bold")[Prestazioni per operazioni I/O:] Node.js è particolarmente adatto per applicazioni che richiedono un'elevata gestione delle operazioni di input/output, come le API RESTful. La sua architettura basata su eventi e il modello non bloccante consentono di gestire un gran numero di connessioni simultanee in modo efficiente.

== Database Management System

=== MySQL Server

#figure(
    image("../images/mysql.png", height: 15%),
    caption: [Logo MySQL]
) <logo_mysql>

MySQL @mysql (@logo_mysql) è un database management system (#gl("dbms")) relazionale open source tra i più diffusi e utilizzati al mondo. Supporta il linguaggio SQL standard per la gestione e l'interrogazione dei dati, offrendo funzionalità avanzate come gestione delle transazioni #gl("acid"), meccanismi di backup e recovery, replicazione dei dati e ottimizzazione delle query. E' particolarmente adatto per applicazioni web grazie alla sua scalabilità, affidabilità e facilità di integrazione con vari linguaggi di programmazione, incluso JavaScript tramite Node.js.

#v(1em)
/ Motivazioni della scelta:

La decisione di adottare MySQL Server come DBMS per il progetto è stata guidata principalmente da ragioni di continuità tecnologica e compatibilità con l'infrastruttura esistente:
#v(0.5em)
- #text(weight: "bold")[Coerenza con il sistema esistente:] Il centralino telefonico venduto da Cinquenet srl utilizza già MySQL come database per la gestione dei dati operativi (chiamate, utenti, configurazioni, ecc.). Mantenere la stessa tecnologia garantisce uniformità nell'infrastruttura IT aziendale e semplifica notevolmente la gestione complessiva dei sistemi.

- #text(weight: "bold")[Competenze interne:] Il personale tecnico dell'azienda possiede già familiarità con MySQL, riducendo la necessità di formazione aggiuntiva e facilitando la manutenzione e l'ottimizzazione del database nel tempo. Il team può gestire autonomamente backup, ottimizzazioni e troubleshooting senza necessità di acquisire nuove competenze su altri DBMS.

- #text(weight: "bold")[Leggerezza e prestazioni:] MySQL è noto per la sua efficienza e capacità di gestire carichi di lavoro elevati, rendendolo adatto per applicazioni web che richiedono accessi frequenti al database. La sua architettura ottimizzata consente di ottenere buone prestazioni anche con risorse hardware limitate.

=== MySQL Workbench

#figure(
    image("../images/workbench.png", height: 15%),
    caption: [Logo MySQL Workbench]
) <logo_mysql_workbench>

MySQL Workbench @workbench (@logo_mysql_workbench) è lo strumento ufficiale di amministrazione e sviluppo per MySQL sviluppato da Oracle. Offre un'interfaccia grafica intuitiva per la gestione dei database, consentendo agli sviluppatori e agli amministratori di eseguire operazioni come la progettazione dello schema del database, la scrittura e l'esecuzione di query SQL, la gestione degli utenti e dei permessi, nonché il monitoraggio delle prestazioni del server MySQL.

#v(1em)
/ Motivazioni della scelta:

L'adozione di MySQL Workbench come strumento di gestione del database è stata motivata da diversi fattori chiave:
#v(0.5em)
- #text(weight: "bold")[Interfaccia grafica intuitiva:] Workbench permette di gestire il database attraverso un'interfaccia visuale user-friendly, semplificando operazioni complesse come la progettazione dello #gl("schema-er"), la creazione e modifica di tabelle, l'esecuzione di query e la visualizzazione dei risultati. Questo risulta particolarmente utile durante lo sviluppo per verificare rapidamente la struttura dei dati e testare query.

- #text(weight: "bold")[Strumento ufficiale:] Essendo lo strumento ufficiale sviluppato da Oracle, MySQL Workbench garantisce piena compatibilità con tutte le funzionalità di MySQL. Questo assicura che tutte le operazioni eseguite tramite Workbench siano supportate e ottimizzate per il server MySQL.

== Strumenti di Sviluppo

=== Postman

#figure(
    image("../images/postman.png", height: 15%),
    caption: [Logo Postman]
) <logo_postman>

Postman @postman (@logo_postman) è una piattaforma completa per lo sviluppo e testing di API che consente di progettare, testare, documentare e monitorare interfacce REST atraverso un'interfaccia intuitiva. E' diventato lo standard de facto per il testing di API grazie alla sua semplicità d'uso e alle sue funzionalità avanzate.

#v(1em)
/ Motivazioni della scelta:

Postman è stato scelto come strumento principale per il testing delle API sviluppate nel progetto per diverse ragioni:
#v(0.5em)
- #text(weight: "bold")[Testing efficiente delle API:] Durante lo sviluppo del backend basato su API REST, era fondamentale poter testare rapidamente gli endpoint senza dover sviluppare prima il frontend. Postman permette di inviare richieste HTTP (GET, POST, PUT, DELETE) con parametri personalizzati, headers e body in formato #gl("json"), visualizzando immediatamente le risposte del server. Questo ha accelerato significativamente il ciclo di sviluppo e debug.

- #text(weight: "bold")[Gestione delle collections:] Postman consente di organizzare le richieste API in collezioni, facilitando la gestione e il riutilizzo dei test. Durante lo sviluppo, sono state create collezioni specifiche per ogni risorsa API, permettendo di eseguire test ripetitivi in modo strutturato.

- #text(weight: "bold")[Debugging efficiente:] La visualizzazione dettagliata delle risposte, inclusi status code, headers, body e tempi di risposta, facilita l'identificazione rapida di problemi e l'ottimizzazione delle performance delle API.

=== Suite JetBrains: IntelliJ IDEA e WebStorm

#figure(
    image("../images/suite_jetbrains.png", height: 15%),
    caption: [Logo JetBrains, IntelliJ IDEA e WebStorm]
) <logo_jetbrains>

JetBrains @jetbrains (@logo_jetbrains) offre una suite di #gl("ide") professionali specifici per linguaggi e tecnologie. IntelliJ IDEA è ottimizzato per lo sviluppo Java, ma supporta anche JavaScript e Node.js tramite plugin. WebStorm è un IDE specializzato per lo sviluppo web front-end e back-end con supporto nativo per HTML, CSS e JavaScript.

#v(1em)
/ Motivazioni della scelta:

L'adozione degli IDE JetBrains per lo sviluppo del progetto è stata motivata da diversi vantaggi chiave:
#v(0.5em)
- #text(weight: "bold")[Intelligent code completion:] Gli IDE JetBrains offrono funzionalità avanzate di completamento del codice basate su analisi statica, che accelerano la scrittura del codice riducendo gli errori di sintassi e migliorando la produttività degli sviluppatori.

- #text(weight: "bold")[Refactoring avanzato:] Le potenti funzionalità di refactoring consentono di ristrutturare il codice in modo sicuro e efficiente, facilitando la manutenzione e l'evoluzione del progetto nel tempo.

- #text(weight: "bold")[Integrazione con strumenti:] Integrazione nativa con Git per il version control, npm per la gestione dei pacchetti, terminale integrato e supporto per l'esecuzione diretta di script Node.js. Questo centralizza il workflow di sviluppo in un'unica applicazione, evitando il continuo cambio di contesto tra diversi strumenti.

- #text(weight: "bold")[Specializzazione per contesto:] Utilizzare IntelliJ IDEA per il backend Node.js e WebStorm per il frontend web garantisce strumenti ottimizzati per ciascun stack tecnologico, con funzionalità, suggerimenti e plugin specifici per il tipo di sviluppo in corso.

- #text(weight: "bold")[Licenza accademica gratuita:] Come studente universitario, è possibile ottenere gratuitamente licenze educational per tutti i prodotti JetBrains, rendendo accessibile questa suite professionale senza costi aggiuntivi. Questo ha permesso di utilizzare strumenti di qualità enterprise durante lo sviluppo del progetto.

== Versionamento del Codice

=== Git e GitHub

#figure(
    image("../images/git_github.png", height: 15%),
    caption: [Logo Git e GitHub]
) <logo_git_github>

Git @git (@logo_git_github) è un sistema di controllo versione distribuito che traccia le modifiche al codice sorgente durante lo sviluppo software. GitHub è una piattaforma di hosting per #gl("repository") Git basata su cloud che aggiunge funzionalità collaborative, gestione progetti e strumenti di integrazione continua.

#v(1em)
/ Motivazioni della scelta:

Git e GitHub sono stati scelti come strumenti di versionamento del codice per diverse ragioni fondamentali:
#v(0.5em)
- #text(weight: "bold")[Standard de facto:] Git è lo standard industriale per il version control, adottato dalla maggioranza dei progetti software moderni. La sua conoscenza è fondamentale per qualsiasi sviluppatore e la sua adozione garantisce compatibilità con praticamente qualsiasi workflow aziendale.

- #text(weight: "bold")[Tracciamento completo delle modifiche:] Ogni commit mantiene uno snapshot completo del progetto con metadata dettagliati (autore, data, messaggio descrittivo). Questo permette di ripercorrere l'intera evoluzione del software, comprendere le motivazioni dietro ogni modifica e identificare quando e dove sono stati introdotti eventuali bug.

- #text(weight: "bold")[Branching e sviluppo parallelo:] Il modello di branching di Git permette di lavorare su nuove funzionalità o correzioni in branch isolati senza interferire con il codice principale (branch main/master). Questo consente di sperimentare in sicurezza e di mantenere sempre una versione stabile del codice pronta per il deployment.

- #text(weight: "bold")[Backup distribuito:] La natura distribuita di Git garantisce che ogni clone del repository sia un backup completo della storia del progetto. Questo previene perdite di dati e permette di continuare a lavorare anche offline, sincronizzando le modifiche successivamente.

== Documentazione

=== Typst

#figure(
    image("../images/typst.png", height: 15%),
    caption: [Logo Typst]
) <logo_typst>

Typst @typst (@logo_typst) è un sistema di typesetting moderno, progettato come alternativa contemporanea a #gl("latex"). Utilizza una sintassi più intuitiva e leggera, tempi di compilazione significativamente più rapidi e un'architettura pensata per semplificare la creazione di documenti tecnici di alta qualità tipografica.

#v(1em)
/ Motivazioni della scelta:

Typst è stato scelto come strumento di documentazione per il progetto per diverse ragioni chiave:
#v(0.5em)
- #text(weight: "bold")[Sintassi intuitiva:] La sintassi di Typst è progettata per essere più leggibile e facile da imparare rispetto a LaTeX. Questo ha permesso di concentrarsi maggiormente sul contenuto del documento piuttosto che sulla complessità della formattazione, accelerando il processo di scrittura.

- #text(weight: "bold")[Compilazione rapida:] Typst offre tempi di compilazione molto più veloci rispetto a LaTeX, consentendo di vedere rapidamente le modifiche apportate al documento. Questo consente un workflow iterativo più fluido con preview istantaneo delle modifiche, facilitando la correzione di errori di formattazione e l'aggiustamento del layout in tempo reale.

- #text(weight: "bold")[Facilità di apprendimento:] Per chi non ha esperienza pregressa con LaTeX, Typst risulta molto più accessibile e immediato da utilizzare. La documentazione è chiara e moderna, con esempi pratici che permettono di iniziare a produrre documenti professionali rapidamente.

== Containerizzazione

=== Docker

#figure(
    image("../images/docker.png", height: 15%),
    caption: [Logo Docker]
) <logo_docker>

Docker @docker (@logo_docker) è una piattaforma di containerizzazione che permette di pacchettizzare applicazioni con tutte le loro dipendenze in container isolati e portabili. I container sono ambienti di esecuzione leggeri e autosufficienti che garantiscono che l'applicazione funzioni allo stesso modo su qualsiasi sistema che supporti Docker.

#v(1em)
/ Motivazioni della scelta:

L'adozione di Docker per il progetto è stata motivata da diversi vantaggi significativi offerti dalla containerizzazione:
#v(0.5em)
- #text(weight: "bold")[Ambiente consistente e riproducibile:] Docker elimina il classico problema del "funziona sulla mia macchina" garantendo che l'applicazione giri esattamente allo stesso modo in sviluppo, test e produzione.
- #text(weight: "bold")[Isolamento delle dipendenze:] Ogni componente dell'applicazione (backend Node.js, database MySQL, eventuali servizi aggiuntivi) può essere containerizzato separatamente con le proprie dipendenze specifiche, evitando conflitti tra versioni di librerie e semplificando la gestione complessiva del sistema.

- #text(weight: "bold")[Deployment semplificato:] Un'immagine Docker contiene tutto il necessario per eseguire l'applicazione: codice, runtime, librerie di sistema e configurazioni. Questo rende il processo di deployment consistente, ripetibile e molto più semplice rispetto all'installazione manuale di tutte le dipendenze su ogni macchina.

- #text(weight: "bold")[Facilitazione dello sviluppo:] Docker Compose permette di orchestrare facilmente servizi multipli (backend + database) con una semplice configurazione YAML, semplificando il setup dell'ambiente di sviluppo locale. Nuovi sviluppatori possono avviare l'intero stack con un singolo comando.