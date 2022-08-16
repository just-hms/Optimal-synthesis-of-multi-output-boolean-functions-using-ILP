Bachelor degree thesis that succeeds in finding the optimal solution to the problem of the synthesize of a given multi-output boolean function.

It uses the Quine-McCluskey algorithm to enumerate the implicants of the function and find its optimal synthesis using Branch & Bound (PLI).

Implemented using MATLAB and `intlinprog`.

All theory behind the code is explained inside the `📂docs` folder, in italian.

# Usage

There are some examples which illustrate how to use all the functions provided by this repo. 

`check.m` shows how to use the function `synthesisCheck` to check wheter or not a synthesis of a boolean function is correct.

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
|	|	📜distribution.m
|	|	📜statistics.m
|	|	📜plotStatistics.m
|	|
|	|	📜statistics.sh
|	|	📜input_statistics.sh
|	|
|	└───📂out
|
└───📂test
		📜randomTest.m

```


## 📂docs

Folder containing the documentation of this project.

## 📂examples

Inside this folder you can find examples that have been described inside the study and some other examples to better understand some functionality provided by this repo.

## 📂src

Folder that contains the source code.

## 📂statistics

Inside this folder there are all the functions used to generate the tests' input and to plot their result.

The `.sh` scrips invoke `statistics.m` passing the folling values as a parameter:
- number of inputs
- number of outputs
- number of the last executed test

#### 📂out 

In this folder there are all the result obtained from the tests.

File name format : `inputs-outputs.txt`

File content format :  

```
index oneOutputCost multipleOutputCost timeOfExecution
1 65 61 1.188256
2 84 81 0.359309
3 152 137 0.186701
4 58 54 0.116115
```

## 📂test

Folder containing test scripts which use the `synthesisCheck` function to check if the synthesis are done correctly.
