#import "../config/thesis-config.typ": *

#pagebreak(to:"odd")

= Implementazione<cap:implementazione>
#text(style: "italic", [
    In questo capitolo viene descritta l'implementazione concreta del sistema, illustrando i pattern architetturali e di design utilizzati, le tecniche di sviluppo adottate, e come sono stati realizzati i requisiti funzionali. La trattazione copre l'organizzazione del codice, i meccanismi implementativi chiave, e le problematiche affrontate durante lo sviluppo con relative soluzioni.
])
#v(1em)

== Organizzazione del codice backend

Il backend è strutturato secondo pattern MVC (Model-View-Controller) adattato per API REST, dove controller gestiscono richieste HTTP, model astraggono l'accesso al database, e non esistono view tradizionali ma risposte JSON.

=== Struttura delle cartelle

Il codice backend è organizzato in moduli con responsabilità ben definite seguendo il principio di Separation of Concerns:

#v(1em)

*Routes* (`/routes`): contiene file che definiscono endpoint API, mappando combinazioni URL + metodi HTTP a controller. Ogni risorsa principale (users, calls, stats, config) ha il proprio file di routes, facilitando navigazione e manutenzione:

#v(1em)

```javascript
// routes/extRoutes.js
const express = require("express");
const router = express.Router();
const ExtController = require("../controllers/extController");
const { authenticate, authorize } = require('../middleware/auth');
const { validateRequest } = require('../middleware/validation');
const { extensionSchemas } = require('../validators/extensionSchemas');

// GET /api/extensions/list - Lista tutte le estensioni
router.get(
  "/list", 
  authenticate,
  ExtController.getExtensions
);

// GET /api/extensions/info?id=xxx - Dettaglio estensione per id
router.get(
  "/info",
  authenticate,
  validateRequest(extensionSchemas.getById),
  ExtController.getExtensionById
);

module.exports = router;
```

#v(2em)

*Controllers* (`/controllers`): contiene business logic per ciascun endpoint. I controller sono funzioni async che ricevono oggetti request/response, estraggono parametri, invocano model appropriati, processano dati, costruiscono risposte HTTP, e gestiscono errori delegando al middleware centralizzato. Ogni controller è focalizzato su un'operazione specifica, mantenendo funzioni concise (< 50 righe) e testabili.

#v(1em)

```javascript
// controllers/extController.js
const ExtModel = require("../models/ExtModel");

const ExtController = {
    async getExtensions(req, res) {
        try {
            const extensions = await ExtModel.getExts();

            if (!extensions) {
                return res.status(404).json({
                    error: 'Nessun interno trovato'
                });
            }

            res.json({
                success: true,
                data: extensions,
                count: extensions.length
            });

        } catch (error) {
            console.error('Errore getExtensions:', error);
            res.status(500).json({
                error: 'Errore nel recupero degli interni',
                details: error.message
            });
        }
    },

    async getExtensionById(req, res) {
        try {
            const { ext } = req.query;

            // Validazione parametro
            if (!ext || ext.trim() === '') {
                return res.status(400).json({
                    error: 'Parametro ext obbligatorio'
                });
            }

            const extension = await ExtModel.getExtById(ext.trim());

            if (!extension) {
                return res.status(404).json({
                    error: `Interno ${ext} non trovato`
                });
            }

            res.json({
                success: true,
                data: extension
            });

        } catch (error) {
            console.error('Errore getExtensionByNumber:', error);
            res.status(500).json({
                error: 'Errore nel recupero dell\'interno',
                details: error.message
            });
        }
    },
};

module.exports = ExtController;

```

#v(2em)

*Models* (`/models`): contiene classi che incapsulano interazione con database. Ogni model corrisponde a una o più tabelle correlate e fornisce metodi per CRUD e query complesse. I model astraggono completamente i dettagli SQL dai controller: un controller non costruisce mai query SQL direttamente, ma invoca metodi del model con parametri business-logic. 

#v(1em)

```javascript
// models/ExtModel.js
const BaseModel = require('./BaseModel');

/**
 * ExtModel - Classe che estende BaseModel
 */
class ExtModel extends BaseModel {
    constructor() {
        super('ext');
    }

    /**
     * Trova tutti gli interni
     * @returns {Promise<Object|null>}
     */
    async getExts() {
        try {
            const query = this.query()
                .orderBy('ext')

            const results = await this.execute(query);
            return results.length > 0 ? results : null;
        } catch (error) {
            throw new Error(`Errore nel recupero degli interni: ${error.message}`);
        }
    }

    /**
     * Trova interno per ext
     * @param {string} ext
     * @returns {Promise<Object|null>}
     */
    async getExtById(ext) {
        try {
            const query = this.query()
                .where('ext', '=', ext);

            const results = await this.execute(query);
            return results.length > 0 ? results[0] : null;
        } catch (error) {
            throw new Error(`Errore nel recupero dell'interno: ${error.message}`);
        }
    }
}

module.exports = new ExtModel();
```

#v(2em)

*Middleware* (`/middleware`): contiene funzioni di elaborazione intermedia che operano tra ricezione richiesta ed esecuzione controller. Middleware implementati:
#v(0.5em)
- `authenticate`: verifica token JWT ed estrae informazioni utente
- `authorize(role)`: verifica permessi per operazioni specifiche
- `validateRequest(schema)`: valida parametri contro schema Joi
- `rateLimiter`: previene abusi limitando richieste per IP
- `errorHandler`: gestisce errori centralizzata
#v(1em)
*Utils* (`/utils`): contiene funzioni di utilità riutilizzabili per parsing e formattazione date, conversioni tra formati, validazioni comuni, hashing e crittografia. Centralizzano logica condivisa evitando duplicazione. Inoltre contiene il Query Builder per costruzione dinamica di query SQL complesse.

Questa organizzazione segue il principio Single Responsibility: ogni modulo ha un'unica ragione di cambiamento. Facilita testing unitario (ogni componente testabile isolatamente con mock), debugging (problemi localizzabili rapidamente), e onboarding (struttura chiara permette comprensione rapida).

== Pattern Architetturali e di Design

L'implementazione del sistema adotta diversi pattern consolidati che migliorano manutenibilità, testabilità ed estensibilità del codice. I pattern descritti non sono stati applicati per ragioni teoriche, ma emergono da esigenze concrete emerse durante lo sviluppo e dalla necessità di risolvere problemi specifici mantenendo il codice pulito e manutenibile.

=== Builder Pattern

Il Builder Pattern è stato implementato nel backend per la costruzione dinamica di query SQL complesse. La necessità emerge dalla grande varietà di filtri applicabili alle query (periodo temporale, interni specifici, gruppi, DID, direzione chiamata, durata, esito) la cui combinazione genererebbe migliaia di query statiche con approccio impraticabile dal punto di vista della manutenibilità.

Il `QueryBuilder` accumula clausole progressivamente, permettendo composizione flessibile attraverso method chaining:

#v(1em)

```javascript
// utils/QueryBuilder.js
class QueryBuilder {
  constructor(baseTable) {
    this.baseTable = baseTable;
    this.selectFields = ['*'];
    this.joins = [];
    this.whereConditions = [];
    this.groupByConditions = []
    this.orderByFields = [];
    this.limitValue = null;
    this.offsetValue = null;
    this.params = [];
  }
  
  select(fields) {
    if (Array.isArray(fields)) {
        this.selectFields = fields;
    } else if (typeof fields === 'string') {
        this.selectFields = fields.split(',').map(f => f.trim());
    }
    return this;
  }

  join(table, condition, type = 'INNER') {
    this.joins.push(`${type} JOIN ${table} ON ${condition}`);
    return this;
  }

  where(field, operator, value) {
    if (value !== undefined && value !== null && value !== '') {
        this.whereConditions.push(`${field} ${operator} ?`);
        this.params.push(value);
    }
    return this;
  }

  whereIn(field, values) {
    if (Array.isArray(values) && values.length > 0) {
        const placeholders = values.map(() => '?').join(',');
        this.whereConditions.push(`${field} IN (${placeholders})`);
        this.params.push(...values);
    }
    return this;
  }

  whereBetween(field, startValue, endValue) {
    if (startValue !== undefined && startValue !== null && startValue !== '') {
      this.where(field, '>=', startValue);
    }
    if (endValue !== undefined && endValue !== null && endValue !== '') {
      this.where(field, '<=', endValue);
    }
    return this;
  }

  groupBy(field) {
    if (field !== undefined && field !== null && field !== '') {
        this.groupByConditions.push(`${field}`);
    }
    return this;
  }

  /* 
  ... altri metodi come whereLike, orderBy, limit, offset
  */

  build() {
    let query = `SELECT ${this.selectFields.join(', ')} FROM ${this.baseTable}`;
    if (this.joins.length > 0) {
      query += ` ${this.joins.join(' ')}`;
    }
    if (this.whereConditions.length > 0) {
      query += ` WHERE ${this.whereConditions.join(' AND ')}`;
    }
    if (this.groupByConditions.length > 0) {
      query += ` GROUP BY ${this.groupByConditions.join(' ,')}`;
    }
    if (this.orderByFields.length > 0) {
      query += ` ORDER BY ${this.orderByFields.join(', ')}`;
    }
    if (this.limitValue !== null) {
      query += ` LIMIT ${this.limitValue}`;
    }
    if (this.offsetValue !== null) {
      query += ` OFFSET ${this.offsetValue}`;
    }
    return {
      query: query,
      params: this.params
    };
  }
}
```

#v(2em)

Il pattern garantisce sicurezza e manutenibilità:
#v(0.5em)
- *Prevenzione SQL Injection*: uso esclusivo di prepared statement con binding parametrico. I valori utente non vengono mai concatenati direttamente nella query
- *Leggibilità*: il method chaining rende esplicita la logica di costruzione della query
- *Flessibilità*: aggiungere nuovi filtri richiede solo aggiungere metodi al builder senza modificare codice esistente
- *Testabilità*: il builder può essere testato unitariamente verificando che generi query corrette
- *Riutilizzo*: lo stesso builder è utilizzabile in context diversi (model, report, export)


=== Repository Pattern

Il Repository Pattern astrae l'accesso ai dati fornendo un'interfaccia orientata al dominio business che nasconde completamente i dettagli di persistenza. I model implementano questo pattern fungendo da intermediari tra i controller e il database, esponendo metodi semantici che esprimono operazioni di business anziché dettagli SQL.

L'obiettivo principale è separare la *logica di business* (cosa fare con i dati) dalla *logica di accesso ai dati* (come recuperare/memorizzare i dati). I controller operano con concetti di dominio senza conoscere tabelle, join, indici o dialetti SQL specifici.

I model sono organizzati per entità di dominio, ciascuno responsabile dell'accesso ai dati della propria area:

#v(1em)

```javascript
// models/RingGroupModel.js
const BaseModel = require('./BaseModel');

class RingGroupModel extends BaseModel {
  constructor() {
    super('ring_group');
  }

  async getRingGroups() {
    try {
      const query = this.query()
        .select([
          'ring_group.ext AS ext',
          'ring_group.nome AS nome',
          'GROUP_CONCAT(rgd.ext ORDER BY rgd.ext SEPARATOR \'-\') AS destinazioni'
        ])
        .leftJoin('ring_group_destination rgd', 'ring_group.id = rgd.id_gruppo')
        .groupBy('ring_group.id')
        .orderBy('ring_group.ext');

      const results = await this.execute(query);
      return results.length > 0 ? results : null;
    } catch (error) {
      throw new Error(`Errore nel recupero delle ring group: ${error.message}`);
    }
  }

  async getRingGroup(ext) {
    try {
      const query = this.query()
        .where('ext', '=', ext)

      const results = await this.execute(query);
      return results.length > 0 ? results[0] : null;
    } catch (error) {
      throw new Error(`Errore nel recupero della ring group: ${error.message}`);
    }
  }

  async getRingGroupById(id) {
    try {
      const query = this.query()
        .where('id', '=', id)

      const results = await this.execute(query);
      return results.length > 0 ? results[0] : null;
    } catch (error) {
      throw new Error(`Errore nel recupero della ring group: ${error.message}`);
    }
  }
}

module.exports = new RinGroupModel();
```


=== Chain of Responsibility

Il Chain of Responsibility è un pattern comportamentale che permette di passare richieste lungo una catena di handler, dove ogni handler decide se processare la richiesta o passarla al successivo. Nel contesto di Express.js, questo pattern è implementato nativamente attraverso il sistema di *middleware*, dove ogni middleware nella catena ha l'opportunità di elaborare la richiesta HTTP, arricchirla con informazioni aggiuntive, terminare la catena restituendo una risposta, oppure delegare al middleware successivo.

#v(1em)
*Architettura della Pipeline*
#v(1em)

Express.js implementa il pattern attraverso una sequenza ordinata di funzioni middleware che ricevono tre parametri: l'oggetto `request`, l'oggetto `response`, e la funzione `next()` che permette di passare il controllo al middleware successivo. Ogni middleware può modificare gli oggetti request/response condividendo stato lungo la catena, oppure interrompere l'elaborazione restituendo una risposta al client.

La definizione delle route mostra esplicitamente la catena di responsabilità:

#v(1em)


```javascript
// routes/accountRoutes.js
const express = require('express');
const router = express.Router();
const AccountController = require("../controllers/accountController");
const verifyToken = require('../middleware/verifyToken');
const authorizeRoles = require('../middleware/authorizeRoles');
const accountSchemas } = require('../validators/accountSchemas');

// Chain completa per endpoint protetto con validazione
router.get(
  '/list',
  verifyToken,
  accountSchemas(accountSchemas.getList),
  AccountController.getAccountList
);

// Chain con autorizzazione per operazioni amministrative
router.post(
  '/new',
  verifyToken,
  authorizeRoles('admin'),
  accountSchemas(accountSchemas.insertAccount),
  AccountController.insertAccount
);

module.exports = router;
```

#v(2em)


Ogni route definisce una pipeline specifica componendo middleware riutilizzabili. L'ordine è cruciale: l'autenticazione deve precedere l'autorizzazione, la validazione deve precedere la business logic.

== Implementazione dell'autenticazione

L'autenticazione è implementata tramite JSON Web Token (JWT), standard industriale per gestione sessioni in applicazioni distribuite.

=== Processo di login

Al login, la sequenza è:
#v(0.5em)
1. Client invia POST a `/auth/login` con username e password.
2. Controller autentica credenziali contro database usando bcrypt per confronto hash.
3. Se valide, genera JWT contenente user ID, nome, username e ruolo.
4. Token firmato con chiave segreta (HMAC-SHA256) memorizzata in variabile ambiente.
5. Token restituito al client con scadenza configurabile (default 30 giorni).

#v(1em)

```javascript
const AuthController = {
  login: async (req, res) => {
    try {
      const { username, password } = req.body;

      const user = await userModel.getUserByUsername(username);
      if (!user) {
        return res.status(401).json({ error: "Credenziali non valide" });
      }

      const passwordValid = await bcrypt.compare(password, user.password);
      if (!passwordValid) {
        return res.status(401).json({ error: "Credenziali non valide" });
      }

      if (!user.autorizzato) {
        return res.status(401).json({ error: "Utente non autorizzato" });
      }

      const token = AuthController._generateToken(user);
      AuthController._setTokenCookie(res, token);

      res.json({
        message: 'Login effettuato',
        user: {
          id: user.id,
          nome: user.nome,
          username: user.username,
          ruolo: user.tipo_utente
        }
      });
    } catch (err) {
      console.error('Login error:', err);
      res.status(500).json({ error: "Errore nel login" });
    }
  },

  _generateToken: (user) => {
    const payload = {
      id: user.id,
      nome: user.nome,
      username: user.username,
      ruolo: user.tipo_utente,
    };
    return jwt.sign(payload, jwtConfig.secret, {
      expiresIn: jwtConfig.expiresIn
    });
  },

  _setTokenCookie: (res, token) => {
    res.cookie('token', token, {
      httpOnly: true,
      maxAge: 30 * 24 * 60 * 60 * 1000,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'Lax'
    });
  }
};
```

== Implementazione della gestione errori

Gestione errori implementa middleware centralizzato che intercetta eccezioni da qualsiasi punto dell'applicazione.

=== Classificazione errori

Errori classificati in categorie con trattamento differenziato:
#v(0.5em)
/ *Errori validazione (400)*:: input non conforme, parametri mancanti/malformati. Dettagli specifici su validazione fallita per correzione immediata.

/ *Errori autenticazione (401)*:: token mancante, scaduto, invalido. Istruzione di effettuare nuovo login.

/ *Errori autorizzazione (403)*:: utente autenticato ma senza permessi. Distingue da "non sei loggato".

/ *Errori risorsa non trovata (404)*:: risorsa richiesta non esiste. Distingue tra errore client e server.

/ *Errori database (500)*:: problemi connessione, violazioni vincoli, timeout. Loggati con priorità alta.

/ *Errori interni (500)*:: eccezioni non anticipate, bug. Loggati con stack trace completo.


== Implementazione delle API REST

Le API seguono principi REST con rigore architetturale.

=== Uso semantico dei metodi HTTP

- *GET*: operazioni sola lettura senza side-effect
- *POST*: creazione nuove risorse, non idempotente
- *PUT*: aggiornamento completo risorse esistenti, idempotente
- *DELETE*: rimozione risorse, idempotente

#v(1em)
```javascript
// GET /api/users - lista utenti
// GET /api/users/:id - dettaglio utente
// POST /api/users - crea nuovo utente
// PUT /api/users/:id - aggiorna utente completo
// DELETE /api/users/:id - elimina utente
```

=== URL gerarchici

Risorse identificate da URL che riflettono relazioni del dominio:
#v(1em)
```
/api/users/{userId}/extensions - interni associati a utente
/api/calls/{callId}/linked - chiamate correlate
/api/stats/hourly?start=...&end=... - statistiche orarie per periodo
```

=== Codici di stato HTTP

Risposte usano codici semanticamente corretti:
#v(0.5em)
- *200 OK*: operazione riuscita con contenuto
- *201 Created*: risorsa creata (include header Location)
- *204 No Content*: operazione riuscita senza contenuto di ritorno
- *400 Bad Request*: errori validazione
- *401 Unauthorized*: mancata autenticazione
- *403 Forbidden*: mancata autorizzazione
- *404 Not Found*: risorsa non trovata
- *409 Conflict*: conflitto stato (es. username già esistente)
- *500 Internal Server Error*: errori server


== Implementazione frontend

Il frontend è strutturato seguendo un'architettura modulare multi-pagina, dove ogni funzionalità è rappresentata da un file HTML dedicato. Questa scelta privilegia la semplicità e la manutenibilità rispetto alle architetture #gl("spa") più complesse.

=== Organizzazione file e struttura

L'applicazione è composta da file HTML separati per ogni sezione funzionale. 
Per garantire consistenza visiva e ridurre duplicazione codice, componenti comuni come header e navbar sono estratti in file dedicati e inclusi dinamicamente tramite JavaScript in ciascuna pagina:
#v(1em)
```javascript
// Caricamento componenti comuni
fetch('components/header.html')
    .then(response => response.text())
    .then(html => document.getElementById('header-container').innerHTML = html);

fetch('components/navbar.html')
    .then(response => response.text())
    .then(html => document.getElementById('navbar-container').innerHTML = html);
```
#v(2em)
Questo approccio consente modifiche centralizzate ai componenti condivisi propagate automaticamente su tutte le pagine.

Ogni pagina HTML è associata a un file JavaScript specifico contenente logica applicativa relativa. Complementarmente, file JavaScript globali (`global.js`, `config.js`) centralizzano:
#v(0.5em)
- Variabili di configurazione (URL API, costanti applicative)
- Funzioni utility riutilizzabili (formattazione date, conversione durate, gestione token autenticazione)
- Costanti condivise (mappature stato chiamate, configurazioni)

=== Pattern Factory per tabelle e grafici

Per gestione componenti complessi come tabelle DataTables e grafici Chart.js, è implementato pattern Factory garantendo creazione consistente e configurabile istanze senza duplicazione codice.

*CallsTableFactory* gestisce creazione tabelle chiamate con configurazioni specifiche per contesto:
#v(1em)
```javascript
// Tabella chiamate in entrata
CallsTableFactory.createIncomingTable(
    startDate,
    endDate,
    extensions,
    ringGroups,
    dids
);

// Tabella chiamate in uscita con configurazione diversa
CallsTableFactory.createOutgoingTable(
    startDate,
    endDate,
    extensions,
    ringGroups,
    dids
);

// Tabella dashboard con paginazione ridotta
CallsTableFactory.createDashboardTable(
    startDate,
    endDate,
    extensions,
    ringGroups,
    dids
);
```
#v(2em)
Factory instanzia classe `CallsTableManager` configurata con:
#v(0.5em)
- Selettore CSS tabella target
- Endpoint API per recupero dati
- Tipo tabella (entrata/uscita) determinando colonne e rendering
- Configurazioni DataTables (paginazione, ordinamento, export)
- Gestori eventi (click riga, apertura modal dettaglio)
#v(1em)
`CallsTableManager` incapsula la logica specifica per gestione tabelle chiamate, inclusi:
#v(0.5em)
- *Recupero dati*: chiamate asincrone API con gestione autenticazione e errori
- *Column definitions*: configurazione colonne con renderer custom per formattazione dati (date, durate, stati)
- *Interattività*: gestione click righe aprendo modal con dettagli chiamata
- *Export*: integrazione pulsanti export CSV/Excel/PDF
#v(1em)
`CallsTableManager` implementa anche pattern Strategy per rendering celle, permettendo logiche visualizzazione diverse basate su tipo tabella. Ad esempio, rendering stato chiamata utilizza mappatura colori:
#v(1em)
```javascript
this.statusLabels = {
    "ANSWER": { title: 'ANSWER', class: 'bg-label-success' },
    "BUSY": { title: 'BUSY', class: 'bg-label-secondary' },
    "NO ANSWER": { title: 'NO ANSWER', class: 'bg-label-danger' },
    "FAILED": { title: 'FAILED', class: 'bg-label-warning'},
    "UNKNOWN": { title: 'UNKNOWN', class: 'bg-label-gray'}
};

renderStatus(data, type, full) {
    const status = this.statusLabels[data] || this.statusLabels["UNKNOWN"];
    return `<span class="badge ${status.class}">${status.title}</span>`;
}
```
#v(2em)
Analogamente, *ChartsFactory* gestisce creazione grafici Chart.js con configurazioni predefinite per diverse tipologie di visualizzazione (linee temporali, barre comparative, torte distribuzione).

=== Librerie frontend

*DataTables* fornisce funzionalità avanzate per la gestione delle tabelle:
- Ordinamento multi-colonna client-side
- Filtro full-text e per colonna
- Paginazione configurabile
- Export dati multipli formati (CSV, Excel, PDF)
- Design responsive adattabile dispositivi mobili
#v(1em)
*Chart.js* utilizzato per visualizzazioni grafiche:
- Grafici linee per trend temporali (volumi chiamate, durate medie)
- Grafici barre per distribuzioni (chiamate per interno, per direzione)
- Grafici torta per composizioni percentuali (distribuzione esiti)
#v(1em)
*SweetAlert2* per notifiche user-friendly e modal conferma azioni, sostituendo alert nativi browser con interfaccia gradevole e personalizzabile.

== Sincronizzazione dati CDR

La sincronizzazione dei dati dal centralino rappresenta un processo critico per il corretto funzionamento del sistema, richiedendo particolare attenzione agli aspetti di robustezza, affidabilità e performance.

=== Architettura del processo di sincronizzazione

Il sistema implementa una sincronizzazione incrementale schedulata periodicamente (configurabile, con default impostato a esecuzione giornaliera a mezzanotte). Il processo segue una sequenza di operazioni ben definita:
#v(0.5em)
1. *Recupero timestamp*: interrogazione della tabella `sync_log` per determinare il timestamp dell'ultima sincronizzazione completata con successo
2. *Query selettiva*: estrazione dal database PABX dei soli record CDR con `calldate` successivo al timestamp recuperato
3. *Elaborazione batch*: trasferimento dei record in batch di 1000 elementi, bilanciando consumo di memoria e numero di query al database
4. *Inserimento con deduplicazione*: inserimento nel database locale verificando duplicati tramite campo `uniqueid`
5. *Logging operazioni*: registrazione dettagliata dell'operazione nella tabella `sync_log` includendo metriche quali numero record importati, durata esecuzione ed eventuali errori
6. *Aggiornamento stato*: persistenza del nuovo timestamp di sincronizzazione per le elaborazioni successive

L'implementazione del processo è mostrata nel seguente estratto:
#v(1em)
```javascript
async function syncCDR() {
  const startTime = Date.now();
  const lastSync = await getLastSuccessfulSync();
  
  try {
    const newRecords = await fetchCDRFromPABX(lastSync.timestamp);
    let imported = 0;
    
    for (const batch of chunk(newRecords, 1000)) {
      await db.transaction(async (trx) => {
        for (const record of batch) {
          await trx('cdr').insert(record).onConflict('uniqueid').ignore();
          imported++;
        }
      });
    }
    
    await logSync({
      status: 'success',
      recordsImported: newRecords.length,
      recordsInserted: imported,
      duration: Date.now() - startTime
    });
    
  } catch (error) {
    await logSync({
      status: 'failed',
      error: error.message,
      duration: Date.now() - startTime
    });
    throw error;
  }
}
```
#v(1em)
=== Gestione transazionale e recupero errori

Gli inserimenti avvengono all'interno di transazioni database per garantire atomicità delle operazioni: l'intero batch viene importato con successo oppure l'operazione viene completamente annullata, prevenendo stati inconsistenti nel database. Il sistema implementa una gestione errori articolata su più livelli:
#v(0.5em)
*Errori di connessione*: meccanismo di retry automatico con backoff esponenziale su tre tentativi con intervalli crescenti (1 secondo, 2 secondi, 4 secondi) per gestire problematiche di rete transitorie.

*Errori di parsing*: i record singoli non validi vengono registrati nel log ma non bloccano l'importazione dei record rimanenti, garantendo massima continuità operativa.

*Violazioni vincoli database*: la gestione mediante clausola `ON CONFLICT IGNORE` permette di evitare duplicazioni senza interrompere il flusso di sincronizzazione.

=== Sistema di monitoring

Il sistema traccia ogni sincronizzazione registrando metriche fondamentali per il monitoraggio:
#v(0.5em)
- Durata media delle sincronizzazioni per identificare eventuali degradazioni prestazionali
- Tasso di errori per rilevare tempestivamente problematiche sistemiche
- Volume dati importati per identificare variazioni anomale indicative di malfunzionamenti del PABX
#v(1em)
Il sistema di alerting configurabile notifica l'amministratore in presenza di condizioni anomale:
#v(0.5em)
- Tre sincronizzazioni consecutive fallite generano notifica email
- Durata sincronizzazione superiore a dieci volte la media produce warning prestazionale
- Assenza di nuovi record per oltre 24 ore segnala possibile interruzione nella raccolta dati

== Problematiche affrontate e soluzioni adottate

Durante lo sviluppo del sistema sono emerse diverse sfide tecniche che hanno richiesto soluzioni specifiche. Di seguito vengono descritte le principali problematiche e gli approcci risolutivi implementati.

=== Gestione dell'asincronicità

La natura asincrona di JavaScript e delle operazioni di rete ha richiesto particolare attenzione nella progettazione. Il sistema adotta sistematicamente Promise e sintassi async/await per garantire leggibilità e manutenibilità del codice.
#v(0.5em)
*Loading states*: sono stati implementati indicatori visivi (spinner, progress bar) durante operazioni di lunga durata, aspetto cruciale per l'esperienza utente quando si elaborano volumi significativi di dati.

*Gestione errori di rete*: il sistema implementa retry automatico con backoff esponenziale per richieste fallite a causa di problematiche transitorie (timeout, errori 5xx del server). Il meccanismo effettua fino a tre tentativi con intervalli crescenti prima di presentare l'errore definitivo all'utente.

*Timeout configurabili*: ogni richiesta ha un timeout configurabile (default 30 secondi) per evitare attese indefinite. Al superamento del timeout, la richiesta viene cancellata e l'utente viene informato dell'indisponibilità temporanea del servizio.

*Gestione race condition*: quando l'utente modifica rapidamente i filtri di ricerca, possono generarsi richieste multiple che completano in ordine non determinabile. La soluzione implementata utilizza cancellazione delle richieste tramite `AbortController`:
#v(1em)
```javascript
let currentRequest = null;

async function loadData(filters) {
  // Cancella eventuale richiesta pendente
  if (currentRequest) {
    currentRequest.abort();
  }
  
  currentRequest = new AbortController();
  
  try {
    const data = await fetch(url, { signal: currentRequest.signal });
    renderData(data);
  } catch (error) {
    if (error.name !== 'AbortError') {
      handleError(error);
    }
  }
}
```
#v(2em)
=== Visualizzazione di dataset estesi

L'applicazione gestisce dataset di dimensioni considerevoli, potenzialmente comprendenti anni di storico chiamate. La visualizzazione diretta di tali volumi risulta impraticabile sia per ragioni prestazionali che di usabilità.
#v(1em)
*Campionamento automatico per grafici*: il backend determina automaticamente la granularità appropriata in base al range temporale richiesto:
- Intervalli giornalieri: aggregazione in bucket orari
- Intervalli settimanali o mensili: aggregazione in bucket giornalieri
- Intervalli annuali: aggregazione in bucket mensili

Questa strategia mantiene il numero di punti dati entro limiti gestibili (inferiore a 30) indipendentemente dall'ampiezza del periodo analizzato.
#v(1em)
*Paginazione server-side per tabelle*: il frontend richiede una pagina specifica di risultati (default 50 righe per pagina), mentre il backend restituisce esclusivamente quella porzione insieme al conteggio totale dei record. Il sistema avvisa l'utente quando un filtro produce un numero eccessivo di risultati (superiore a 10.000 record), suggerendo un raffinamento dei criteri pur permettendo di procedere con la visualizzazione.

=== Ottimizzazione delle performance

Le performance rappresentano una preoccupazione costante dello sviluppo, rispondendo direttamente al requisito non funzionale #link("r-nq-2")[R-NQ-1] sui tempi di risposta rapidi.
#v(1em)
*Profiling delle query*: il backend è strumentato per registrare il tempo di esecuzione di ogni query database. Le query che eccedono soglie prestazionali vengono analizzate mediante il comando `EXPLAIN` di MySQL per identificare colli di bottiglia.

Un esempio concreto di ottimizzazione: la query per calcolare il volume di chiamate per interno in un mese richiedeva inizialmente 5 secondi con 100.000 record. L'analisi tramite `EXPLAIN` ha rivelato un full table scan. La creazione di un indice composito su `(calldate, src, disposition)` ha ridotto il tempo a 0.5 secondi, ottenendo un miglioramento di 10 volte.

Altri indici strategici creati durante l'ottimizzazione:
#v(0.5em)
- Indice su `linkedid` per correlazione chiamate correlate (riduzione da 5 secondi a 0.5 secondi)
- Indice su `dst` per statistiche su numeri chiamati
- Indici compositi su combinazioni di campi frequentemente filtrati insieme

Gli indici migliorano drasticamente le performance in lettura introducendo un overhead nelle operazioni di scrittura. Nel contesto applicativo, caratterizzato da sincronizzazioni periodiche e operazioni di lettura dominanti, questo trade-off risulta ampiamente favorevole. L'analisi ha evidenziato che gli indici rallentano le sincronizzazioni ma migliorano notevolmente le performance delle query di lettura, che sono l'operazione prevalente nell'uso quotidiano del sistema.
#v(1em)
*Riduzione volume dati trasferiti*: le query selezionano esplicitamente solo le colonne necessarie alla visualizzazione. Per i grafici, il backend calcola le aggregazioni anziché trasferire dati grezzi al frontend. Ad esempio, un grafico dei volumi orari restituisce 24 valori aggregati anziché migliaia di record individuali, riducendo il payload da megabyte a kilobyte.
#v(1em)
*Performance rendering frontend*: il sistema impone un limite massimo di 30 punti per grafico, con il backend che reaggrega automaticamente i dati se necessario. La paginazione server-side per le tabelle garantisce un massimo di 100 righe simultaneamente presenti nel DOM, mantenendo fluida l'interazione utente.

=== Limitazioni nell'accesso ai dati del PABX

Una problematica ricorrente durante lo sviluppo è stata rappresentata dalle limitazioni nell'accesso ai dati del centralino. Il vendor fornisce esclusivamente la tabella CDR e alcune API REST, senza concedere accesso completo al database per ragioni di sicurezza e supportabilità del sistema.

Questa limitazione ha reso impossibili diverse funzionalità avanzate inizialmente considerate:
#v(0.5em)
- Integrazione con registrazioni audio e playback diretto dall'interfaccia
- Tracking dettagliato dei trasferimenti di chiamata con tempi di permanenza in ogni stato
- Statistiche avanzate di performance per agente (tempi di risposta, pause, gestione code)
#v(1em)
L'approccio adottato è stato pragmatico: concentrarsi sulle funzionalità realizzabili con i dati disponibili, implementandole con il massimo livello qualitativo possibile. Le limitazioni sono state comunicate trasparentemente al tutor aziendale durante le riunioni settimanali. Di fronte a richieste di funzionalità non realizzabili con i dati CDR disponibili, si è proceduto ad analizzare quali informazioni sarebbero necessarie, verificarne la disponibilità nel database PABX, e nel caso di indisponibilità spiegare le ragioni tecniche dell'impossibilità.

L'esperienza ha evidenziato come la comprensione dei vincoli tecnici del sistema sorgente sia fondamentale nella fase di analisi dei requisiti. La verifica preventiva della disponibilità dei dati necessari per ciascuna funzionalità richiesta ha permesso di evitare investimenti di tempo su sviluppi non realizzabili, concentrando gli sforzi sulle funzionalità effettivamente implementabili e maggiormente prioritarie per l'azienda.

