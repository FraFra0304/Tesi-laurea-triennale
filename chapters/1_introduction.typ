#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "../config/thesis-config.typ": gl, glpl, glossary-style, linkfn, gls

= Introduzione <cap:introduzione>

== L'azienda
Cinquenet S.r.l. è un'azienda specializzata nel settore delle Information and Communication Technology (ICT) con sede a Cerea, in provincia di Verona. Fondata da un team di professionisti con oltre vent'anni di esperienza consolidata nel settore delle telecomunicazioni, l'azienda si distingue nel panorama delle soluzioni tecnologiche per la combinazione di competenza tecnica, passione e attenzione al dettaglio.
La filosofia aziendale di Cinquenet si basa sullo sviluppo di soluzioni ICT all'avanguardia, progettate per garantire elevata affidabilità operativa e stabilità nel tempo. Questo approccio ha permesso all'azienda di costruire una solida reputazione nel territorio veneto e di espandere la propria presenza nel mercato delle telecomunicazioni e dei servizi informatici.

=== Aree di specializzazione
L'offerta di Cinquenet si articola in tre macro-aree di competenza, che riflettono un approccio integrato alle esigenze tecnologiche delle aziende moderne:

#v(0.5em)
#text(weight: "bold")[Soluzioni telefoniche e di rete:]
#v(0.5em)

Il core business dell'azienda comprende la progettazione e implementazione di infrastrutture di telecomunicazione avanzate. Tra i servizi principali figurano la realizzazione di reti in fibra ottica, collegamenti ADSL, linee professionali dedicate, centralini virtuali e impianti telefonici aziendali. Particolare expertise viene dedicata alle soluzioni wireless e ai link radio, tecnologie fondamentali per garantire connettività in contesti dove le infrastrutture tradizionali risultano insufficienti.

#v(0.5em)
#text(weight: "bold")[Servizi informatici e cloud:]
#v(0.5em)

Cinquenet offre una gamma completa di soluzioni per la gestione dell'infrastruttura IT aziendale, includendo servizi di hosting, server cloud, backup dei dati e consulenza informatica specializzata. L'azienda si è inoltre posizionata come partner strategico per l'implementazione di tecnologie emergenti quali Internet of Things (IoT) e soluzioni basate su intelligenza artificiale.

#v(0.5em)
#text(weight: "bold")[Sicurezza e protezione:]
#v(0.5em)

Un'area di crescente importanza nel portfolio aziendale è rappresentata dalla cybersecurity, settore nel quale Cinquenet sviluppa strategie di protezione integrate per la sicurezza informatica. Parallelamente, l'azienda opera nel campo della sicurezza fisica attraverso l'installazione di sistemi di videosorveglianza e impianti antintrusione.

== Motivazone del progetto
Ho scelto di svolgere lo stage presso Cinquenet srl per diverse ragioni che rendevano questa opportunità particolarmente interessante dal punto di vista formativo e professionale. Innanzitutto, conoscevo già l'azienda e il suo approccio lavorativo, il che mi ha permesso di valutare positivamente l'ambiente e le metodologie operative.

La decisione di non optare per un'azienda tradizionalmente focalizzata sulla programmazione è stata dettata dal desiderio di ampliare le mie competenze in un contesto più diversificato. Mi intrigava l'idea di lavorare in un'azienda operante nel mondo dell'informatica ma con un focus specifico su reti, connessioni e centralini virtuali #gl("pabx"), settori che offrono prospettive di crescita professionale complementari allo sviluppo software puro.

Il progetto di stage consiste nello sviluppo di una dashboard web che consente ai clienti di accedere a tutte le statistiche e i dettagli delle chiamate effettuate e ricevute. La piattaforma offre funzionalità di filtraggio avanzate per interno, #gl("ring-group"), #gl("did") e periodi temporali, presentando i dati attraverso statistiche, grafici e tabelle dettagliate. Tutti i contenuti sono progettati per essere facilmente stampabili ed esportabili in formato PDF e CSV.

Questo progetto rappresenta un'opportunità ideale per combinare competenze di programmazione web con la conoscenza del mondo dei centralini virtuali e delle telecomunicazioni aziendali, offrendo un'esperienza formativa completa e multidisciplinare.

== Struttura della tesi
Il presente documento è strutturato secondo la seguente organizzazione:
#v(0.5em)

/ #link(<cap:descrizione-stage>)[Il secondo capitolo]: presenta una descrizione dettagliata dello stage, includendo l'organizzazione del lavoro, il rapporto con l'azienda e il tutor aziendale, la metodologia adottata e l'analisi preventiva dei rischi.

/ #link(<cap:descrizione-stage>)[Il terzo capitolo]: contiene l'analisi approfondita dei requisiti del sistema, suddivisi per tipologia e priorità, insieme all'identificazione degli stakeholder e dei casi d'uso principali.

/ #link(<cap:descrizione-stage>)[Il quarto capitolo]: fornisce un'introduzione teorica alle tecnologie e agli strumenti utilizzati, presentando le motivazioni alla base delle scelte architetturali e tecnologiche adottate.

/ #link(<cap:architettura>)[Il quinto capitolo]: descrive l'architettura del sistema progettato, illustrando la struttura del database, le considerazioni sulla sicurezza e sulla scalabilità.

/ #link(<cap:implementazione>)[Il sesto capitolo]: presenta l'implementazione del sistema, dettagliando i pattern architetturali adottati, le problematiche affrontate con le relative soluzioni, e la realizzazione dei requisiti funzionali e non funzionali.


#v(0.5em)
#text(weight: "bold")[Convenzioni tipografiche:]
#v(0.5em)
Per la stesura del documento sono state adottate le seguenti convenzioni:
#v(0.5em)
- Gli acronimi, le abbreviazioni e i termini tecnici specialistici sono definiti nel glossario posto al termine del documento;

- La prima occorrenza dei termini presenti nel glossario è evidenziata con la seguente notazione: #gl("api");

- I termini in lingua straniera e il gergo tecnico sono riportati in corsivo.
