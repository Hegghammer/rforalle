# rforalle: Download code and data for the book *R for alle*

This is a simple package designed to make it easy for beginners to download example data and code used in the book *R for alle* (Oslo: Fagbokforlaget, 2024). The source material resides in [another repository](https://github.com/Hegghammer/rbok) due to the size of some of the files. You may also clone that repository to get everything in one operation. 

## Use

Download a data file:

```R
hent_data("kap13_test.bib")
```

Download a code file: 

```R
hent_kode("kap05.R")
```

See which files are available:

```R
hent_oversikt("data")
hent_oversikt("kode")
hent_oversikt("alle")
```

## Installation

Install the latest development version from Github:

```R
devtools::install_github("hegghammer/rforalle")
```

## Code of conduct

Please note that the daiR project is released with a [Contributor Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/). By contributing to this project, you agree to abide by its terms.
