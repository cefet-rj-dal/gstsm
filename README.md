<h1 align="center">
  gstsm Package
</h1>

<h4 align="center">
  R package that implements the algorithms present in the article<br>
  Generalized Discovery of Tight Space-Time Sequences
</h4>

<p align="center">
  <a href="#about">About</a> •
  <a href="#example">Example</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#development">Development</a> •
  <a href="#credits">Credits</a> •
  <a href="#license">License</a>
</p>

![cefet](https://i.imgur.com/K0E5iFC.jpg)

## About

This R package was made based in the article Generalized Discovery of Tight Space-Time,
so its main goal is mining patterns present in spatio-temporal sequences. The R package was
Developed at CEFET/RJ for an academic work.

In the next sections you can check an example of the running code, its documentation,
development steps and so on. Please feel free to make contributions and contact in case of
bugs/suggestions.

## Example

This example is also present in example folder, just clone it to run it.

```r
library("gstsm")

d <- read.table(
  "made_bangu_6x30.txt",
  header = FALSE,
  sep = " ",
  dec = ".",
  as.is = TRUE,
  stringsAsFactors = FALSE
)

p <- read.table(
  "positions_2D_30.txt",
  header = TRUE,
  sep = " ",
  dec = ".",
  as.is = TRUE,
  stringsAsFactors = FALSE
)

plot(
  p$x,
  p$y,
  main = "positions",
  xlab = "",
  ylab = "",
  col = "blue",
  pch = 19,
  cex = 1,
  lty = "solid",
  lwd = 2
)

text(
  p$x,
  p$y,
  labels = p$points,
  cex = 0.7,
  pos = 3
)

gamma <- 0.8
beta <- 2
sigma <- 1

calculated_groups <- new.env(hash = TRUE)

result <- gstsm::gstsm(d, p, gamma, beta, sigma)

```

## Documentation

Here all the functions are described.

### gstsm

```r
#' Algorithm 1: G-STSM
#'
#' This section presents the G-STSM. Our algorithm is designed to the iden-
#' tification of frequent sequences in STS datasets from the concept of SRG.
#' The notion of ranged-group (RG, KRG, and SRG) introduced in the previous
#' section enables for extracting SRG efficiently.
#' The G-STSM is based on the candidate-generating principle. Our goal is
#' to start finding SRGs for sequences of size one. Then we explore the support
#' and the number of occurrences of SRGs for larger sequences with a limited
#' number of scans over the database. To this end, we need to find the range and
#' the set of positions (i. e., the SRG) in which a candidate sequence is
#' frequent in only one scan.
#'
#' @param sts_dataset STS dataset
#' @param spatial_positions set of spatial positions
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param sigma max distance between group points
#' @return Solid-Raged-Groups.
#' @importFrom stats na.exclude
#' @export
gstsm <- function(sts_dataset, spatial_positions, gamma, beta, sigma)
```

### validate_and_close

```r
#' Algorithm 2: Validate and Close
#'
#' The validateGroup function is shown in Algorithm 2. It receives as input
#' the set of RGs (RG) from a candidate and the minimum size of a group (beta).
#' It starts defining a set of elements that will be removed (toRemove) from the
#' set of RGs (line 2), if it does not have the minimum group size.
#'
#' @param c candidate
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @return validated Greedy-Ranged-Groups.
#' @export
validate_and_close <- function(c, gamma, beta)
```

### find_kernel_ranged_group

```r
#' Algorithm 3: Find Kernel Ranged Group
#'
#' The goal of Algorithm 3 is to find the KRG information for a candidate c
#' It receives as input a candidate c, the set of transactions d from a sliding
#' window of SW, and the thresholds defined by the user (gamma, beta and sigma).
#'
#' @param c candidate
#' @param d set of transactions
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param adjacency_matrix adjacency matrix
#' @return Kernel Ranged-Group(s) of c updated
#' @export
find_kernel_ranged_group <- function(c, d, gamma, beta, adjacency_matrix)
```

### validate_kernel_ranged_groups

```r
#' Algorithm 4: Validate Kernel Ranged Groups
#'
#' Its objective is to verify that the user thresholds were observed
#' in each RGs, checking if they can still be stretched by keeping
#' the frequency greater than or equal to the minimum gamma and if
#' the minimum group size beta occurs. It takes as input
#' a set of RGs RG of a candidate sequence, the timestamp of the start
#' of the current sliding window timestamp,
#' the user-defined thresholds gamma and beta.
#'
#' @param c candidate
#' @param timestamp current timestamp
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @return Validated Kernel-Ranged-Groups.
#' @export
validate_kernel_ranged_groups <- function(c, timestamp, gamma, beta)
```

### merge_kernel_ranged_groups

```r
#' Algorithm 5: Merge Kernel Ranged Groups
#'
#' The goal of the Algorithm 5 is to merge KRGs. Let q and u be two different
#' KRGs from the same candidate sequence. They can be merged into a group
#' qu = q U u as long as they have an intersection and qu has
#' a frequency greater than or equal to the minimum frequency defined by
#' the user.
#'
#' @param c candidate
#' @param gamma minimum temporal frequency
#' @return KRG
#' @export
merge_kernel_ranged_groups <- function(c, gamma)
```

### generate_candidates

```r
#' Algorithm 6: Generate Candidates
#'
#' The algorithm combines SRGs that have sequences of size k, received as
#' input, to generate candidates with sequences of size k + 1. Let x and y be
#' SRGs, the conditions for this to occur are (line 3): that we have an inter
#' section of candidates over the time range,
#' intersec tion over the set of spatial positions (x.g n y.g), and
#' a common subsequence: <x.s2, . . . , x.sk>=<y.s1, . . . , y.sk-1>.
#'
#' @param srg Solid-Ranged-Groups
#' @param k sequence size
#' @param beta minimum group size
#' @return Ck+1 set of candidates having length k + 1
#' @export
generate_candidates <- function(srg, k, beta)
```

### merge_open_kernel_ranged_groups

```r
#' Algorithm 7: Merge Kernel Ranged Groups
#'
#' The goal of the Algorithm 7 is to stretch KRGs of the same
#' candidate sequence. Its possible if two KRGs have intersection in space and
#' the resulting KRG keeps its frequency equal to or greater than beta.
#'
#' @param c candidate.
#' @param timestamp current timestamp
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param adjacency_matrix adjacency matrix
#' @return Set of updated KRGs
#' @export
merge_open_kernel_ranged_groups <- function( # nolint
  c,
  timestamp,
  gamma,
  beta,
  adjacency_matrix
)
```

### generate_adjacency_matrix

```r
#' Generate Adjacency Matrix
#'
#' Helper function that generates an adjacency matrix
#'
#' @param spatial_positions set of spatial positions
#' @param sigma max distance between group points
#' @return Adjacency Matrix
#' @export
generate_adjacency_matrix <- function(spatial_positions, sigma)
```

### split_groups

```r
#' Split Groups
#'
#' Helper function that split groups
#'
#' @param pos sequency ocurrence index
#' @param adjacency_matrix possible connection between positions
#' @return new set based on candidate c found in d.
#' @importFrom digest digest
#' @export
split_groups <- function(pos, adjacency_matrix)
```

## Development

This package was built based on the book [R Packages](https://r-pkgs.org/index.html)
following this steps:

### 0: Learning about R and packages

First of all, it was necessary to understand the R language and the R package
general structure and development workflow. Thanks to the book and online
lessons made by the teacher Eduardo Ogasawara it was not hard to finish this step.

### 1: Check name availability

It is essential to choose the right name and besides being short a
couple of tests should be done to check if the name is available not only on
cran but on the general internet.

For this, it is used a R package called available. This package checks the name
in some sites and search for online definitions. After all check passed it is
sure the name is nice choice.

### 2: Reading the article

Of course to built the package it was necessary some basic understanding
about the article and a great understanding how its algorithms worked.
After learning all this it was possible to think in how to structure the package.

### 3: R code

In This step all the algorithms were divided, adaptaded and put on R folder.
After this was done it was possible to start using the package.

### 4: Documentation

The article was read once more to make sure that all the code documentation
matched its counterpart in the article. With the documentation completed on
R code with the help of devtools all the files on man folder were made.

### 5: Metadata

With the code and documentation done, the focus was changed to package metadata like
description, authors, license and so on.

### 6: Checking

Last but not least, the package was tested with devtools. It is important to notice
that the checking is the most essential step and besides being the final step, it was
done in all previous step as devtools check has a lot of tests to catch errors.

## Credits

This package was made with the following open source projects:

- [R](https://cran.r-project.org/sources.html)
- [devtools](https://github.com/r-lib/devtools)
- [roxygen2](https://github.com/r-lib/roxygen2)

Special thanks to teacher Eduardo Ogasawara for the orientation and
Antonio Castro for the article.

## License

MIT

---

> Antonio Castro • [@castroantonio](https://github.com/castroantonio) <br>
> Cássio Souza • [@cassiofb-dev](https://github.com/cassiofb-dev) <br>
> Eduardo Ogasawara • [@eogasawara](https://github.com/eogasawara) <br>
> Jorge Rodrigues • [@jorge-g99](https://github.com/jorge-g99)
