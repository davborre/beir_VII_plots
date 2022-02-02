# BEIR VII plots

## Table of contents ##

- [ERR and EAR models](#err-and-ear-models)
- [Scripts, functions, and files](#scripts-functions-and-files)
- [Dependencies](#dependencies)
- [References](#references)


## ERR and EAR models ##

## Scripts, functions, and files

```
$ tree

.
├── ERR_EAR_parameters.mat
├── README.md
├── README.md~
├── beir_analysis.m
├── figures
│   ├── *.eps
│   ├── *.png
│   ├── *.svg
│   ├── BEIR_VII_Figure_12_1A.pdf
│   └── BEIR_VII_Figure_12_1A.png
├── linear_plotter.m
├── linear_plotter.m~
└── risk_model.m
```
1. `ERR_EAR_parameters.mat` - Contains risk model parameters. Values match those listed in BEIR VII Pg. XX 
2. `beir_analysis.m` - Main script. Makes calls to `linear_plotter.m` and `risk_model.m` functions
3. `risk_model.m` - ERR and EAR general model. Creates array of ERR and EAR as a function of attained age. 
4. `linear_plotter.m` - function to generate plots using gramm plotting toolbox. 

## Dependencies ##

1. Gramm plotting toolbox for Matlab

    [![DOI](http://joss.theoj.org/papers/10.21105/joss.00568/status.svg)](https://doi.org/10.21105/joss.00568)

    Morel, (2018). Gramm: grammar of graphics plotting in Matlab. Journal of Open Source Software, 3(23), 568, https://doi.org/10.21105/joss.00568
    
## References ##

1. BEIR VII
