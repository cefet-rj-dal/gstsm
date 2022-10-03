#' Generate Candidates - definition
#'
#' S3 class definition for generate_candidates method.
#'
#' @param object a GSTSM object
#' @param srgk set of Solid Ranged Groups
#' @return candidate sequences of size k + 1
#' @export
generate_candidates <- function(object, srgk) {
  UseMethod("generate_candidates")
}
