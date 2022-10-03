#' Validate and Close
#'
#' The function receives as input the set of RGs (RG) from a candidate and the
#' minimum size of a group (beta).
#' It starts defining a set of elements that will be removed from the
#' set of RGs, if it does not have the minimum group size.
#'
#' @param c candidate
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @return validated Greedy-Ranged-Groups.
validate_and_close <- function(c, gamma, beta) {
  freq <- 3

  lines_krg <- nrow(c$rgs$time)
  lines_krg_closed <- nrow(c$rgs_closed$time)

  for (i in 1:lines_krg) {
    if (c$rgs$time[i, freq] >= gamma && sum(c$rgs$group[[i]]) >= beta) {
      lines_krg_closed <- lines_krg_closed + 1

      c$rgs_closed$time <- rbind(c$rgs_closed$time, c$rgs$time[i, ])
      c$rgs_closed$group[[lines_krg_closed]] <- c$rgs$group[[i]]
      c$rgs_closed$occ[[lines_krg_closed]] <- c$rgs$occ[[i]]
    }
  }

  c$rgs <- NULL

  return(c)
}
