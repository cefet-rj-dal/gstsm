#' Merge - definition
#'
#' S3 class definition for merge method.
#'
#' @param object a GSTSM object
#' @param ck set of candidates
#' @return Solid Ranged-Group(s) of all candidate sequences
#' @export
merge <- function(object, ck) {
  UseMethod("merge")
}
