# Sintesi di funzioni booleane multi-uscita mediante programmazione lineare intera

Studio che utilizza l'algoritmo di Quine-McCluskey per enumerare gli implicanti di una rete combinatoria multi uscita e la PLI (Branch & Bound) per trovare la sintesi ottima di essa.

Implementato utilizzando MATLAB e `intlinprog`.

```
project
│   README.md
│   versari_alessandro.pdf    
│
└───src
│   │   displayImplicants.m
│   │   getAllImplicants.m
│   │   synthesisCheck.m
│   │   oneOutputSynteshis.m
│   │   multipleOutputSynthesis.m
│   │   utils.m
│   │
│   └───test
|   |   
│   └───statistics
|   |
│   └───examples
```