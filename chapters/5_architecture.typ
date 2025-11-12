#pagebreak(to:"odd")

= Architettura<cap:architettura>
#text(style: "italic", [
    In questo capitolo viene descritta l'architettura del sistema sviluppato durante lo stage, illustrando le scelte progettuali, l'implementazione dei componenti e le problematiche affrontate. La trattazione parte da una visione generale dell'architettura per poi approfondire database, backend e frontend, concludendo con l'analisi delle principali difficoltà e soluzioni adottate.
])
#v(1em)



== Architettura generale del sistema

Il sistema adotta un'architettura three-tier, pattern consolidato che separa le responsabilità in tre tier (livelli) distinti: presentazione (frontend), applicazione (backend) e dati (database). Questa scelta risponde ai requisiti funzionali e non funzionali identificati in fase di analisi.

La separazione garantisce manutenibilità del codice: modifiche all'interfaccia non richiedono interventi sul backend o sul database, aspetto rilevante considerando la necessità aziendale di manutenibilità da parte di personale non coinvolto nello sviluppo iniziale. L'architettura facilita inoltre la scalabilità: ogni componente può essere ottimizzato, sostituito o replicato indipendentemente, adattando il sistema a carichi crescenti senza riprogettazione completa.

=== Tier presentazione

Il presentation tier consiste in un'applicazione web client-side sviluppata con tecnologie web standard HTML5, CSS3 e JavaScript ES6+. L'interfaccia è stata progettata seguendo principi di usabilità e accessibilità, rispondendo al requisito #link(<r-nq-2>)[R-NQ-2] sulla utilizzabilità senza formazione specifica. Il design responsive permette utilizzo su dispositivi diversi (desktop, tablet, smartphone) tramite media queries CSS che adattano layout e dimensioni.

Il frontend comunica con il backend esclusivamente tramite API REST con pattern asincrono basato su Promise e async/await, garantendo reattività nell'esperienza utente. Le chiamate di rete non bloccano l'interfaccia: durante operazioni lunghe, indicatori visivi informano l'utente dello stato, e l'interfaccia resta responsiva permettendo navigazione ad altre sezioni. La scelta di non utilizzare framework frontend pesanti come React, Angular o Vue è stata dettata da considerazioni pragmatiche: accessibilità del codice per il team aziendale con competenze JavaScript basilari, riduzione della complessità del progetto evitando build tool complessi e gestione dipendenze pesanti, tempi di caricamento ottimizzati per l'utente finale, e manutenibilità a lungo termine senza dipendenza da evoluzioni rapide di framework esterni. 

Questa scelta non ha compromesso la qualità dell'interfaccia: adottando pattern moderni come componenti riutilizzabili e gestione stato centralizzata, è stato possibile sviluppare un'applicazione strutturata e manutenibile pur rimanendo su vanilla JavaScript.

=== Tier applicazione

L'application tier è implementato mediante server Node.js con API RESTful sviluppate usando il framework Express, soluzione consolidata nell'ecosistema JavaScript. Questo strato intermedio costituisce il nucleo elaborativo del sistema e gestisce tutte le operazioni di business logic. Le responsabilità principali includono autenticazione degli utenti tramite verifica credenziali e generazione token JWT, autorizzazione verificando permessi per operazioni richieste in base al ruolo utente, elaborazione delle richieste provenienti dal frontend con parsing e validazione parametri, aggregazione e trasformazione dei dati secondo necessità business (calcoli statistici, formattazioni, conversioni), gestione centralizzata degli errori con logging strutturato e risposte appropriate, e validazione approfondita degli input per prevenire attacchi injection e dati inconsistenti.
#v(0.5em)
La decisione di adottare un'architettura API-first, dove il backend espone esclusivamente API REST senza occuparsi direttamente della presentazione, risponde al vincolo #link(<r-nq-2>)[R-NV-1] e offre vantaggi strategici significativi. L'approccio facilita future integrazioni con altri sistemi aziendali: un eventuale sistema di reportistica automatica che genera PDF giornalieri, un'applicazione mobile nativa per iOS/Android, o un sistema di notifiche real-time, potrebbero tutti interfacciarsi con le stesse API utilizzate dal frontend web senza necessità di duplicare la logica applicativa. Questa architettura supporta anche pattern di sviluppo moderno come microfrontend, dove team diversi possono sviluppare porzioni indipendenti dell'interfaccia utilizzando le stesse API centrali. Durante lo sviluppo, la separazione netta ha permesso di definire prima le interfacce API e poi procedere parallelamente su frontend e backend, riducendo le dipendenze tra i componenti e consentendo cicli di testing indipendenti per ciascun layer.

=== Tier dati

Il data tier è rappresentato da un database relazionale MySQL 8.0, DBMS consolidato che offre robustezza, performance, supporto transazionale ACID, e ecosistema ricco di strumenti. Il database gestisce due categorie distinte di dati: dati operativi dell'applicazione includendo utenti, sessioni, configurazioni di sistema, personalizzazioni per utente, e log di sistema; e dati telefonici estratti dal centralino PABX con dettagli completi delle chiamate (CDR), informazioni su interni e gruppi, e statistiche pre-aggregate per query frequenti.
#v(0.5em)
Una decisione progettuale fondamentale è stata mantenere una replica locale completa dei Call Detail Record anziché interrogare direttamente il database del centralino ad ogni richiesta utente. Questa architettura, sebbene introduca complessità con necessità di sincronizzazione periodica e gestione consistenza dati, offre vantaggi critici giustificanti la scelta. Le query complesse per calcolo statistiche (aggregazioni su migliaia di record, join multipli, calcoli su window functions) non impattano il sistema telefonico in produzione che rimane dedicato alla sua funzione primaria di gestione chiamate real-time. I tempi di risposta sono ottimizzati tramite creazione di indici specializzati per le query di reporting che non sarebbe possibile implementare sul database vendor-managed dove non sono stati forniti privilegi DDL. Il sistema rimane operativo anche in caso di temporanea indisponibilità del centralino per manutenzione o problemi di rete, garantendo continuità del servizio di reporting. È possibile implementare trasformazioni e arricchimenti dei dati senza modificare la sorgente: calcoli derivati, normalizzazioni, categorizzazioni possono essere applicati sui dati locali.
#v(0.5em)
Il meccanismo di sincronizzazione è stato progettato per minimizzare l'impatto sul centralino e garantire consistenza. Le sincronizzazioni avvengono con frequenza configurabile (di default ogni giorno a mezzanotte, ma aumentabile fino a pochi minuti in caso di monitoraggio real-time). Il processo è incrementale: solo record nuovi o modificati vengono trasferiti, identificati confrontando timestamp. L'operazione è transazionale: commit avviene solo se l'intera sincronizzazione completa con successo, prevenendo stati parziali. Gestione robusta degli errori con retry automatico e alerting permette identificare rapidamente problematiche di connettività o configurazione.

=== Flusso di comunicazione tra i livelli

Il flusso di comunicazione tra i livelli segue uno schema ben definito che garantisce consistenza e tracciabilità. Quando un utente interagisce con l'interfaccia web (ad esempio selezionando un periodo temporale per visualizzare statistiche chiamate), viene innescata una sequenza di operazioni: il frontend costruisce una richiesta HTTP contenente i parametri di filtro serializzati in formato appropriato (query parameters per GET, JSON body per POST), allega il token JWT di autenticazione nell'header `Authorization: Bearer <token>`, e invia la richiesta tramite chiamata AJAX alla specifica route API.
#v(0.5em)
Il backend riceve la richiesta e la elabora attraverso una pipeline di middleware: il middleware di logging registra la richiesta per auditing, il middleware di autenticazione verifica il token JWT decodificandolo e validando la firma con la chiave segreta, se il token è valido estrae le informazioni utente (ID, ruolo) e le allega all'oggetto request, il middleware di autorizzazione verifica se l'utente ha i permessi per l'operazione richiesta (es. solo admin possono gestire utenti), il middleware di validazione verifica che i parametri rispettino lo schema atteso.
#v(0.5em)
Superati i middleware, la richiesta raggiunge il controller appropriato che: estrae i parametri validati dalla richiesta, determina quale operazione business deve essere eseguita, invoca uno o più metodi dei model con parametri appropriati, i model costruiscono le query SQL necessarie utilizzando il Query Builder per prevenire SQL injection, eseguono le query sul database MySQL ottenendo result set, elaborano e trasformano i risultati secondo le necessità business (aggregazioni, calcoli, join logici), e restituiscono i dati processati al controller.

Il controller riceve i dati dai model, costruisce la risposta HTTP appropriata con codice di stato semanticamente corretto (200 per successo, 201 per creazione, 400 per errori client, 500 per errori server), serializza i dati in formato JSON, e invia la risposta al frontend. Se si verifica un errore in qualsiasi punto della pipeline, il middleware di gestione errori lo intercetta e restituisce una risposta di errore strutturata al client con messaggio in linguaggio naturale interpretabile da utenti senza conoscenze tecniche.
#v(0.5em)
Il frontend riceve la risposta, verifica il codice di stato HTTP, se la richiesta è riuscita deserializza il JSON e processa i dati ricevuti, aggiorna lo stato dell'applicazione con i nuovi dati, triggera il rendering dei componenti UI che dipendono da quei dati (grafici vengono generati con Chart.js, tabelle con DataTables, cards con componenti custom), e nasconde eventuali indicatori di loading mostrando i dati aggiornati. Se la risposta indica un errore, il frontend mostra un messaggio appropriato all'utente, differenziando tra errori correggibili (es. validazione) che suggeriscono azioni correttive, ed errori di sistema che suggeriscono di riprovare o contattare supporto.

== Progettazione del database

#figure(
    image("../images/database.png", width: 100%),
    caption: [Schema database MySQL con tabelle e relazioni principali.]
)

Il database MySQL si compone di sette tabelle con responsabilità ben definite.

#v(1em)

La tabella `cdr` (Call Detail Record) costituisce il nucleo informativo, replicando localmente la tabella del PABX. Memorizza il registro dettagliato delle chiamate: identificativi univoci (`uniqueid`, `linkedid`), timestamp di inizio (`calldate`), numeri chiamante (`src`) e chiamato (`dst`), durata conversazione (`billsec`) e durata totale chiamata (`duration`), stato finale (`disposition` con valori ANSWERED, NO ANSWER, BUSY, FAILED), tipo dispositivo utilizzato (`channel`, `dstchannel`), informazioni di routing (`context`, `exten`), e campi aggiuntivi per funzionalità avanzate del PABX.

Un campo particolarmente rilevante è `linkedid`, che raggruppa chiamate logicamente correlate. Nel sistema telefonico, una singola "chiamata" dal punto di vista dell'utente può generare multiple entry nel CDR. Quando un cliente chiama un DID che attiva un ring group, si creano: una entry per la chiamata in ingresso al DID, una entry per ogni interno del ring group che viene fatto squillare (anche se non risponde), entry aggiuntive se la chiamata viene trasferita o messa in attesa, entry per interazioni con sistemi IVR o voicemail. Il `linkedid` permette di correlare tutte queste entry separate, ricostruendo il percorso completo della chiamata attraverso il sistema. Questa capacità è stata sfruttata per implementare la funzionalità di analisi dettagliata delle chiamate, che mostra all'utente tutti i passaggi di una chiamata complessa con timeline visuale e dettagli su ogni trasferimento.

#v(1em)

La tabella `users` gestisce autenticazione e autorizzazione degli utenti. Memorizza username univoco utilizzato per il login, password hashata con bcrypt, ruolo utente (enum con valori 'superadmin', 'admin' e 'user') che determina i permessi, email per comunicazioni e recupero password, e flag `authorized` per indicare account attivi o disabilitati. Il sistema di ruoli implementa un modello RBAC (Role-Based Access Control) semplificato ma efficace: gli amministratori possono gestire utenti (creare, modificare, eliminare), configurare impostazioni di sistema, e accedere a tutte le funzionalità, mentre gli utenti standard possono visualizzare dati secondo i loro filtri personalizzati, personalizzare le proprie dashboard, e accedere solo alle funzionalità di reporting.

#v(1em)

La tabella `ext` memorizza gli interni telefonici presenti nel centralino. Ogni record contiene il numero interno (`ext`), nome descrittivo dell'utente o del reparto, indirizzo email associato, e stato dell'interno. Questa tabella viene utilizzata per arricchire i report delle chiamate, mostrando nomi leggibili al posto dei soli numeri interni, e per implementare i filtri di visualizzazione basati sugli interni di interesse.

#v(1em)

La tabella `did` gestisce i numeri telefonici esterni (Direct Inward Dialing) attraverso cui i clienti possono contattare l'azienda. Contiene il numero DID (`numero`), tipologia del numero, e stato attivo/inattivo.

#v(1em)

Le tabelle `ring_group` e `ring_group_destination` implementano la logica dei gruppi di squillo. Un ring group è un insieme di interni che squillano simultaneamente o in sequenza quando viene chiamato. La tabella `ring_group` contiene identificativo e nome del gruppo, mentre `ring_group_destination` è una tabella di associazione many-to-many che collega ogni ring group agli interni che lo compongono. Questa struttura permette configurazioni flessibili dove un interno può appartenere a più ring group e un ring group può contenere molteplici interni.

#v(1em)

La tabella `impostazioni` memorizza configurazioni specifiche del tenant in formato chiave-valore. Include l'identificativo del server PABX (`server`) e il tenant ID (`tenant`) utilizzati per filtrare correttamente i dati durante le operazioni di sincronizzazione e per garantire l'isolamento dei dati in un ambiente multi-tenant.

#v(1em)

La tabella `sync_log` traccia cronologia delle sincronizzazioni con il PABX, un requisito fondamentale per monitoring e troubleshooting. Ogni sincronizzazione genera un record contenente timestamp inizio (`start`) e fine operazione (`end`) permettendo calcolo durata. Durante lo sviluppo e testing, questa tabella si è rivelata indispensabile per debugging del meccanismo di sincronizzazione e per identificare eventuali anomalie nel processo di importazione dati.

== Sicurezza del sistema

La sicurezza è stata considerata requisito fondamentale fin dalle prime fasi progettuali, adottando i principi di defense in depth (difesa su più livelli) e least privilege (concessione dei soli privilegi strettamente necessari).

=== Autenticazione e gestione delle sessioni

Il sistema implementa un meccanismo di autenticazione basato su JSON Web Token (JWT), una soluzione standard per applicazioni web moderne che garantisce autenticazione stateless e scalabile.

Le password degli utenti sono protette mediante hashing con algoritmo bcrypt, configurato con salt factor 10. Questo parametro determina il costo computazionale dell'operazione di hashing, rendendo gli attacchi brute force economicamente non convenibili anche con hardware dedicato. La scelta di bcrypt, anziché algoritmi più veloci come SHA-256, è motivata dalla necessità di un algoritmo deliberatamente lento per l'hashing delle password.

I token JWT sono firmati digitalmente utilizzando HMAC-SHA256 con chiave segreta nota solo al server, garantendo l'integrità del token e prevenendo manipolazioni. Ogni token include:
#v(0.5em)
- Identificativo utente e ruolo per le verifiche di autorizzazione
- Timestamp di emissione e scadenza (configurabile, default 30 giorni)
- Firma crittografica per validazione dell'autenticità
#v(0.5em)
Il sistema supporta refresh token per estendere le sessioni senza richiedere login frequenti, migliorando l'esperienza utente mantenendo livelli di sicurezza adeguati.

=== Controllo degli accessi

L'autorizzazione implementa il modello RBAC (Role-Based Access Control). Ogni utente ha un ruolo assegnato direttamente nella tabella `users`, e i permessi sono definiti in base al ruolo posseduto. Il sistema definisce tre ruoli con privilegi crescenti:
#v(0.5em)
- *User*: accesso in sola lettura ai dati filtrati secondo le proprie autorizzazioni, visualizzazione dashboard e report
- *Admin*: privilegi User più gestione utenti, configurazione filtri e personalizzazione dashboard
- *Superadmin*: privilegi Admin ma non modificabili, con accesso completo a tutte le funzionalità e dati
#v(0.5em)
La verifica dei permessi avviene a livello middleware: ogni richiesta a endpoint protetti attraversa un middleware di autenticazione che valida il token JWT ed estrae il ruolo dell'utente, seguito da un middleware di autorizzazione che verifica se il ruolo posseduto è sufficiente per l'operazione richiesta prima di permetterne l'esecuzione.

=== Protezione da vulnerabilità comuni

Il sistema implementa contromisure specifiche contro le vulnerabilità più diffuse nelle applicazioni web:
 
#v(0.5em)

- *SQL Injection*: tutti gli accessi al database utilizzano prepared statement con binding parametrico tramite l'ORM utilizzato. I valori forniti dall'utente vengono trattati esclusivamente come parametri, mai concatenati direttamente nelle query SQL, rendendo impossibile l'iniezione di codice malevolo.

- *Cross-Origin Resource Sharing (CORS)*: il backend implementa policy CORS configurate per accettare richieste esclusivamente da origini autorizzate. Questa configurazione previene che applicazioni web ospitate su domini non autorizzati possano effettuare chiamate alle API del sistema, proteggendo da accessi non autorizzati e potenziali attacchi cross-site.

- *Validazione input*: i parametri ricevuti dalle API vengono validati per tipo e formato, garantendo che solo dati conformi alle aspettative vengano processati dal sistema.

=== Gestione delle credenziali sensibili

Le credenziali sensibili (password database, chiave segreta JWT, chiavi API) seguono best practice di sicurezza:
#v(0.5em)
- Memorizzazione in variabili d'ambiente, mai nei file sorgente versionati
- Credenziali diverse per ogni ambiente (development, staging, production)
- Rotazione periodica secondo policy di sicurezza aziendale

== Scalabilità e performance

La progettazione architetturale considera requisiti di scalabilità futura mantenendo la semplicità appropriata per le volumetrie attuali, evitando over-engineering prematuro ma garantendo percorsi di evoluzione chiari.

=== Scalabilità orizzontale

L'architettura stateless del backend facilita la scalabilità orizzontale. L'utilizzo di JWT per l'autenticazione elimina la necessità di sessioni server-side: lo stato della sessione è contenuto nel token inviato dal client. Questo permette di distribuire multiple istanze del backend dietro un load balancer senza condivisione dello stato tra le istanze.

Il frontend, essendo completamente client-side con file statici (HTML, CSS, JavaScript), può essere servito da web server replicati o CDN per ridurre latenza e distribuire il carico.

Il database rappresenta il potenziale collo di bottiglia. Il deployment attuale utilizza una singola istanza MySQL, adeguata per i volumi previsti. L'architettura consente l'evoluzione futura verso configurazioni con read replicas per distribuire il carico delle query analitiche.

=== Ottimizzazioni prestazionali

Le scelte progettuali includono diverse ottimizzazioni:
#v(0.5em)
*Indicizzazione database*: sono stati creati indici sulle colonne frequentemente utilizzate nei filtri e negli ordinamenti (calldate, src, dst, linkedid). Gli indici migliorano significativamente le performance delle query in lettura, con un overhead minimo nelle operazioni di scrittura accettabile dato che le sincronizzazioni sono periodiche mentre le query utente sono continue.

*Paginazione*: l'API implementa paginazione per limitare il numero di risultati restituiti per ogni richiesta, mantenendo performance costanti anche con dataset estesi ed evitando il trasferimento di grandi volumi di dati non necessari.

*Aggregazioni server-side*: i calcoli aggregati per grafici e statistiche vengono eseguiti direttamente dal database mediante query SQL ottimizzate, riducendo drasticamente il volume di dati trasferiti al client. Ad esempio, per un grafico dei volumi orari vengono restituiti 24 valori aggregati anziché migliaia di singoli record.