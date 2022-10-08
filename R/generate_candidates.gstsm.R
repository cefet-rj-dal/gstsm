#' Generate Candidates - GSTSM implementation
#'
#' The algorithm combines SRGs that have sequences of size k, received as
#' input, to generate candidates with sequences of size k + 1. Let x and y be
#' SRGs, the conditions for this to occur are: that we have an
#' intersection of candidates over the time range,
#' intersection over the set of spatial positions (x.g n y.g), and
#' a common subsequence: <x.s2, . . . , x.sk>=<y.s1, . . . , y.sk-1>.
#'
#' @param object a GSTSM object
#' @param srg set of Solid Ranged Groups
#' @return candidate sequences of size k + 1
#' @exportS3Method gstsm::generate_candidates gstsm
generate_candidates.gstsm <- function(object, srg) {
  if (is.null(srg)) {
    ck <- list()

    items <- stats::na.exclude(unique(unlist(object$D)))

    time <- matrix(nrow = 0, ncol = 5)
    colnames(time) <- c("r_s", "r_e", "freq", "e_s", "e_e")

    lines <- nrow(object$D)

    rg <- list(time = time, group = list(), occ = list())

    pos <- c(rep(TRUE, nrow(object$P)))

    nr_elements <- length(items)
    for (i in 1:nr_elements) {
      new_element <- list(
        seq = items[i],
        range_s = 1,
        range_e = lines,
        pos = pos,
        rgs = rg,
        rgs_closed = rg
      )
      ck[[i]] <- new_element
    }
    return(ck)
  }

  lines <- length(srg)

  if (lines <= 0) {
    return(srg)
  }

  k <- nchar(srg[[1]]$s)

  n_new_elements <- 0

  time <- matrix(nrow = 0, ncol = 5)
  colnames(time) <- c("r_s", "r_e", "freq", "e_s", "e_e")

  rg <- list(time = time, group = list(), occ = list())

  ck <- list()

  i <- 1
  while (i <= lines) {
    j <- 1
    while (j <= lines) {
      if (
        (srg[[i]]$r_s < srg[[j]]$r_e) &&
        ((srg[[i]]$r_e + 1) >=
         srg[[j]]$r_s)
      ) {
        if (
          sum(
            srg[[i]]$group & srg[[j]]$group) >= object$beta
        ) {
          if (
            substr(srg[[i]]$s, 2, k) == substr(srg[[j]]$s, 1, k - 1)
          ) {
            seq <- paste0(srg[[i]]$s, substr(srg[[j]]$s, k, k))

            range_s <- max(srg[[i]]$r_s, (srg[[j]]$r_s - 1))
            range_e <- min(srg[[i]]$r_e, (srg[[j]]$r_e - 1))

            pos <- srg[[i]]$group & srg[[j]]$group

            new <- list(
              seq = seq,
              range_s = range_s,
              range_e = range_e,
              pos = pos,
              rgs = rg,
              rgs_closed = rg
            )

            n_new_elements <- n_new_elements + 1

            ck[[n_new_elements]] <- new
          }
        }
      }
      j <- j + 1
    }
    i <- i + 1
  }
  return(ck)
}
