#' Base biodev class
#'
#' Initializes a common information required for all docker-based biodev tools.
#'
#' @export
biodev <- R6::R6Class("biodev",
  public = list(
    outdir = ".",
    homedir = NULL,
    voldir = NULL,
    dockerbin = "docker",
    initialize = function(dir = getwd()) {
      self$homedir <- dir
      self$voldir <- paste0(self$homedir, ":", "/home/biodev")
    }
  ))
