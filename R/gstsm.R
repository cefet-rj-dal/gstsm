#' Algorithm 1: G-STSM
#'
#' This section presents the G-STSM. Our algorithm is designed to the
#' identification of frequent sequences in STS datasets from the concept of SRG.
#' The notion of ranged-group (RG, KRG, and SRG) introduced in the previous
#' section enables for extracting SRG efficiently.
#' The G-STSM is based on the candidate-generating principle. Our goal is
#' to start finding SRGs for sequences of size one. Then we explore the support
#' and the number of occurrences of SRGs for larger sequences with a limited
#' number of scans over the database. To this end, we need to find the range and
#' the set of positions (i. e., the SRG) in which a candidate sequence is
#' frequent in only one scan.
#'
#' @param sts_dataset STS dataset
#' @param spatial_positions set of spatial positions
#' @param gamma minimum temporal frequency
#' @param beta minimum group size
#' @param sigma max distance between group points
#' @return Solid-Raged-Groups.
#' @examples
#' library("gstsm")
#' events_data_path <-
#'   system.file("extdata", "made_bangu_6x30.txt", package = "gstsm")
#'
#' space_time_data_path <-
#'   system.file("extdata", "positions_2D_30.txt", package = "gstsm")
#'
#' d <- read.table(
#'   events_data_path,
#'   header = FALSE,
#'   sep = " ",
#'   dec = ".",
#'   as.is = TRUE,
#'   stringsAsFactors = FALSE
#' )
#'
#' p <- read.table(
#'   space_time_data_path,
#'   header = TRUE,
#'   sep = " ",
#'   dec = ".",
#'   as.is = TRUE,
#'   stringsAsFactors = FALSE
#' )
#'
#' gamma <- 0.8
#' beta <- 2
#' sigma <- 1
#'
#' result <- gstsm::gstsm(d, p, gamma, beta, sigma)
#' @importFrom stats na.exclude
#' @export
gstsm <- function(sts_dataset, spatial_positions, gamma, beta, sigma) { # nolint

  solid_ranged_groups <- list()

  items <- stats::na.exclude(unique(unlist(sts_dataset)))
  sts_dataset <- cbind(sts_dataset, "timestamp" = 1:nrow(sts_dataset)) # nolint
  sts_dataset <- as.matrix(sts_dataset)

  adjacency_matrix <- gstsm::generate_adjacency_matrix(spatial_positions, sigma)

  lines <- nrow(sts_dataset)

  pos <- c(rep(TRUE, nrow(spatial_positions)))

  time <- matrix(nrow = 0, ncol = 5)
  colnames(time) <- c("r_s", "r_e", "freq", "e_s", "e_e")

  rg <- list(time = time, group = list(), occ = list())

  ck <- list()

  nr_elements <- length(items)
  for (i in 1:nr_elements) {
    new_element <- list(
      seq = items[i],
      range_s = 1,
      range_e = lines,
      pos = pos,
      rgs = rg,
      rgs_closed = rg
    )
    ck[[i]] <- new_element
  }

  k <- 0

  repeat {
    k <- k + 1
    srgk <- list()

    end <- nrow(sts_dataset) - k + 1
    for (i in 1:end) {
      d <- sts_dataset[i:(i + k - 1), , drop = FALSE]
      for (j in 1:length(ck)) { # nolint
        ck[[j]] <- find_kernel_ranged_group(
          ck[[j]],
          d,
          gamma,
          beta,
          adjacency_matrix
        )
      }
    }

    lines_srgk <- 0

    for (i in 1:length(ck)) { # nolint
      if (nrow(ck[[i]]$rgs$time) > 0) {
        ck[[i]] <- gstsm::validate_and_close(ck[[i]], gamma, beta)
      }

      ck[[i]] <- gstsm::merge_kernel_ranged_groups(ck[[i]], gamma)

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

    if (length(srgk) <= 0) {
      k <- k - 1
      break
    }

    solid_ranged_groups[[k]] <- srgk

    ck <- gstsm::generate_candidates(srgk, k, beta)

    if (is.null(ck) || length(ck) <= 0 || k >= nrow(sts_dataset)) {
      break
    }
  }
  return(solid_ranged_groups)
}