<h1 align="center">
  gstsm
</h1>


<!-- badges: start -->
<p align="center">
  <img
    alt="GitHub followers"
    src="https://img.shields.io/github/followers/cefet-rj-dal"
  />
  <img
    alt="GitHub Repo stars"
    src="https://img.shields.io/github/stars/cefet-rj-dal/gstsm?logo=Github"
  />
  <img
    alt="GitHub R package version"
    src="https://img.shields.io/github/r-package/v/cefet-rj-dal/gstsm"
  />
  <img
    alt="CRAN/METACRAN"
    src="https://img.shields.io/cran/l/gstsm"
  />
  <img
    alt="CRAN/METACRAN"
    src="https://img.shields.io/cran/v/gstsm"
  />
</p>
<!-- badges: end -->

<h4 align="center">R package that implements GSTSM</h4>

<p align="center">
  <a href="#about">About</a> •
  <a href="#example">Example</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#credits">Credits</a> •
  <a href="#license">License</a>
</p>

![cefet](https://i.imgur.com/K0E5iFC.jpg)

## About

This R package was made based in the article [Generalização de Mineração de Sequências Restritas no Espaço e no Tempo](https://doi.org/10.5753/sbbd.2021.17891), so its main goal is mining patterns present in spatio-temporal datasets. The R package was developed at CEFET/RJ for academic work.

In the next sections you can check an example of the running code, its documentation, development steps and so on. Please feel free to make contributions and contact in case of bugs/suggestions.

## Example

This example is also present in example folder, just clone it to run it.

```r
library("gstsm")

D <- as.data.frame(matrix(c("B", "B", "A", "C", "A",
                      "C", "B", "C", "A", "B",
                      "C", "C", "A", "C", "A",
                      "B", "B", "D", "A", "B",
                      "B", "D", "D", "B", "D"
), nrow = 5, ncol = 5, byrow=TRUE))

ponto <- c("p1", "p2", "p3", "p4", "p5")
x <- c(1, 2, 3, 4, 5)
y <- c(0, 0, 0, 0, 0)
z <- y
P <- data.frame(ponto=ponto, x=x, y=y, z=z, stringsAsFactors = FALSE)

gamma <- 0.8
beta <- 2
sigma <- 1

gstsm_object <- gstsm(D, P, gamma, beta, sigma)

result <- mine(gstsm_object)
```

## Documentation

Here all the functions are described.

### gstsm

```r
#' GSTSM
#'
#' S3 class definition for GSTSM.
#'
#' This algorithm is designed to the identification of frequent sequences in
#' STS datasets from the concept of Solid Ranged Groups (SRG).
#' GSTSM is based on the candidate-generating principle.
#' The goal is to start finding SRGs for sequences of size one.
#' Then it explores the support and the number of occurrences of SRGs for
#' larger sequences with a limited number of scans over the database.
#'
#' @param sts_dataset STS dataset
#' @param spatial_positions set of spatial positions
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param sigma maximum distance between group points
#' @return a GSTSM object
#' @importFrom stats na.exclude
#' @export gstsm
gstsm <- function(sts_dataset, spatial_positions, gamma, beta, sigma)
```

### find

```r
#' S3 class definition for find method.
#'
#' @param object a GSTSM object
#' @param k size of sequence
#' @param ck set of candidates
#' @return Solid Ranged-Group(s) of all candidate sequences
#' @export find
find <- function(object, ck)
```

### merge

```r
#' S3 class definition for merge method.
#'
#' @param object a GSTSM object
#' @param ck set of candidates
#' @return Solid Ranged-Group(s) of all candidate sequences
#' @export merge
merge <- function(object, ck)
```

### generate_candidates

```r
#' S3 class definition for generate_candidates method.
#'
#' @param object a GSTSM object
#' @param srgk set of Solid Ranged Groups
#' @param k size of sequence
#' @return candidate sequences of size k + 1
#' @export generate_candidates
generate_candidates <- function(object, srgk)
```

### mine

```r
#' S3 class definition for mine method.
#'
#' @param object a GSTSM object
#' @return all Solid Ranged Group(s) found, of all sizes
#' @export mine
mine <- function(object)
```


## Credits

This package was made with the following open source projects:

- [R](https://cran.r-project.org/sources.html)
- [R packages](https://r-pkgs.org/)
- [devtools](https://github.com/r-lib/devtools)
- [roxygen2](https://github.com/r-lib/roxygen2)
- [testthat](https://github.com/r-lib/testthat)
- [knitr](https://github.com/yihui/knitr)


## License

MIT

---

> Antonio Castro • [@castroantonio](https://github.com/castroantonio) <br>
> Cássio Souza • [@cassiofb-dev](https://github.com/cassiofb-dev) <br>
> Jorge Rodrigues • [@jorge-g99](https://github.com/jorge-g99) <br>
> Esther Pacitti • <br>
> Fabio Porto • <br>
> Florent Masseglia • <br>
> Rafaelli Coutinho • [@rafaelliiicoutinho](https://github.com/rafaelliiicoutinho) <br>
> Eduardo Ogasawara • [@eogasawara](https://github.com/eogasawara) <br>

