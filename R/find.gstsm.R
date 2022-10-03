#' Find - GSTSM implementation
#'
#' GSTSM implementationfor for find method. Does nothing.
#' The goal is to find the Ranged Groups information for a candidate c.
#'
#' @param object a GSTSM object
#' @param ck set of candidates
#' @return Solid Ranged-Group(s) of all candidate sequences
#' @exportS3Method gstsm::find gstsm
find.gstsm <- function(object, ck) {
  k <- nchar(ck[[1]]$seq)
  end <- nrow(object$D) - k + 1
  for (i in 1:end) {
    d <- object$D[i:(i + k - 1), , drop = FALSE]
    for (j in 1:length(ck)) { # nolint
      ck[[j]] <- find_kernel_ranged_group(
        ck[[j]],
        d,
        object$gamma,
        object$beta,
        object$adjacency_matrix
      )
    }
  }
  for (i in 1:length(ck)) { # nolint
    if (nrow(ck[[i]]$rgs$time) > 0) {
      ck[[i]] <- validate_and_close(ck[[i]], object$gamma, object$beta)
    }
  }
  return(ck)
}
