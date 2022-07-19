# Sintesi di funzioni booleane multi-uscita mediante programmazione lineare intera

Studio che utilizza l'algoritmo di Quine-McCluskey per enumerare gli implicanti di una rete combinatoria multi uscita e la PLI (Branch & Bound) per trovare la sintesi ottima di essa.

Implementato utilizzando MATLAB e `intlinprog`.

La teoria dietro al codice è illustrata all'interno della cartella `📂docs`.


# Usage

Per capire come utilizzare le funzioni fornite all'interno di 📂src controllare gli esempi.

Tra gli esempi ne è presente uno chiamato `check.m` che illustra come usare la funzione `synthesisCheck`.

# File structure

```
📦project
│	📃README.md
│
└───📂docs
|		📃versari_alessandro.pdf
|		📃PresentazioneTesiVersari.pdf
|		📃PresentazioneTesiVersari.pptx
|
└───📂examples
|		📜check.m
|		📜example1.m
|		📜example2.m
|		📜example3.m
|		📜example4.m
|		📜verbose.m
|
└───📂src
|		📜displayImplicants.m
|		📜getAllImplicants.m
|		📜synthesisCheck.m
|		📜oneOutputSynteshis.m
|		📜multipleOutputSynthesis.m
|		📜utils.m
|
└───📂statistics
	|	📜distribution.m
	|	📜statistics.m
	|	📜plotStatistics.m
	|
	|	📜statistics.sh
	|	📜input_statistics.sh
	|
	└───📂out
|
└───📂test
		📜randomTest.m

```


## 📂docs

Cartella contenenente la documentazione per questo progetto

## 📂examples

All'interno di questa cartella si possono trovare gli esempi esplicativi trattati nella tesi, più un sempio che illustra come utilizzare `synthesisCheck`.

## 📂src

Cartella che contiene tutte le funzioni utilizzate per eseguire la sintesi.


## 📂statistics

All'interno di questa cartella ci sono le funzioni usate per generare i test e plottare i grafici e una cartella `📂out` .

I due script .sh invocano lo script statistics.m passandogli come parametro:
- il numero di entrate
- il numero di uscite
- il numero dell'ultimo test eseguito

#### 📂out 
In questa cartella sono contenuti tutti i file dei test nel formato `inputs-outputs.txt` contenenti i risultati dei test nel formato:

```
index oneOutputCost multipleOutputCost timeOfExecution
1 65 61 1.188256
2 84 81 0.359309
3 152 137 0.186701
4 58 54 0.116115
```

## 📂test

cartella contenente uno script che permette di effettuare `n` test su un qualsiasi numero di uscite o di entrate.
