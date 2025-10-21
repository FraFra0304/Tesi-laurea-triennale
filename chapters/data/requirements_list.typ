// Functional
#let getFunzionali(getLen: bool) = {
  let FR = ()
  let o = "R-FO-"
  let d = "R-FD-"
  let p = "R-FP-"
  let obbligatori = 0
  let desiderabili = 0
  let opzionali = 0
  
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Implementare un sistema di autenticazione sicuro tramite username e password]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve permettere l'accesso alle funzionalità solo ad utenti autenticati]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve visualizzare una pagina Dashboard principale contenente i dati generali delle chiamate con possibilità di filtraggio per periodo temporale]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve fornire una sezione Utenti contenente l'elenco completo degli interni telefonici e pagine di dettaglio per ciascun utente con statistiche e filtri per periodo]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve fornire una sezione Ring Group contenente l'elenco completo dei gruppi e pagine di dettaglio per ciascun ring group con statistiche e filtri per periodo]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve fornire una sezione DID contenente l'elenco completo dei Direct Inward Dialing e pagine di dettaglio per ciascun DID con statistiche e filtri per periodo]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve presentare i dati attraverso grafici per facilitarne l'interpretazione visuale]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve visualizzare metriche aggregate tramite card informative (chiamate totali, ricevute, risposte, perse, effettuate, tempo totale)]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve presentare l'elenco dettagliato delle chiamate in entrata e in uscita tramite tabelle]
  ))
  obbligatori+=1
  FR.push((
    (o + str(obbligatori)), [Il sistema deve permettere l'esportazione dei dati delle tabelle in formato PDF e CSV]
  ))

  desiderabili+=1
  FR.push((
    (d + str(desiderabili)), [Aggiunta di filtri nella Dashboard per utenti, ring group e did]
  ))
  desiderabili+=1
  FR.push((
    (d + str(desiderabili)), [Creazione di una pagina dedicata alla gestione degli account, con inserimento, modifica ed eliminazione]
  ))
  desiderabili+=1
  FR.push((
    (d + str(desiderabili)), [Personalizzazione del sistema con modifica loghi e nome cliente]
  ))

  opzionali+=1
  FR.push((
    (p + str(opzionali)), [Implementazione della crittografia delle password memorizzate nel database]
  ))
  opzionali+=1
  FR.push((
    (p + str(opzionali)), [Implementazione della modifica della password degli utenti (solo per admin)]
  ))
  opzionali+=1
  FR.push((
    (p + str(opzionali)), [Creazione utente superadmin non modificabile ed eliminabile]
  ))

  if getLen == true {
    return (obbligatori, desiderabili, opzionali)
  }
  return FR
}


// Non-Functional
#let getNonFunzionali(getLen: bool) = {
  let FR = ()
  let q = "R-NQ-"
  let v = "R-NV-"
  let qualitativi = 0
  let vincolo = 0
  
  qualitativi+=1
  FR.push((
    (q + str(qualitativi)), [Implementare un sistema di autenticazione sicuro tramite username e password]
  ))

  if getLen == true {
    return (qualitativi, vincolo)
  }
  return FR
}
