#' Mine - definition
#'
#' S3 class definition for mine method.
#'
#' @param object a GSTSM object
#' @return all Solid Ranged Group(s) found, of all sizes
#' @export
mine <- function(object) {
  UseMethod("mine", object)
}
