# tesi
Minimizzazione di funzioni booleane multi-uscita utilizzando la programmazione lineare intera

for reference
- https://github.com/int-main/Quine-McCluskey
- https://www.youtube.com/watch?v=NgFW-3_w_W4
- https://tex.stackexchange.com/questions/140567/drawing-karnaughs-maps-in-latex
- https://uk.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

# todo
- docs
    - cost : "literal" || "gateInput"
- code
    - find a way to get the index of an implicant in O(1)
    - fare un euristica che cerca tutti gli implicanti necessari piccoli e li mette come don't care nelle funzioni
	- pass x_0 to intlinprog when doing the statistics and don't find the implicants two times

# questions

- come mai non basta mettere una variabile sola per gli implicanti che si ripetono?
        perchè in quel modo come un'implicante viene scelto in un'uscita lo è anche in un altra, è un euristica???? forse si, alla fine il costo a diodi aumenta solo di uno (per ogni uscita in cui quell'implicante è presente) 

# server 

- 1..16 uscite 6 entrate

- 1..7 uscite 7 entrate

# todo

- modifica Glossario in notazione e aggiungi un asterisco in fronte a Indici e dimensioni
- cambia preambolo (precisazioni)
- problema ad un'uscita => problema ad una uscita
- aggiungere un disegno del circuito nella sintesi ad una uscita
- 2.5.2 "primale standard"
- esprimere U in funzione delle cardinalità di V e V^1....V^k
- usare lettere greche per le matrici, usare bold per i vettori
    - Delta al posto della
- spiegare meglio cosa è E
- vincoli di scelta sugli implicanti
- Z => A e inserirlo nella notazione
- chiarimenti sulla notazione in generale
- E => \Phi
- I => Iota
- add \mathcal  
- bold le matrici e vettori
- invertire il vettore dei costi
- togliere tutti i c_0
- 4.3 come mai tutti gli implicanti e non solo quelli principali
- notiamo che si può trovare una soluzione feasible utilizzando quelle ottima dei problemi ad una singola uscita
- stampare solo E tilde nell'esempio verbose
- 5.2 alla fine aggiungere "la cui sintesi è riportata sopra in fig"

# roadmap

- plot con sfumatura
- completare 4-5 slide
- fine tesina
- in onda