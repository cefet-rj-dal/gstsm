#' Find Kernel Ranged Group
#'
#' The goal is to find the Kernel Ranged Group information for a candidate c.
#'
#' @param c candidate
#' @param d set of transactions
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param adjacency_matrix adjacency matrix
#' @return Kernel Ranged-Group(s) of c updated
find_kernel_ranged_group <- function(c, d, gamma, beta, adjacency_matrix) {
  rows <- nrow(d)
  columns <- ncol(d) - 1
  timestamp <- strtoi(d[1, columns + 1])

  if (
    c$range_s > strtoi(d[rows, columns + 1]) ||
    c$range_e < strtoi(d[1, columns + 1])
  ) {
    return(c)
  }

  pos <- c$pos

  i <- 1
  while (sum(pos) > 0 && i <= rows) {
    p <- c(d[i, 1:columns] == substr(c$seq, i, i))
    pos <- pos & p
    i <- i + 1
  }

  if (sum(pos) > 0) {
    groups <- split_groups(pos, adjacency_matrix)

    r_s <- timestamp
    r_e <- timestamp

    freq <- 1
    cresce <- 1 / gamma - 1

    e_s <- r_s - cresce
    e_e <- r_e + cresce + 1

    rows <- length(c$rgs$group)

    for (i in 1:length(groups)) { # nolint
      c$rgs$time <- rbind(c$rgs$time, c(r_s, r_e, freq, e_s, e_e))
      c$rgs$group[[rows + i]] <- groups[[i]]

      occurrences <- matrix(nrow = 0, ncol = 2)
      colnames(occurrences) <- c("x", "y")
      for (j in which(groups[[i]])) {
        occurrences <- rbind(occurrences, c(j, timestamp))
      }
      c$rgs$occ[[rows + i]] <- occurrences
    }

    c <- merge_open_kernel_ranged_groups(
      c,
      timestamp,
      gamma,
      beta,
      adjacency_matrix
    )
  }
  return(c)
}
