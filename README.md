# tesi
Minimizzazione di funzioni booleane multi-uscita utilizzando la programmazione lineare intera

for reference
- https://github.com/int-main/Quine-McCluskey
- https://www.youtube.com/watch?v=NgFW-3_w_W4
- https://tex.stackexchange.com/questions/140567/drawing-karnaughs-maps-in-latex
- https://uk.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html
- https://cdm.unimore.it/home/matematica/vernia.cecilia/distribuzioni.pdf

# todo
- code
    - find a way to get the index of an implicant in O(1)
    - fare un euristica che cerca tutti gli implicanti necessari piccoli e li mette come don't care nelle funzioni
	- pass x_0 to intlinprog when doing the statistics and don't find the implicants two times

# questions

- come mai non basta mettere una variabile sola per gli implicanti che si ripetono?
    perchè in quel modo come un'implicante viene scelto in un'uscita lo è anche in un altra, è un euristica???? forse si, alla fine il costo a diodi aumenta solo di uno (per ogni uscita in cui quell'implicante è presente) 

# todo

- chiarimenti sulla notazione in generale
- Z => A e inserirlo nella notazione
- I => Iota !!! non esiste la \Iota
- add \mathcal !!! 
- bold le matrici e vettori
- notiamo che si può trovare una soluzione feasible utilizzando quelle ottima dei problemi ad una singola uscita
- 5.2 alla fine aggiungere "la cui sintesi è riportata sopra in fig"

# roadmap

- plot con sfumatura
- completare 4-5 slide
- fine tesina
- in onda