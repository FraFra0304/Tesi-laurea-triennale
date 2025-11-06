= Progettazione  del Sistema<cap:progettazione_del_sistema>
#text(style: "italic", [
    In questo capitolo viene descritta l'architettura del sistema sviluppato durante lo stage, illustrando le scelte progettuali, l'implementazione dei componenti e le problematiche affrontate. La trattazione parte da una visione generale dell'architettura per poi approfondire database, backend e frontend, concludendo con l'analisi delle principali difficoltà e soluzioni adottate.
])
#v(1em)



== Architettura generale del sistema

Il sistema adotta un'architettura three-tier, pattern consolidato che separa le responsabilità in tre tier (livelli) distinti: presentazione (frontend), applicazione (backend) e dati (database). Questa scelta risponde ai requisiti funzionali e non funzionali identificati in fase di analisi.

La separazione garantisce manutenibilità del codice: modifiche all'interfaccia non richiedono interventi sul backend o sul database, aspetto rilevante considerando la necessità aziendale di manutenibilità da parte di personale non coinvolto nello sviluppo iniziale. L'architettura facilita inoltre la scalabilità: ogni componente può essere ottimizzato, sostituito o replicato indipendentemente, adattando il sistema a carichi crescenti senza riprogettazione completa.

=== Tier presentazione

Il presentation tier consiste in un'applicazione web client-side sviluppata con tecnologie web standard HTML5, CSS3 e JavaScript ES6+. L'interfaccia è stata progettata seguendo principi di usabilità e accessibilità, rispondendo al requisito R-NQ-2 sulla utilizzabilità senza formazione specifica. Il design responsive permette utilizzo su dispositivi diversi (desktop, tablet, smartphone) tramite media queries CSS che adattano layout e dimensioni.

Il frontend comunica con il backend esclusivamente tramite API REST con pattern asincrono basato su Promise e async/await, garantendo reattività nell'esperienza utente. Le chiamate di rete non bloccano l'interfaccia: durante operazioni lunghe, indicatori visivi informano l'utente dello stato, e l'interfaccia resta responsiva permettendo navigazione ad altre sezioni. La scelta di non utilizzare framework frontend pesanti come React, Angular o Vue è stata dettata da considerazioni *pragmatiche*: accessibilità del codice per il team aziendale con competenze JavaScript basilari, riduzione della complessità del progetto evitando build tool complessi e gestione dipendenze pesanti, tempi di caricamento ottimizzati per l'utente finale, e manutenibilità a lungo termine senza dipendenza da evoluzioni rapide di framework esterni. 

Questa scelta non ha compromesso la qualità dell'interfaccia: adottando pattern moderni come componenti riutilizzabili e gestione stato centralizzata, è stato possibile sviluppare un'applicazione strutturata e manutenibile pur rimanendo su vanilla JavaScript.

=== Tier applicazione

L'application tier è implementato mediante server Node.js con API RESTful sviluppate usando il framework Express, soluzione consolidata nell'ecosistema JavaScript. Questo strato intermedio costituisce il nucleo elaborativo del sistema e gestisce tutte le operazioni di business logic. Le responsabilità principali includono autenticazione degli utenti tramite verifica credenziali e generazione token JWT, autorizzazione verificando permessi per operazioni richieste in base al ruolo utente, elaborazione delle richieste provenienti dal frontend con parsing e validazione parametri, aggregazione e trasformazione dei dati secondo necessità business (calcoli statistici, formattazioni, conversioni), gestione centralizzata degli errori con logging strutturato e risposte appropriate, e validazione approfondita degli input per prevenire attacchi injection e dati inconsistenti.

La decisione di adottare un'architettura API-first, dove il backend espone esclusivamente API REST senza occuparsi direttamente della presentazione, risponde al vincolo R-NV-1 e offre vantaggi strategici significativi. L'approccio facilita future integrazioni con altri sistemi aziendali: un eventuale sistema di reportistica automatica che genera PDF giornalieri, un'applicazione mobile nativa per iOS/Android, o un sistema di notifiche real-time, potrebbero tutti interfacciarsi con le stesse API utilizzate dal frontend web senza necessità di duplicare la logica applicativa. Questa architettura supporta anche pattern di sviluppo moderno come microfrontend, dove team diversi possono sviluppare porzioni indipendenti dell'interfaccia utilizzando le stesse API centrali. Durante lo sviluppo, la separazione netta ha permesso di definire prima le interfacce API e poi procedere parallelamente su frontend e backend, riducendo le dipendenze tra i componenti e consentendo cicli di testing indipendenti per ciascun layer.

=== Tier dati

Il data tier è rappresentato da un database relazionale MySQL 8.0, DBMS consolidato che offre robustezza, performance, supporto transazionale ACID, e ecosistema ricco di strumenti. Il database gestisce due categorie distinte di dati: dati operativi dell'applicazione includendo utenti, sessioni, configurazioni di sistema, personalizzazioni per utente, e log di sistema; e dati telefonici estratti dal centralino PABX con dettagli completi delle chiamate (CDR), informazioni su interni e gruppi, e statistiche pre-aggregate per query frequenti.

Una decisione progettuale fondamentale è stata mantenere una replica locale completa dei Call Detail Record anziché interrogare direttamente il database del centralino ad ogni richiesta utente. Questa architettura, sebbene introduca complessità con necessità di sincronizzazione periodica e gestione consistenza dati, offre vantaggi critici giustificanti la scelta. Le query complesse per calcolo statistiche (aggregazioni su migliaia di record, join multipli, calcoli su window functions) non impattano il sistema telefonico in produzione che rimane dedicato alla sua funzione primaria di gestione chiamate real-time. I tempi di risposta sono ottimizzati tramite creazione di indici specializzati per le query di reporting che non sarebbe possibile implementare sul database vendor-managed dove non sono stati forniti privilegi DDL. Il sistema rimane operativo anche in caso di temporanea indisponibilità del centralino per manutenzione o problemi di rete, garantendo continuità del servizio di reporting. È possibile implementare trasformazioni e arricchimenti dei dati senza modificare la sorgente: calcoli derivati, normalizzazioni, categorizzazioni possono essere applicati sui dati locali.

Il meccanismo di sincronizzazione è stato progettato per minimizzare l'impatto sul centralino e garantire consistenza. Le sincronizzazioni avvengono con frequenza configurabile (di default ogni giorno a mezzanotte, ma aumentabile fino a pochi minuti in caso di monitoraggio real-time). Il processo è incrementale: solo record nuovi o modificati vengono trasferiti, identificati confrontando timestamp. L'operazione è transazionale: commit avviene solo se l'intera sincronizzazione completa con successo, prevenendo stati parziali. Gestione robusta degli errori con retry automatico e alerting permette identificare rapidamente problematiche di connettività o configurazione.

=== Flusso di comunicazione tra i livelli

Il flusso di comunicazione tra i livelli segue uno schema ben definito che garantisce consistenza e tracciabilità. Quando un utente interagisce con l'interfaccia web (ad esempio selezionando un periodo temporale per visualizzare statistiche chiamate), viene innescata una sequenza di operazioni: il frontend costruisce una richiesta HTTP contenente i parametri di filtro serializzati in formato appropriato (query parameters per GET, JSON body per POST), allega il token JWT di autenticazione nell'header `Authorization: Bearer <token>`, e invia la richiesta tramite chiamata AJAX alla specifica route API.

Il backend riceve la richiesta e la elabora attraverso una pipeline di middleware: il middleware di logging registra la richiesta per auditing, il middleware di autenticazione verifica il token JWT decodificandolo e validando la firma con la chiave segreta, se il token è valido estrae le informazioni utente (ID, ruolo) e le allega all'oggetto request, il middleware di autorizzazione verifica se l'utente ha i permessi per l'operazione richiesta (es. solo admin possono gestire utenti), il middleware di validazione verifica che i parametri rispettino lo schema atteso.

Superati i middleware, la richiesta raggiunge il controller appropriato che: estrae i parametri validati dalla richiesta, determina quale operazione business deve essere eseguita, invoca uno o più metodi dei model con parametri appropriati, i model costruiscono le query SQL necessarie utilizzando il Query Builder per prevenire SQL injection, eseguono le query sul database MySQL ottenendo result set, elaborano e trasformano i risultati secondo le necessità business (aggregazioni, calcoli, join logici), e restituiscono i dati processati al controller.

Il controller riceve i dati dai model, costruisce la risposta HTTP appropriata con codice di stato semanticamente corretto (200 per successo, 201 per creazione, 400 per errori client, 500 per errori server), serializza i dati in formato JSON, e invia la risposta al frontend. Se si verifica un errore in qualsiasi punto della pipeline, il middleware di gestione errori lo intercetta e restituisce una risposta di errore strutturata al client con messaggio user-friendly.

Il frontend riceve la risposta, verifica il codice di stato HTTP, se la richiesta è riuscita deserializza il JSON e processa i dati ricevuti, aggiorna lo stato dell'applicazione con i nuovi dati, triggera il rendering dei componenti UI che dipendono da quei dati (grafici vengono generati con Chart.js, tabelle con DataTables, cards con componenti custom), e nasconde eventuali indicatori di loading mostrando i dati aggiornati. Se la risposta indica un errore, il frontend mostra un messaggio appropriato all'utente, differenziando tra errori correggibili (es. validazione) che suggeriscono azioni correttive, ed errori di sistema che suggeriscono di riprovare o contattare supporto.

== Progettazione del database

#figure(
    image("../images/database.png", width: 100%),
    caption: [Schema database MySQL con tabelle e relazioni principali.]
)

Il database MySQL si compone di sette tabelle con responsabilità ben definite.

#v(1em)

La tabella `cdr` (Call Detail Record) costituisce il nucleo informativo, replicando localmente la tabella del PABX. Memorizza il registro dettagliato delle chiamate: identificativi univoci (`uniqueid`, `linkedid`), timestamp di inizio (`calldate`) e fine, numeri chiamante (`src`) e chiamato (`dst`), durata conversazione (`billsec`) e durata totale chiamata (`duration`), stato finale (`disposition` con valori ANSWERED, NO ANSWER, BUSY, FAILED), tipo dispositivo utilizzato (`channel`, `dstchannel`), informazioni di routing (`context`, `exten`), e campi aggiuntivi per funzionalità avanzate del PABX.

La struttura riflette la complessità del dominio telefonico. I campi `channel` e `dstchannel` descrivono i canali di comunicazione utilizzati, permettendo di identificare la tecnologia (SIP, IAX2, DAHDI) e il dispositivo specifico coinvolto. Il campo `accountcode` può essere utilizzato per associare chiamate a specifici account o progetti per scopi di billing. La replica locale, sebbene richieda sincronizzazione, previene impatti su performance del centralino e permette indici ottimizzati per il reporting.

Un campo particolarmente rilevante è `linkedid`, che raggruppa chiamate logicamente correlate. Nel sistema telefonico, una singola "chiamata" dal punto di vista dell'utente può generare multiple entry nel CDR. Quando un cliente chiama un DID che attiva un ring group, si creano: una entry per la chiamata in ingresso al DID, una entry per ogni interno del ring group che viene fatto squillare (anche se non risponde), entry aggiuntive se la chiamata viene trasferita o messa in attesa, entry per interazioni con sistemi IVR o voicemail. Il `linkedid` permette di correlare tutte queste entry separate, ricostruendo il percorso completo della chiamata attraverso il sistema. Questa capacità è stata sfruttata per implementare la funzionalità di analisi dettagliata delle chiamate (requisito R-DF-2), che mostra all'utente tutti i passaggi di una chiamata complessa con timeline visuale e dettagli su ogni hop.

#v(1em)

La tabella `users` gestisce autenticazione e autorizzazione degli utenti. Memorizza username univoco utilizzato per il login, password hashata con bcrypt, ruolo utente (enum con valori 'superadmin', 'admin' e 'user') che determina i permessi, email per comunicazioni e recupero password, e flag per indicare account attivi/disabilitati. Il sistema di ruoli implementa un modello RBAC (Role-Based Access Control) semplificato ma efficace: gli amministratori possono gestire utenti (creare, modificare, eliminare), configurare impostazioni di sistema, e accedere a tutte le funzionalità, mentre gli utenti standard possono visualizzare dati secondo i loro filtri personalizzati, personalizzare le proprie dashboard, e accedere solo alle funzionalità di reporting. Questa separazione risponde al requisito R-OF-5 sulla gestione differenziata delle autorizzazioni e previene accessi non autorizzati a funzionalità sensibili.
* INSERIRE SUPERADMIN*

#v(1em)

La tabella `settings` memorizza configurazioni globali del sistema in formato chiave-valore, un pattern comune per impostazioni che possono evolvere nel tempo senza modifiche allo schema. Le configurazioni attualmente implementate includono: il nome dell'azienda (visualizzato nell'interfaccia utente), l'identificativo del server PABX utilizzato per recuperare i dati tramite API, il tenant ID per filtrare e prelevare dal database solo i dati della tenant correttamente, e l'intervallo di sincronizzazione automatica espresso in minuti. Queste impostazioni permettono flessibilità nella gestione del sistema senza necessità di interventi sul database o sul codice, rispondendo al requisito R-NQ-4 sulla facilità di configurazione. *CONTROLLARE*

#v(1em)

La tabella `sync_log` traccia cronologia delle sincronizzazioni con il PABX, un requisito fondamentale per monitoring e troubleshooting. Ogni sincronizzazione genera un record contenente timestamp inizio e fine operazione permettendo calcolo durata, numero di record importati dalla tabella CDR del centralino, numero di record effettivamente inseriti (può differire se alcuni record erano già presenti), e stato finale (success, partial_success, failed). Durante lo sviluppo e testing, questa tabella si è rivelata indispensabile per debugging del meccanismo di sincronizzazione.

* FINIRE TABELLE *

== Sicurezza nella progettazione

La sicurezza è stata considerata fin dalle prime fasi progettuali, seguendo principi defense in depth e least privilege.

=== Autenticazione e autorizzazione

L'autenticazione è basata su JWT con:
- Password hashate con bcrypt (salt factor 10, computazionalmente costoso per prevenire brute force)
- Token firmati con chiave segreta (HMAC-SHA256)
- Scadenza configurabile (default 24h, bilanciamento sicurezza/UX)
- Refresh token per estensione sessioni senza re-login frequenti

L'autorizzazione implementa RBAC con verifica permessi a livello middleware: ogni endpoint protetto verifica ruolo richiesto prima di eseguire operazione.

=== Protezione da attacchi comuni

*SQL Injection*: prevenuta tramite prepared statement con binding parametrico, mai concatenazione diretta di input utente in query

*XSS (Cross-Site Scripting)*: input utente sanitizzato prima del rendering, uso Content Security Policy header

*CSRF (Cross-Site Request Forgery)*: token CSRF per operazioni state-changing, verifica origin/referer header

*Validazione input*: schema validation stringente con Joi per ogni parametro, whitelist di valori ammissibili

*Rate limiting*: middleware per limitare numero richieste per IP su endpoint critici (es. login)

=== Gestione credenziali

Credenziali sensibili (database password, JWT secret, API keys) sono:
- Memorizzate in variabili ambiente, mai versionate
- Diverse per ogni ambiente (development, staging, production)
- Ruotate periodicamente secondo policy aziendale
- Accessibili solo a processi autorizzati con least privilege

== Considerazioni su scalabilità e performance

La progettazione considera requisiti di scalabilità futuri pur mantenendo semplicità appropriata per volumetrie attuali.

=== Scalabilità orizzontale

L'architettura stateless del backend (JWT anziché session server-side) permette scaling orizzontale: multiple istanze backend possono operare dietro load balancer senza necessità di session affinity o shared state.

Il frontend, essendo completamente client-side, scala naturalmente: può essere servito da CDN o web server statici replicati.

Il database rappresenta il potenziale collo di bottiglia: inizialmente deploy single-instance, ma architettura permette future implementazioni di read replicas per distribuire carico query analitiche.

=== Ottimizzazioni performance progettuali

*Query ottimizzate*: progettate per minimizzare join complessi, uso di viste materializzate per calcoli pesanti

*Indici database*: progettati analizzando query frequenti durante design, bilanciando performance lettura vs overhead scrittura

*Paginazione*: progettata a livello API con cursori per evitare offset pesanti su grandi dataset

=== Monitoring e observability

La progettazione include punti di osservabilità:
- Logging strutturato a livelli (debug, info, warning, error)
- Metriche temporali per ogni query database
- Trace ID propagato attraverso request pipeline per correlazione log
- Health check endpoint per monitoring esterno

Questi elementi facilitano identificazione proattiva di problemi performance e debugging in produzione.

/*
== Sviluppo del backend

Il backend è strutturato secondo pattern MVC (Model-View-Controller) adattato per API REST, dove i controller gestiscono richieste HTTP, i model astraggono l'accesso al database, e non esistono view tradizionali ma risposte JSON.

=== Architettura modulare

Il codice backend è organizzato in moduli con responsabilità ben definite seguendo il principio di Separation of Concerns. La cartella `routes` contiene i file che definiscono gli endpoint API, mappando combinazioni di URL e metodi HTTP a funzioni controller specifiche. Ogni risorsa principale (users, calls, stats, config) ha il proprio file di routes, facilitando navigazione del codice e manutenzione.

La cartella `controllers` contiene la business logic per ciascun endpoint. I controller sono funzioni async che ricevono oggetti request e response, estraggono parametri dalla richiesta, invocano i model appropriati per operazioni sul database, processano e trasformano i dati secondo necessità, costruiscono la risposta HTTP appropriata, e gestiscono errori delegando al middleware centralizzato. Ogni controller è focalizzato su un'operazione specifica, mantenendo funzioni concise e testabili.

La cartella `models` contiene le classi che incapsulano l'interazione con il database. Ogni model corrisponde a una o più tabelle correlate e fornisce metodi per operazioni CRUD (Create, Read, Update, Delete) e query complesse. Ad esempio, il `CallModel` include metodi come `getCallDetails(callId)`, `getCallsByPeriod(startDate, endDate, filters)`, `getHourlyStats(filters)`. I model astraggono completamente i dettagli SQL dai controller: un controller non costruisce mai query SQL direttamente, ma invoca metodi del model con parametri business-logic. Questo facilita modifiche allo schema database o migrazione a database diverso senza impattare i controller.

La cartella `middleware` contiene funzioni di elaborazione intermedia che operano tra ricezione richiesta e esecuzione controller. Middleware implementati includono `authenticate` che verifica token JWT ed estrae informazioni utente, `authorize(role)` che verifica permessi per operazioni specifiche, `validateRequest(schema)` che valida parametri contro schema Joi prevenendo dati malformati, `rateLimiter` che previene abusi limitando numero di richieste per IP, e `logger` che traccia tutte le richieste per auditing e debugging.

La cartella `utils` contiene funzioni di utilità riutilizzabili: parsing e formattazione date, conversioni tra formati, validazioni comuni, funzioni di hashing e crittografia. Queste utility evitano duplicazione di codice e centralizzano logica condivisa.

Questa organizzazione segue il principio Single Responsibility: ogni modulo ha un'unica ragione di cambiamento. Un cambiamento nei requisiti di autenticazione impatta solo i middleware di auth, un cambiamento nello schema database impatta solo i model, un cambiamento nei formati di risposta impatta solo i controller. Questa separazione facilita testing unitario (ogni componente è testabile isolatamente con mock delle dipendenze), debugging (problemi sono localizzabili rapidamente alla categoria appropriata), e onboarding di nuovi sviluppatori (la struttura chiara permette comprensione rapida dell'architettura).

=== Sistema di autenticazione

L'autenticazione è implementata tramite JSON Web Token (JWT), standard industriale per la gestione di sessioni in applicazioni distribuite. Al login, il server verifica le credenziali contro il database utilizzando bcrypt per il confronto sicuro degli hash. Se le credenziali sono valide, genera un JWT contenente user ID, username, ruolo e timestamp di emissione. Il token viene firmato con chiave segreta memorizzata in variabile ambiente (mai versionata nel codice), garantendo che solo il server possa generare token validi.

Il token viene restituito al client che lo memorizza in localStorage e lo include nell'header `Authorization` con schema Bearer di ogni richiesta successiva. Un middleware di autenticazione intercetta tutte le richieste alle rotte protette, verifica validità del token (non scaduto, firma corretta), decodifica le informazioni utente e le rende disponibili al controller attraverso l'oggetto request. Questo approccio stateless permette scalabilità orizzontale del backend senza necessità di shared session storage o sticky sessions nel load balancer.

I token hanno scadenza configurabile (default 24 ore) che bilancia sicurezza e user experience. Token troppo longevi aumentano la finestra di vulnerabilità in caso di compromissione, ma scadenze troppo brevi frustrerebbero gli utenti con continui re-login. Il sistema supporta refresh token per estendere sessioni senza re-login frequenti: al login vengono generati sia un access token (breve durata) che un refresh token (lunga durata), e quando l'access token scade il client può ottenerne uno nuovo presentando il refresh token valido. Questa architettura risponde al requisito R-NQ-3 sulla user experience minimizzando interruzioni del flusso di lavoro.

La gestione della sicurezza include ulteriori misure: i token sono marcati httpOnly quando possibile per prevenire accesso da JavaScript malevolo, il sistema implementa rate limiting sugli endpoint di autenticazione per mitigare attacchi brute force, e le password memorizzate nel database sono hashate con bcrypt con cost factor 10, bilanciando sicurezza e performance.

=== Query Builder dinamico

Una componente critica del backend è il Query Builder, sistema che costruisce query SQL dinamicamente basandosi su filtri utente. Questa necessità deriva dalla grande varietà di filtri applicabili: periodo temporale, interno specifico, gruppo, DID, direzione chiamata, durata minima/massima, esito. La combinazione di questi filtri genererebbe migliaia di query statiche, rendendo l'approccio impraticabile dal punto di vista della manutenibilità.

Il Query Builder implementa il pattern Builder, accumulando clausole WHERE in base ai filtri presenti nella richiesta. Il processo di costruzione segue uno schema preciso: inizializza la query base con le tabelle principali, itera sui filtri presenti nella richiesta, per ogni filtro attivo aggiunge la clausola WHERE appropriata usando prepared statement, gestisce le operazioni di join necessarie per filtri che coinvolgono tabelle correlate, costruisce le clausole di aggregazione e raggruppamento per le statistiche, e infine applica ordinamento e limitazioni per paginazione. Il risultato è una query ottimizzata che recupera solo i dati necessari.

Un aspetto critico è stato bilanciare flessibilità e sicurezza. Permettere costruzione arbitraria di query esporrebbe a SQL injection. La soluzione adottata include molteplici livelli di protezione: whitelist di filtri permessi con validazione stringente di ogni parametro contro tipo atteso e range ammissibile, uso sistematico di prepared statement con binding parametrico che separa completamente dati da struttura query, sanitizzazione di input utente rimuovendo caratteri potenzialmente pericolosi, e validazione semantica per prevenire combinazioni di filtri illogiche o potenzialmente problematiche. Ogni parametro ricevuto dal frontend viene verificato lato server indipendentemente dalla validazione client-side, seguendo il principio "never trust the client".

=== Gestione degli errori

La gestione errori implementa un middleware centralizzato che intercetta eccezioni da qualsiasi punto dell'applicazione, fornendo un punto unico di controllo per la gestione di situazioni anomale. Gli errori sono classificati in categorie con trattamento differenziato:

- **Errori di validazione** (400 Bad Request): input utente non conforme alle aspettative, parametri mancanti o malformati. Il sistema restituisce dettagli specifici su quale validazione è fallita per permettere correzione immediata.
- **Errori di autenticazione** (401 Unauthorized): token mancante, scaduto o invalido. Il client riceve istruzione di effettuare nuovo login.
- **Errori di autorizzazione** (403 Forbidden): utente autenticato ma senza permessi per l'operazione richiesta. Distingue chiaramente tra "non sei loggato" e "non hai i permessi".
- **Errori di risorsa non trovata** (404 Not Found): risorsa richiesta non esiste nel database. Utile per distinguere tra errore client e server.
- **Errori database** (500 Internal Server Error): problemi di connessione, violazioni vincoli integrità, timeout query. Loggati con priorità alta per intervento immediato.
- **Errori interni** (500 Internal Server Error): eccezioni non anticipate, bug nel codice. Loggati con stack trace completo per debugging.

Errori critici vengono loggati con stack trace completo, timestamp, contesto della richiesta (utente, endpoint, parametri), e identificativo univoco che può essere comunicato all'utente per reference nel supporto. L'utente riceve solo informazioni necessarie senza esposizione di dettagli implementativi che potrebbero rivelare vulnerabilità. Ad esempio, un errore di query SQL viene loggato completamente server-side ma l'utente riceve solo "Errore nell'elaborazione della richiesta" con codice di riferimento.

Il sistema di logging implementa diversi livelli di severità (DEBUG, INFO, WARNING, ERROR, CRITICAL) con output su file rotazionati giornalmente e, per errori critici, notifiche via email agli amministratori. Questa infrastruttura si è rivelata fondamentale per monitoring proattivo e troubleshooting rapido di problemi in produzione.

=== API e documentazione

Le API seguono i principi REST con rigore architetturale. L'uso dei metodi HTTP è semanticamente appropriato: GET per operazioni di sola lettura senza side-effect, POST per creazione di nuove risorse, PUT per aggiornamenti completi di risorse esistenti, PATCH per aggiornamenti parziali, e DELETE per rimozione. Le risorse sono identificate da URL gerarchici che riflettono le relazioni del dominio, ad esempio `/api/users/{userId}/extensions` per gli interni associati a un utente specifico.

Le risposte utilizzano codici HTTP semanticamente corretti: 200 per operazioni riuscite, 201 per creazioni, 204 per operazioni senza contenuto di ritorno, 400 per errori di validazione, 401 per mancata autenticazione, 403 per mancata autorizzazione, 404 per risorse non trovate, 500 per errori server. Tutti i payload sono in formato JSON, con strutture consistenti che facilitano il parsing client-side. Gli errori seguono uno schema uniforme contenente codice errore, messaggio descrittivo e, quando applicabile, dettagli aggiuntivi per il debugging.

La documentazione API è stata sviluppata usando commenti inline in formato JSDoc e strumenti di generazione automatica, garantendo allineamento tra codice e documentazione. Include per ogni endpoint: URL completo con placeholder per parametri path, metodo HTTP, descrizione funzionalità, parametri richiesti e opzionali con tipo e descrizione, formato completo di request e response body con esempi, codici HTTP possibili con spiegazione, requisiti di autenticazione e autorizzazione, e esempi concreti di utilizzo con curl o JavaScript. Questa documentazione è stata essenziale per facilitare l'integrazione con il frontend e costituisce una risorsa fondamentale per futuri sviluppatori.

== Sviluppo del frontend

Il frontend implementa un'interfaccia single-page application (SPA) dove la navigazione non ricarica la pagina ma aggiorna dinamicamente il contenuto tramite JavaScript.

=== Architettura e organizzazione

Il codice frontend è organizzato in una struttura modulare che facilita manutenibilità e riutilizzo. I file HTML definiscono la struttura semantica delle pagine utilizzando elementi HTML5 appropriati (header, nav, main, section, article, footer). I file CSS implementano lo styling seguendo metodologia BEM (Block Element Modifier) per nominazione classi, garantendo specificità chiara e prevenendo conflitti. Le regole CSS sono organizzate in file tematici: `base.css` per reset e stili globali, `layout.css` per griglia e posizionamento, `components.css` per stili componenti riutilizzabili, `pages.css` per stili specifici di pagina, e `responsive.css` per media queries e adattamenti mobile.

I file JavaScript implementano la logica e interazione. La cartella `components` contiene moduli per componenti riutilizzabili dell'interfaccia. Ogni componente è implementato come modulo ES6 che esporta una funzione o classe. Ad esempio, il componente `DashboardCard` genera una card con titolo, valore, e icona opzionale; `DateRangePicker` fornisce interfaccia per selezione periodo temporale con validazione integrata; `ChartContainer` incapsula logica di creazione e aggiornamento grafici Chart.js. Questi componenti possono essere importati e utilizzati in contesti multipli, riducendo duplicazione.

La cartella `services` contiene moduli per comunicazione con backend. Ogni servizio è un modulo che esporta funzioni async per operazioni specifiche. Il `CallService` include operazioni relative alle chiamate (getCallList, getCallDetails, getLinkedCalls), lo `StatsService` operazioni per statistiche (getHourlyStats, getDailyStats, getExtensionStats), e così via. Questa organizzazione separa nettamente logica di comunicazione da logica di presentazione.

La cartella `utils` contiene funzioni di utilità JavaScript: formattazione date per visualizzazione, conversioni valute e numeri, validazione input lato client, gestione localStorage per preferenze utente, e utility per manipolazione DOM. Centralizzare queste utility previene duplicazione e semplifica manutenzione.

L'approccio component-based, sebbene senza framework formale come React, struttura il codice in unità modulari che incapsulano markup, stile e logica correlati. Ogni componente è responsabile di una porzione specifica dell'interfaccia e può essere sviluppato, testato e debuggato indipendentemente. Quando requisiti cambiano, le modifiche sono spesso localizzate a componenti specifici senza impatto su altre parti del sistema.

=== Sistema di routing client-side

Per implementare la navigazione SPA mantenendo funzionalità browser standard (back/forward, bookmarking) è stato sviluppato un router client-side che sfrutta la History API. Il router intercetta click sui link interni tramite event delegation, previene il comportamento default di reload della pagina, estrae il path di destinazione, aggiorna l'URL nel browser tramite `history.pushState()` senza causare reload, determina quale componente deve essere renderizzato in base al path, carica il componente appropriato eventualmente recuperando dati dall'API, e aggiorna il contenuto del DOM sostituendo solo la parte necessaria.

Il sistema gestisce anche la navigazione tramite pulsanti back/forward del browser ascoltando l'evento `popstate`, che viene emesso quando l'utente naviga nello storico. In risposta a questo evento, il router determina il componente corretto da mostrare in base all'URL corrente e aggiorna la UI di conseguenza. Questa implementazione garantisce un'esperienza utente fluida e coerente con le aspettative degli utenti web moderni.

Il routing supporta path parametrici (es. `/call/:callId`) dove `:callId` è un placeholder estratto dinamicamente e passato al componente, permettendo pagine di dettaglio senza duplicazione di codice. Include anche gestione di query parameters per filtri e stato che devono essere preservati nell'URL (es. `/dashboard?from=2024-01-01&to=2024-01-31`), facilitando bookmarking e condivisione di viste specifiche.

=== Comunicazione con il backend

La comunicazione con il backend utilizza la Fetch API, interfaccia moderna per richieste HTTP asincrone che ha sostituito XMLHttpRequest negli sviluppi recenti. Un service layer astrae le chiamate API esponendo funzioni JavaScript semantiche che incapsulano la complessità della comunicazione di rete.

Ogni servizio (es. `CallService`, `UserService`, `StatsService`) espone metodi corrispondenti alle operazioni business (es. `getCallDetails(callId)`, `getUserExtensions(userId)`, `getHourlyStats(filters)`). Internamente, questi metodi costruiscono le richieste HTTP appropriate includendo: URL completo con path parameters interpolati, metodo HTTP corretto, header necessari (Content-Type, Authorization), e body della richiesta serializzato in JSON quando necessario.

Il service layer gestisce automaticamente l'autenticazione inserendo il token JWT recuperato da localStorage nell'header `Authorization` di ogni richiesta. Gestisce anche il parsing delle risposte: verifica il codice di stato HTTP, deserializza il JSON della risposta, e in caso di errore lancia eccezioni tipizzate che i componenti possono intercettare e gestire appropriatamente.

Un aspetto importante è la gestione dello stato di caricamento. Ogni chiamata al service layer può opzionalmente aggiornare uno stato globale di loading, permettendo alla UI di mostrare indicatori di progresso consistenti. Il pattern utilizzato è:
```javascript
async fetchData() {
  setLoading(true);
  try {
    const data = await CallService.getCallDetails(callId);
    this.setState({ data });
  } catch (error) {
    this.handleError(error);
  } finally {
    setLoading(false);
  }
}
```

Questa astrazione separa completamente la logica di presentazione dalla comunicazione di rete. Se gli endpoint API cambiano o se si decide di migrare a un protocollo diverso (es. GraphQL), le modifiche sono confinate al service layer senza impattare i componenti UI. Durante lo sviluppo, questo approccio ha facilitato anche il testing: i componenti potevano essere testati mockando il service layer senza necessità di server backend attivo.

=== Librerie per visualizzazione dati

Per la visualizzazione dei dati sono state adottate librerie specializzate che accelerano lo sviluppo mantenendo alta qualità.

Chart.js è stata scelta per i grafici per diverse ragioni: supporta tutte le tipologie necessarie (linee, barre, torta, doughnut), offre API chiara e ben documentata, garantisce buone performance anche con dataset moderatamente grandi, permette ampia personalizzazione di colori, label, tooltip e interattività, e ha una community attiva con plugin disponibili. I grafici implementati includono grafici a linee per trend temporali (volumi chiamate, durate medie), grafici a barre per distribuzioni (chiamate per interno, per direzione), grafici a torta per composizioni percentuali (distribuzione per esito, per tipo chiamata), e grafici combinati con assi multipli per correlazioni complesse.

DataTables è stata adottata per le tabelle complesse, fornendo out-of-the-box: sorting multi-colonna con indicatori visivi, filtering full-text e per-colonna, paginazione con configurazione dimensione pagina, export in formati multipli (CSV, Excel, PDF), responsive design con priority columns, e API per integrazione programmatica. La libreria richiede jQuery come dipendenza, inizialmente considerato un limite dato il trend verso vanilla JavaScript. Tuttavia, i benefici in termini di funzionalità e stabilità hanno superato le perplessità, e jQuery è stato incluso minimizzando il suo uso al di fuori di DataTables per evitare dipendenza diffusa.

Entrambe le librerie sono mature (versioni stabili oltre 1.0), ampiamente adottate (milioni di download npm), ben documentate (con tutorial ed esempi estensivi), e attivamente mantenute (aggiornamenti regolari per bug fix e feature). Questa stabilità riduce il rischio di obsolescenza a breve termine e garantisce disponibilità di supporto community. La decisione di utilizzarle anziché implementare funzionalità equivalenti da zero ha risparmiato settimane di sviluppo e testing, permettendo di concentrare gli sforzi sulle funzionalità business-specific del sistema.

=== Gestione dello stato

Senza framework con gestione stato integrata, è stato implementato un pattern Observer semplificato. Un oggetto globale `AppState` mantiene lo stato dell'applicazione includendo informazioni sull'utente autenticato (ID, username, ruolo), filtri attivi nelle varie dashboard (periodo temporale, interni selezionati, gruppi), dati caricati dall'API (statistiche, liste chiamate), e stato UI (modali aperti, loading states).

I componenti possono sottoscriversi a cambiamenti specifici dello stato tramite metodo `subscribe` che accetta un path nello stato e una callback. Quando lo stato viene modificato tramite metodo `setState`, il sistema determina quali subscription sono affette e invoca le relative callback. Questo approccio event-driven permette ai componenti di reagire a cambiamenti di stato pertinenti aggiornando la UI in modo reattivo.

L'implementazione centralizza lo stato prevenendo inconsistenze: non esistono copie multiple della stessa informazione sparse nel codice. Facilita inoltre il debugging: tracciando tutte le modifiche allo stato in un unico punto attraverso logging strutturato, è possibile ricostruire completamente la sequenza di eventi che ha portato a un particolare stato dell'applicazione. Durante lo sviluppo, questa capacità si è rivelata preziosa per identificare e correggere bug complessi legati a race condition o aggiornamenti UI inconsistenti.

== Problematiche affrontate e soluzioni implementate

=== Gestione dell'asincronicità

La natura asincrona di JavaScript e delle chiamate di rete ha richiesto particolare attenzione nella progettazione del frontend. Le Promise e async/await sono stati adottati sistematicamente per gestire operazioni asincrone in modo leggibile e manutenibile, evitando il "callback hell" che caratterizza codice JavaScript più datato.

Sono stati implementati loading states espliciti che informano l'utente durante operazioni lunghe attraverso spinner, progress bar o messaggi di stato. Questo feedback visivo è cruciale per la user experience, particolarmente quando si elaborano grandi volumi di dati che richiedono diversi secondi.

La gestione errori di rete include retry automatico con backoff esponenziale per richieste fallite a causa di problemi transitori (timeout, errori 5xx del server). Il sistema tenta fino a tre volte prima di presentare l'errore all'utente, con intervalli crescenti tra i tentativi. Sono stati implementati timeout configurabili per evitare attese indefinite: dopo 30 secondi senza risposta, la richiesta viene cancellata e l'utente informato del problema.

Un pattern ricorrente è stato il race condition management. Quando l'utente cambia rapidamente i filtri in una dashboard, vengono emesse richieste multiple che possono completare in ordine diverso da quello di emissione. Se non gestita, questa situazione porta a visualizzare dati non corrispondenti ai filtri correnti. La soluzione implementata utilizza un sistema di request cancellation: ogni volta che viene emessa una nuova richiesta per una risorsa specifica, le richieste pendenti per quella risorsa vengono cancellate tramite AbortController. Questo garantisce che solo i risultati dell'ultima richiesta vengano visualizzati, mantenendo la coerenza tra UI e dati mostrati.

=== Visualizzazione di grandi dataset

L'applicazione deve gestire dataset potenzialmente enormi, con storico di chiamate che può estendersi per anni. La visualizzazione diretta di tali volumi di dati sarebbe impraticabile sia dal punto di vista delle performance che dell'usabilità: un grafico con decine di migliaia di punti sarebbe illeggibile e causerebbe rallentamenti significativi nel browser.

Per i grafici con range temporali estesi è stato implementato un sistema di campionamento automatico intelligente. Il backend determina la granularità appropriata in base all'ampiezza del range temporale richiesto: per range di poche ore, i dati vengono aggregati in bucket di 5 minuti; per giorni, bucket orari; per settimane o mesi, bucket giornalieri; per anni, bucket mensili. Il numero di punti nel grafico rimane quindi entro limiti gestibili (tipicamente sotto i 300 punti) indipendentemente dall'ampiezza del periodo, mantenendo leggibilità e performance ottimali. Questo approccio adattivo bilancia dettaglio e usabilità.

Per le tabelle con elenchi dettagliati delle chiamate è stata implementata paginazione server-side. Il frontend richiede una pagina specifica di risultati (default 50 righe) e il backend restituisce solo quella porzione, insieme al conteggio totale per calcolare il numero di pagine. Controlli di usabilità avvisano l'utente quando un filtro produce un numero eccessivo di risultati (oltre 10.000), suggerendo di raffinare i parametri pur permettendo di procedere se esplicitamente desiderato. Questo previene situazioni dove l'utente attende lunghi caricamenti per poi trovarsi di fronte a migliaia di righe difficili da analizzare.

=== Ottimizzazione delle performance

Le performance sono state preoccupazione costante durante lo sviluppo, rispondendo al requisito R-NQ-1 che specifica tempi di risposta rapidi anche con volumi elevati di dati.

Per le query database, l'approccio è stato sviluppare prima query funzionalmente corrette, poi identificare colli di bottiglia tramite profiling. Il backend è stato strumentato per registrare tempo di esecuzione di ogni query, generando log strutturati analizzabili per identificare rapidamente query lente. Le query problematiche sono state analizzate con EXPLAIN di MySQL, che fornisce il piano di esecuzione scelto dall'ottimizzatore.

Un esempio concreto: una query per calcolare il volume totale di chiamate per interno in un mese impiegava inizialmente oltre 8 secondi con 500.000 record nella tabella CDR. L'analisi EXPLAIN rivelava un full table scan: il database scorreva sequenzialmente tutti i record verificando la condizione WHERE. La creazione di un indice composito su `(calldate, src, disposition)` ha ridotto il tempo a 0.3 secondi, miglioramento di 25x. L'indice permette al database di accedere direttamente ai record nel range temporale richiesto, filtrando poi efficientemente su src e disposition.

Altri indici creati includono indice su `linkedid` per query che ricostruiscono chiamate correlate (riduzione da 5s a 0.2s), indice su `dst` per statistiche per numero chiamato, e indici compositi su combinazioni frequenti di filtri (es. `(calldate, src, dst)` per analisi dettagliate tra interni specifici).

Gli indici migliorano drasticamente le query di lettura introducendo overhead sulle scritture. Nel contesto specifico, dove CDR viene aggiornata solo durante sincronizzazioni periodiche e le letture dominano largamente, il trade-off è favorevole. Un'analisi ha mostrato che gli indici rallentano le sincronizzazioni del 15%, ma migliorano le query di lettura del 10-30x. Le sincronizzazioni inseriscono dati in batch tramite transazioni, ammortizzando l'overhead degli indici su molti inserimenti consecutivi.

Altre ottimizzazioni hanno riguardato la riduzione del volume di dati trasferiti. Query iniziali usavano `SELECT *`, recuperando colonne mai utilizzate. Le query sono state raffinate per selezionare esplicitamente solo colonne necessarie. Per visualizzazioni grafiche, il backend calcola aggregazioni necessarie anziché trasferire dati grezzi. Un grafico di volume chiamate orario restituisce 24 valori aggregati anziché decine di migliaia di record individuali, riducendo payload da megabyte a kilobyte.

Le performance di rendering frontend hanno richiesto attenzioni diverse. È stato implementato un limite massimo di 500 punti per grafico: se l'aggregazione produce più punti, il backend reaggrega ulteriormente riducendo la granularità. Per le tabelle, la paginazione server-side garantisce rendering di massimo 100 righe contemporaneamente nel DOM, mantenendo browser reattivo anche con milioni di record totali.

=== Limitazioni nell'accesso ai dati

Una problematica ricorrente durante lo sviluppo è stata la limitazione nell'accesso ai dati del centralino PABX. Il vendor del sistema telefonico fornisce accesso solo alla tabella CDR e ad alcune API REST per configurazioni basilari (gestione utenti, instradamento chiamate), ma non permette accesso completo al database sottostante per ragioni di sicurezza, supporto e intellectual property. Questa politica, sebbene comprensibile dal punto di vista del vendor, ha imposto vincoli significativi sulle funzionalità implementabili.

Diverse funzionalità avanzate richieste o desiderate durante le sessioni di feedback con il tutor aziendale e il cliente finale si sono rivelate impossibili o estremamente difficili da implementare. Esempi concreti includono correlazione tra statistiche chiamate e ticket di supporto aperti da clienti, che avrebbe permesso analisi della relazione tra volumi chiamate e problematiche specifiche ma richiedeva accesso alla tabella tickets non disponibile; integrazione con dati CRM per arricchire le statistiche con informazioni su clienti e opportunità commerciali; analisi qualità audio delle chiamate basata su metriche tecniche (jitter, packet loss, MOS score) memorizzate in tabelle diagnostiche inaccessibili; correlazione automatica tra chiamate e registrazioni audio con possibilità di playback diretto dall'interfaccia web; e tracking dettagliato di trasferimenti e hold con tempi specifici per ogni stato.

La soluzione adottata è stata pragmatica e orientata al valore: concentrare lo sviluppo sulle funzionalità realizzabili con i dati disponibili, garantendo che queste funzionalità fossero implementate in modo eccellente piuttosto che tentare workaround fragili. In alcuni casi è stato possibile implementare funzionalità semplificate che, pur non offrendo tutte le informazioni desiderate, fornivano comunque valore. Ad esempio, sebbene non fosse possibile accedere direttamente alle registrazioni audio, è stato implementato un sistema che mostra se una chiamata è stata registrata e fornisce l'identificativo della registrazione, permettendo all'utente di recuperarla manualmente dal sistema PABX quando necessario.

Durante le discussioni con gli stakeholder, queste limitazioni sono state comunicate in modo trasparente e tempestivo. Quando una funzionalità veniva richiesta, l'approccio era analizzare i dati necessari per implementarla, verificare la loro disponibilità, e se non disponibili spiegare chiaramente la situazione. Questa comunicazione proattiva includeva dimostrazioni concrete: mostrare esattamente quali tabelle servirebbero, quali informazioni contengono, e perché il vendor non le espone. In molti casi, funzionalità inizialmente richieste sono state reingegnerizzate per utilizzare solo i dati disponibili fornendo comunque valore tangibile. Ad esempio, l'analisi della distribuzione geografica delle chiamate, inizialmente concepita per mostrare località precise dei chiamanti tramite dati non disponibili, è stata reimplementata usando i prefissi telefonici dei numeri chiamanti, informazione presente nei CDR, fornendo comunque insight utili sulla provenienza delle chiamate.

Questa esperienza ha evidenziato l'importanza della comunicazione trasparente e tempestiva dei vincoli tecnici agli stakeholder non tecnici. Quando le limitazioni venivano spiegate con esempi concreti e in linguaggio comprensibile, correlando richieste specifiche ai dati tecnici necessari e spiegando le ragioni di inaccessibilità, gli stakeholder hanno sempre compreso la situazione, apprezzato l'onestà, e collaborato attivamente alla riprioritizzazione. Questo dialogo aperto ha mantenuto aspettative realistiche, evitato frustrazioni e malintesi, e spesso stimolato creatività nell'identificare soluzioni alternative che, pur diverse dalle richieste originali, fornivano valore comparabile utilizzando i dati disponibili.



* sefsdfbsieufusebnuergbiuerg *
L'architettura rispetta pienamente i requisiti di vincolo identificati durante l'analisi dei requisiti. Il requisito R-NV-1, che impone la separazione netta tra frontend e backend tramite API RESTful per facilitare future integrazioni e manutenzione indipendente dei layer, è soddisfatto per costruzione dalla natura three-tier dell'architettura: ogni strato comunica con quello adiacente esclusivamente tramite interfacce ben definite (API HTTP per frontend-backend, query SQL per backend-database). 

Il requisito R-NV-2, che richiede l'accessibilità tramite browser web moderni senza installazioni locali o plugin, è garantito dall'implementazione completamente web-based del frontend: l'applicazione utilizza esclusivamente tecnologie web standard supportate nativamente da tutti i browser moderni (HTML5, CSS3, JavaScript ES6+), non richiede Java, Flash, o altri plugin deprecati, e funziona correttamente su Chrome, Firefox, Safari ed Edge senza necessità di configurazioni specifiche o installazioni client-side.

Il requisito R-NV-3, relativo alla possibilità di distribuzione in ambienti containerizzati per deployment semplificato e scalabilità, è facilitato dalla chiara separazione architetturale dei componenti. Ogni layer può essere pacchettizzato in un container Docker distinto: un container per il frontend (nginx serving static files), un container per il backend Node.js, un container per il database MySQL. I container possono essere orchestrati tramite Docker Compose per ambienti development/staging o Kubernetes per production, con configurazioni dichiarative che definiscono networking, volumi, scaling policy, e health checks. Questa architettura containerizzata supporta deployment rapidi, rollback immediati in caso di problemi, e scaling orizzontale selettivo (es. replicare solo backend se collo di bottiglia è elaborazione CPU).

Il requisito R-NV-4 sulla possibilità di future integrazioni con sistemi di autenticazione esterni (LDAP, Active Directory, OAuth, SAML) è stato considerato fin dalla progettazione iniziale implementando un sistema di autenticazione modulare. L'autenticazione è gestita tramite middleware dedicati facilmente sostituibili: attualmente il middleware implementa autenticazione locale con password hashate, ma l'interfaccia è astratta in modo che possa essere sostituito con middleware LDAP o OAuth senza modifiche ai controller o alla logica business. Questa preveggenza riduce significativamente l'effort necessario per implementare SSO aziendale se richiesto in futuro.*/