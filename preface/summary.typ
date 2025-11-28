#import "../config/constants.typ": abstract
#import "../config/variables.typ": *
#import "../config/thesis-config.typ": glossary-style
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#pagebreak(to: "odd")
#v(4em)

#text(24pt, weight: "semibold", abstract)

#v(1em)
Il presente documento descrive il lavoro svolto durante il periodo di stage curricolare dal laureando #text(myName) presso l'azienda #text(myCompany) di Cerea (VR). Lo stage, della durata complessiva di circa trecentoventi ore, si è svolto al termine del percorso di studi della Laurea Triennale in Informatica presso l'Università degli Studi di Padova, sotto la supervisione del tutor aziendale #myTutor e del tutor accademico prof. #text(myProf).

Il progetto ha avuto come obiettivo lo sviluppo di una dashboard web per l'analisi delle chiamate telefoniche, destinata ai clienti aziendali che utilizzano i centralini virtuali PABX forniti da Cinquenet. La piattaforma consente di visualizzare statistiche dettagliate sulle chiamate effettuate e ricevute, applicare filtri avanzati per interno, ring group, DID e periodo temporale, e generare report personalizzati esportabili in formato PDF e CSV.

Il sistema è stato realizzato interamente ex novo, adottando un'architettura three-tier che separa presentazione, logica applicativa e persistenza dei dati. Il backend, sviluppato in Node.js con Express, espone API RESTful per l'elaborazione dei dati telefonici estratti dai Call Detail Record del centralino. Il frontend, implementato con tecnologie web standard HTML5, CSS3 e JavaScript, presenta i dati attraverso grafici interattivi, tabelle dettagliate e card informative con metriche aggregate.

Lo sviluppo ha seguito il Modello Evolutivo con iterazioni settimanali, permettendo di rilasciare un MVP funzionante nelle prime settimane e di raffinare progressivamente il sistema sulla base dei feedback ricevuti dal tutor aziendale e dal cliente finale. Particolare attenzione è stata dedicata all'ottimizzazione delle query SQL per garantire tempi di risposta adeguati anche su grandi volumi di dati storici.

Il progetto ha raggiunto tutti gli obiettivi prefissati, inclusi quelli inizialmente classificati come opzionali, producendo un sistema completo attualmente in produzione che genera valore concreto per l'azienda e i suoi clienti.
\ \
