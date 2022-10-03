#' GSTSM
#'
#' S3 class definition for GSTSM.
#'
#' This algorithm is designed to the identification of frequent sequences in
#' STS datasets from the concept of Solid Ranged Groups (SRG).
#' GSTSM is based on the candidate-generating principle.
#' The goal is to start finding SRGs for sequences of size one.
#' Then it explores the support and the number of occurrences of SRGs for
#' larger sequences with a limited number of scans over the database.
#'
#' @param sts_dataset STS dataset
#' @param spatial_positions set of spatial positions
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param sigma maximum distance between group points
#' @return a GSTSM object
#' @examples
#' library("gstsm")
#'
#' D <- as.data.frame(matrix(c("B", "B", "A", "C", "A",
#'               "C", "B", "C", "A", "B",
#'               "C", "C", "A", "C", "A",
#'               "B", "B", "D", "A", "B",
#'               "B", "D", "D", "B", "D"
#'             ), nrow = 5, ncol = 5, byrow = TRUE))
#'
#' ponto <- c("p1", "p2", "p3", "p4", "p5")
#' x <- c(1, 2, 3, 4, 5)
#' y <- c(0, 0, 0, 0, 0)
#' z <- y
#' P <- data.frame(ponto=ponto, x=x, y=y, z=z, stringsAsFactors = FALSE)
#'
#' gamma <- 0.8
#' beta <- 2
#' sigma <- 1
#'
#' gstsm_object <- gstsm(D, P, gamma, beta, sigma)
#'
#' result <- mine(gstsm_object)
#'
#' @importFrom stats na.exclude
#' @export
gstsm <- function(sts_dataset, spatial_positions, gamma, beta, sigma) { # nolint

  adjacency_matrix <- generate_adjacency_matrix(spatial_positions, sigma)

  object <- list(D=sts_dataset,
                 P=spatial_positions,
                 gamma=gamma,
                 beta=beta,
                 sigma=sigma,
                 adjacency_matrix=adjacency_matrix)

  attr(object, "class") <- "gstsm"

  return(object)
}
