#' Merge Kernel Ranged Groups
#'
#' The goal of is to stretch KRGs of the same candidate sequence.
#' Its possible if two KRGs have intersection in space and
#' the resulting KRG keeps its frequency equal to or greater than beta.
#'
#' @param c candidate.
#' @param timestamp current timestamp
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param adjacency_matrix adjacency matrix
#' @return Set of updated KRGs
merge_open_kernel_ranged_groups <- function( # nolint
  c,
  timestamp,
  gamma,
  beta,
  adjacency_matrix
) {

  lines <- nrow(c$rgs$time)

  if (lines < 2) {
    return(c)
  }

  c$rgs$time <- cbind(c$rgs$time, remove = FALSE)

  r_s <- 1
  r_e <- 2
  e_s <- 4
  e_e <- 5
  remove <- 6

  krg_expand_space <- list()
  for (i in 1:lines) {
    positions <- c$rgs$group[[i]]
    if (sum(positions) > 1) {
      krg_expand_space[[i]] <- apply(
        adjacency_matrix[positions, ], 2, max
      ) | positions
    } else {
      krg_expand_space[[i]] <- adjacency_matrix[positions, ] | positions
    }
  }

  mergeable <- TRUE

  while (mergeable) {
    mergeable <- FALSE

    new_time <- matrix(nrow = 0, ncol = 6)
    new_group <- list()
    new_occ <- list()
    new_expand_space <- list()

    n_new_elements <- 0

    to_remove <- NULL

    total_lines <- nrow(c$rgs$time)
    i <- 1
    while (i < total_lines) {
      if (! c$rgs$time[i, remove]) {
        j <- i + 1
        while (j <= total_lines) {
          if (! c$rgs$time[j, remove]) {
            if (sum(krg_expand_space[[i]] & c$rgs$group[[j]]) > 0) {
              if (
                (c$rgs$time[i, e_s] <= c$rgs$time[j, e_e]) &&
                (c$rgs$time[i, e_e] >= c$rgs$time[j, e_s])
              ) {
                n_new_elements <- n_new_elements + 1

                start <- min(c$rgs$time[i, r_s], c$rgs$time[j, r_s])
                end <- max(c$rgs$time[i, r_e], c$rgs$time[j, r_e])
                temporal_group <- c$rgs$group[[i]] | c$rgs$group[[j]]
                new_group[[n_new_elements]] <- temporal_group

                new_occ[[n_new_elements]] <- rbind(
                  c$rgs$occ[[i]],
                  c$rgs$occ[[j]]
                )

                support <- length(unique(new_occ[[n_new_elements]][, 2]))

                frequency <- support / (end - start + 1)
                grow <- support * (frequency / gamma - 1)
                start_expand_time <- start - grow
                end_expand_time <- end + grow + 1

                new_time <- rbind(new_time, c(
                  start,
                  end,
                  frequency,
                  start_expand_time,
                  end_expand_time,
                  FALSE
                ))

                if (sum(temporal_group) > 1) {
                  new_expand_space[[n_new_elements]] <- apply(
                    adjacency_matrix[temporal_group, ], 2, max
                  ) | temporal_group
                } else {
                  new_expand_space[[n_new_elements]] <-
                    adjacency_matrix[temporal_group, ] | temporal_group
                }

                c$rgs$time[i, remove] <- TRUE
                c$rgs$time[j, remove] <- TRUE

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
      c$rgs$time <- c$rgs$time[- to_remove, , drop = FALSE]
      c$rgs$group <- c$rgs$group[- to_remove]
      c$rgs$occ <- c$rgs$occ[- to_remove]

      krg_expand_space <- krg_expand_space[- to_remove]

      c$rgs$time <- rbind(c$rgs$time, new_time)
      c$rgs$group <- append(c$rgs$group, new_group)
      c$rgs$occ <- append(c$rgs$occ, new_occ)

      krg_expand_space <- append(krg_expand_space, new_expand_space)
    }
  }

  c$rgs$time <- c$rgs$time[, -remove, drop = FALSE]

  c <- validate_kernel_ranged_groups(c, timestamp, gamma, beta)

  return(c)
}
