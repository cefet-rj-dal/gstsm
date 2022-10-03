#' Split Groups
#'
#' Helper function that splits groups.
#'
#' @param pos sequence occurrence index
#' @param adjacency_matrix possible connection between positions
#' @return new set based on candidate c found in d.
#' @importFrom digest digest
split_groups <- function(pos, adjacency_matrix) {
  key <- digest::digest(pos, algo = "xxhash64")

  calculated <- calculated_groups[[key]]
  if (!is.null(calculated)) {
    return(calculated)
  }

  new_calculated_groups <- list()
  n_elements <- nrow(adjacency_matrix)
  line <- 0

  while (sum(pos) > 0) {
    new_group <- c(rep(FALSE, n_elements))

    indexes <- which(pos == TRUE)

    new_group[indexes[1]] <- TRUE

    indexes <- indexes[-1]

    i <- 1
    while (!is.na(which(new_group == TRUE)[i])) {
      j <- 1
      while (!is.na(indexes[j])) {
        if (sum(new_group & adjacency_matrix[indexes[j], ]) > 0) {
          new_group[indexes[j]] <- TRUE
          indexes <- indexes[-j]
        } else {
          j <- j + 1
        }
      }
      i <- i + 1
    }
    pos <- pos & !new_group

    line <- line + 1

    new_calculated_groups[[line]] <- new_group
  }

  calculated_groups[[key]] <- new_calculated_groups

  return(new_calculated_groups)
}
