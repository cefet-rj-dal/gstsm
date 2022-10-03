#' Merge - GSTSM implementation
#'
#' @param object a GSTSM object
#' @param ck set of candidates
#' @return Solid Ranged-Group(s) of all candidate sequences
#' @exportS3Method gstsm::merge gstsm
merge.gstsm <- function(object, ck) {
  srgk <- list()
  lines_srgk <- 0

  for (i in 1:length(ck)) { # nolint
    ck[[i]] <- merge_kernel_ranged_groups(ck[[i]], object$gamma)

    j <- 1
    while (j <= nrow(ck[[i]]$rgs_closed$time)) {
      new_element <- list(
        s = ck[[i]]$seq, r_s = ck[[i]]$rgs_closed$time[j, 1],
        r_e = ck[[i]]$rgs_closed$time[j, 2],
        group = ck[[i]]$rgs_closed$group[[j]],
        occur = ck[[i]]$rgs_closed$occ[[j]]
      )

      lines_srgk <- lines_srgk + 1
      srgk[[lines_srgk]] <- new_element

      j <- j + 1
    }
  }
  return(srgk)
}
