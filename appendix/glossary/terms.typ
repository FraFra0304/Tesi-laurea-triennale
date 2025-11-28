#let glossary-terms = (
  (
    key: "pabx",
    short: [PABX],
    long: [Private Automatic Branch Exchange],
    description: [Sistema telefonico privato che gestisce automaticamente le chiamate all'interno di un'organizzazione e le connessioni con la rete telefonica pubblica. Permette funzionalità avanzate come trasferimento chiamate, segreteria telefonica, code di attesa e instradamento intelligente.]
),
(
    key: "ring-group",
    short: [Ring Group],
    description: [Configurazione di un centralino telefonico che permette di far squillare contemporaneamente o in sequenza più interni telefonici quando viene ricevuta una chiamata su un determinato numero. Utilizzato tipicamente per distribuire le chiamate tra operatori di un reparto o servizio.]
),
(
    key: "did",
    short: [DID],
    long: [Direct Inward Dialing],
    description: [Servizio telefonico che consente di assegnare numeri telefonici individuali a ciascun interno di un centralino PABX, permettendo alle chiamate esterne di raggiungere direttamente un utente specifico senza passare attraverso un operatore o un menu vocale.]
),
(
    key: "mvp",
    short: [MVP],
    long: [Minimum Viable Product],
    description: [Versione di un prodotto con funzionalità sufficienti a soddisfare i primi utilizzatori e raccogliere feedback per lo sviluppo futuro. L'approccio MVP permette di validare ipotesi di mercato con il minimo investimento di risorse, iterando rapidamente sulla base dei riscontri ricevuti.]
),
(
    key: "api",
    short: [API],
    long: [Application Programming Interface],
    description: [Insieme di definizioni, protocolli e strumenti che permettono a diverse applicazioni software di comunicare tra loro. Le API definiscono le modalità con cui i componenti software devono interagire, specificando le operazioni disponibili, i parametri richiesti e i formati di risposta.]
),
(
    key: "schema-er",
    short: [Schema ER],
    long: [Schema Entità-Relazione],
    description: [Modello concettuale utilizzato nella progettazione di basi di dati per rappresentare graficamente le entità coinvolte, i loro attributi e le relazioni che intercorrono tra esse. Costituisce uno strumento fondamentale nella fase di analisi e progettazione di un database relazionale.]
),
(
    key: "ide",
    short: [IDE],
    long: [Integrated Development Environment],
    description: [Ambiente di sviluppo integrato che fornisce agli sviluppatori strumenti completi per la scrittura del codice. Tipicamente include editor di codice con syntax highlighting, compilatore o interprete, debugger, e funzionalità di autocompletamento e refactoring.]
),
(
    key: "repository",
    short: [Repository],
    description: [Archivio centralizzato dove viene memorizzato e gestito il codice sorgente di un progetto software. Nei sistemi di controllo versione come Git, il repository mantiene l'intera cronologia delle modifiche, permettendo collaborazione tra sviluppatori, tracciamento delle modifiche e ripristino di versioni precedenti.]
),
(
    key: "latex",
    short: [LaTeX],
    description: [Sistema di composizione tipografica basato sul linguaggio TeX, ampiamente utilizzato in ambito accademico e scientifico per la produzione di documenti di alta qualità. Permette la gestione automatica di riferimenti incrociati, bibliografie, formule matematiche e formattazione complessa.]
),
(
    key: "framework",
    short: [Framework],
    description: [Struttura software riutilizzabile che fornisce funzionalità generiche, architettura di base e convenzioni per lo sviluppo di applicazioni. A differenza delle librerie, un framework impone un'inversione del controllo: è il framework stesso a chiamare il codice dello sviluppatore secondo pattern predefiniti.]
),
(
    key: "dbms",
    short: [DBMS],
    long: [Database Management System],
    description: [Sistema software progettato per la creazione, gestione e interrogazione di basi di dati. Fornisce funzionalità di definizione dello schema, manipolazione dei dati, controllo degli accessi, gestione delle transazioni e ottimizzazione delle query.]
),
(
    key: "acid",
    short: [ACID],
    long: [Atomicity, Consistency, Isolation, Durability],
    description: [Insieme di proprietà che garantiscono l'affidabilità delle transazioni in un database. Atomicità assicura che le operazioni siano eseguite completamente o per nulla; Consistenza mantiene il database in uno stato valido; Isolamento garantisce che transazioni concorrenti non interferiscano; Durabilità preserva i dati anche in caso di guasti.]
),
(
    key: "cdr",
    short: [CDR],
    long: [Call Detail Record],
    description: [Record contenente i metadati di una chiamata telefonica, inclusi numero chiamante, numero chiamato, data e ora di inizio, durata, esito della chiamata e canale utilizzato. I CDR costituiscono la base informativa per analisi statistiche, fatturazione e monitoraggio della qualità del servizio telefonico.]
),
(
    key: "jwt",
    short: [JWT],
    long: [JSON Web Token],
    description: [Standard aperto per la creazione di token di accesso che permettono la trasmissione sicura di informazioni tra parti come oggetto JSON. Utilizzato principalmente per l'autenticazione stateless, il token contiene claims verificabili tramite firma digitale, eliminando la necessità di memorizzare sessioni lato server.]
),
(
    key: "json",
    short: [JSON],
    long: [JavaScript Object Notation],
    description: [Formato leggero per lo scambio di dati, basato su un sottoinsieme della sintassi JavaScript. La sua semplicità, leggibilità e supporto nativo in numerosi linguaggi di programmazione lo hanno reso lo standard de facto per la comunicazione tra client e server nelle applicazioni web moderne.]
),
(
    key: "ivr",
    short: [IVR],
    long: [Interactive Voice Response],
    description: [Sistema telefonico automatizzato che interagisce con i chiamanti attraverso menu vocali preregistrati e riconoscimento dei toni DTMF. Permette agli utenti di navigare tra opzioni, ottenere informazioni o essere instradati verso l'operatore appropriato senza intervento umano.]
),
(
    key: "rbac",
    short: [RBAC],
    long: [Role-Based Access Control],
    description: [Modello di controllo degli accessi che assegna permessi agli utenti in base ai ruoli ricoperti all'interno dell'organizzazione. Anziché gestire autorizzazioni individuali per ogni utente, i permessi vengono associati a ruoli e gli utenti ereditano le autorizzazioni dei ruoli assegnati, semplificando l'amministrazione della sicurezza.]
),
(
    key: "cdn",
    short: [CDN],
    long: [Content Delivery Network],
    description: [Rete di server distribuiti geograficamente che collaborano per fornire contenuti web agli utenti con bassa latenza. I CDN memorizzano copie cache di risorse statiche in molteplici location, servendo le richieste dal server più vicino all'utente e riducendo i tempi di caricamento.]
),
(
    key: "spa",
    short: [SPA],
    long: [Single Page Application],
    description: [Architettura di applicazioni web in cui l'intera applicazione viene caricata in una singola pagina HTML. Le interazioni successive avvengono dinamicamente attraverso JavaScript che aggiorna il contenuto senza ricaricare la pagina, comunicando con il server tramite chiamate API asincrone per ottenere o inviare dati.]
)
)
