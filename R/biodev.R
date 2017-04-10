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
    initialize = function(dir = getwd(), docker.path = NULL) {
      if (!is.null(docker.path))
        self$dockerbin = file.path(docker.path, self$dockerbin)

      if (Sys.which(self$dockerbin) == "")
        stop("the docker binary cannot be found; provide the correct location.")

      self$homedir <- dir
      self$voldir <- paste0(self$homedir, ":", "/home/biodev")
    }
  ))
