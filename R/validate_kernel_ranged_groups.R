#' Validate Kernel Ranged Groups
#'
#' Its objective is to verify that the user thresholds were observed
#' in each RGs, checking if they can still be stretched by keeping
#' the frequency greater than or equal to the minimum gamma and if
#' the minimum group size beta occurs.
#' It takes as input a set of RGs RG of a candidate sequence, the timestamp
#' of the start of the current sliding window timestamp, the user-defined
#' thresholds gamma and beta.
#'
#' @param c candidate
#' @param timestamp current timestamp
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @return Validated Kernel-Ranged-Groups.
validate_kernel_ranged_groups <- function(c, timestamp, gamma, beta) {
  r_s <- 1

  freq <- 3

  lines_grg <- nrow(c$rgs$time)
  lines_grg_closed <- nrow(c$rgs_closed$time)
  to_remove <- NULL

  for (i in 1:lines_grg) {
    sup <- length(unique(c$rgs$occ[[i]][, 2]))
    freq <- sup / (timestamp - (c$rgs$time[i, r_s]) + 1)
    if (freq < gamma) {
      if (sum(c$rgs$group[[i]]) >= beta) {
        lines_grg_closed <- lines_grg_closed + 1

        c$rgs_closed$time <- rbind(c$rgs_closed$time, c$rgs$time[i, ])
        c$rgs_closed$group[[lines_grg_closed]] <- c$rgs$group[[i]]
        c$rgs_closed$occ[[lines_grg_closed]] <- c$rgs$occ[[i]]
      }
      to_remove <- append(to_remove, i)
    }
  }

  if (! is.null(to_remove)) {
    c$rgs$time <- c$rgs$time[-to_remove, , drop = FALSE]
    c$rgs$group <- c$rgs$group[-to_remove]
    c$rgs$occ <- c$rgs$occ[-to_remove]
  }

  return(c)
}
