#' Find - definition
#'
#' S3 class definition for find method.
#'
#' @param object a GSTSM object
#' @param ck set of candidates
#' @return Solid Ranged-Group(s) of all candidate sequences
#' @export
find <- function(object, ck) {
  UseMethod("find")
}
