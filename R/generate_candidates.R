#' Generate Candidates - definition
#'
#' S3 class definition for generate_candidates method.
#'
#' @param object a GSTSM object
#' @param srg set of Solid Ranged Groups
#' @return candidate sequences of size k + 1
#' @export
generate_candidates <- function(object, srg) {
  UseMethod("generate_candidates")
}
