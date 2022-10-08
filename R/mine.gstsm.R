#' Mine - GSTSM implementation
#'
#' @param object a GSTSM object
#' @return all Solid Ranged Group(s) found, of all sizes
#' @exportS3Method gstsm::mine gstsm
mine.gstsm <- function(object) {
  solid_ranged_groups <- list()

  ck <- generate_candidates(object, NULL)

  object$D <- cbind(object$D, "timestamp" = 1:nrow(object$D)) # nolint
  object$D <- as.matrix(object$D)

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
