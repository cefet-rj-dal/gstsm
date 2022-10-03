#' Merge Kernel Ranged Groups
#'
#' The goal is to merge KRGs.
#' Let q and u be two different KRGs from the same candidate sequence.
#' They can be merged into a group qu = q U u as long as they have an
#' intersection and qu has a frequency greater than or equal to the minimum
#' frequency defined by the user.
#'
#' @param c candidate
#' @param gamma minimum temporal frequency
#' @return KRG
merge_kernel_ranged_groups <- function(c, gamma) { # nolint
  lines <- nrow(c$rgs_closed$time)

  if (lines < 2) {
    return(c)
  }

  c$rgs_closed$time <- cbind(c$rgs_closed$time, remove = FALSE)

  r_s <- 1
  r_e <- 2
  e_s <- 4
  e_e <- 5
  remove <- 6

  mergeable <- TRUE

  while (mergeable) {
    mergeable <- FALSE

    new_grg <- matrix(nrow = 0, ncol = 6)
    new_group <- list()
    new_occ <- list()

    n_new_elements <- 0

    to_remove <- NULL

    total_lines <- nrow(c$rgs_closed$time)
    i <- 1
    while (i < total_lines) {
      if (!c$rgs_closed$time[i, remove]) {
        j <- i + 1
        while (j <= total_lines) {
          if (!c$rgs_closed$time[j, remove]) {
            if (
              (c$rgs_closed$time[i, e_s] <= c$rgs_closed$time[j, e_e]) &&
                (c$rgs_closed$time[i, e_e] >= c$rgs_closed$time[j, e_s])
            ) {
              if (
                sum(c$rgs_closed$group[[i]] & c$rgs_closed$group[[j]]) > 0
              ) {
                n_new_elements <- n_new_elements + 1

                start <- min(
                  c$rgs_closed$time[i, r_s],
                  c$rgs_closed$time[j, r_s]
                )

                end <- max(
                  c$rgs_closed$time[i, r_e],
                  c$rgs_closed$time[j, r_e]
                )

                new_group[[n_new_elements]] <-
                  c$rgs_closed$group[[i]] | c$rgs_closed$group[[j]]

                new_occ[[n_new_elements]] <- rbind(
                  c$rgs_closed$occ[[i]],
                  c$rgs_closed$occ[[j]]
                )

                support <- length(unique(new_occ[[n_new_elements]][, 2]))
                frequency <- support / (end - start + 1)
                grow <- support * (frequency / gamma - 1)
                start_exp_time <- start - grow
                end_exp_time <- end + grow + 1

                new_grg <- rbind(
                  new_grg,
                  c(
                    start,
                    end,
                    frequency,
                    start_exp_time,
                    end_exp_time,
                    FALSE
                  )
                )

                c$rgs_closed$time[i, remove] <- TRUE
                c$rgs_closed$time[j, remove] <- TRUE

                to_remove <- append(to_remove, c(i, j))

                mergeable <- TRUE

                break
              }
            }
          }
          j <- j + 1
        }
      }
      i <- i + 1
    }

    if (n_new_elements > 0) {
      c$rgs_closed$time <- c$rgs_closed$time[-to_remove, , drop = FALSE]
      c$rgs_closed$group <- c$rgs_closed$group[-to_remove]
      c$rgs_closed$occ <- c$rgs_closed$occ[-to_remove]

      c$rgs_closed$time <- rbind(c$rgs_closed$time, new_grg)
      c$rgs_closed$group <- append(c$rgs_closed$group, new_group)
      c$rgs_closed$occ <- append(c$rgs_closed$occ, new_occ)
    }
  }

  c$rgs_closed$time <- c$rgs_closed$time[, -remove, drop = FALSE]

  return(c)
}
