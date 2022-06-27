# tesi
Minimizzazione di funzioni booleane multi-uscita utilizzando la programmazione lineare intera

for reference
- https://github.com/int-main/Quine-McCluskey
- https://www.youtube.com/watch?v=NgFW-3_w_W4
- https://tex.stackexchange.com/questions/140567/drawing-karnaughs-maps-in-latex
- https://uk.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

# todo
- docs
- code
    - add options:
        - variableNumber
        - isVerbose
        - cost : "literal" || "gateInput"
    - find a way to get the index of an implicant in O(1)
- write unit test

- tic toc, diary and statistics
- fare un euristica che cerca tutti gli implicanti necessari piccoli e li mette come don't care nelle funzioni

Aleandro

-> Spiegare cosa indicano i criteri di costo
-> Scrivere la forma generale di un problema di PLI per introdurre i termini (matrice A, vettore x, ecc, ecc)
-> matrice/vettore maiuscolo e elemento di matrice/vettore in minuscolo
-> definire i tipi di implicanti (magari anche qualche esempio), fare teoria sulle mappe di Karnaugh