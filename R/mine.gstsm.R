#' Mine - GSTSM implementation
#'
#' @param object a GSTSM object
#' @return all Solid Ranged Group(s) found, of all sizes
#' @exportS3Method gstsm::mine gstsm
mine.gstsm <- function(object) {
  solid_ranged_groups <- list()

  items <- stats::na.exclude(unique(unlist(object$D)))
  object$D <- cbind(object$D, "timestamp" = 1:nrow(object$D)) # nolint
  object$D <- as.matrix(object$D)

  lines <- nrow(object$D)

  pos <- c(rep(TRUE, nrow(object$P)))

  time <- matrix(nrow = 0, ncol = 5)
  colnames(time) <- c("r_s", "r_e", "freq", "e_s", "e_e")

  rg <- list(time = time, group = list(), occ = list())

  ck <- list()

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

  k <- 0

  repeat {
    k <- k + 1

    ## Find
    ck <- find(object, ck)

    ## Merge
    srgk <- merge(object, ck)

    if (length(srgk) <= 0) {
      k <- k - 1
      break
    }

    solid_ranged_groups[[k]] <- srgk

    ck <- generate_candidates(object, srgk)

    if (is.null(ck) || length(ck) <= 0 || k >= nrow(object$D)) {
      break
    }
  }
  return(solid_ranged_groups)
}
