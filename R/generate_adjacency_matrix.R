#' Generate Adjacency Matrix
#'
#' Helper function that generates an adjacency matrix.
#'
#' @param spatial_positions set of spatial positions
#' @param sigma max distance between group points
#' @return Adjacency Matrix
generate_adjacency_matrix <- function(spatial_positions, sigma) {
  colnames(spatial_positions) <- c("ponto", "x", "y", "z")

  lines <- nrow(spatial_positions)

  adjacency_matrix <- matrix(FALSE, nrow = lines, ncol = lines)

  for (i in 1:lines) {
    for (j in 1:lines) {
      if (i != j) {
        distance <- sqrt(
          (spatial_positions$x[i] - spatial_positions$x[j])^2 +
            (spatial_positions$y[i] - spatial_positions$y[j])^2 +
            (spatial_positions$z[i] - spatial_positions$z[j])^2
        )
        if (distance <= sigma) {
          adjacency_matrix[i, j] <- TRUE
          adjacency_matrix[j, i] <- TRUE
        }
      }
    }
  }
  return(adjacency_matrix)
}
