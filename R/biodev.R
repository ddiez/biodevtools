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
    image = NULL,
    id = NULL,
    initialize = function(image = NULL, dir = getwd(), docker.path = NULL, seed = NULL) {
      self$image <- image
      self$id <- private$unique_id(seed = seed)

      if (!is.null(docker.path))
        self$dockerbin = file.path(docker.path, self$dockerbin)

      if (Sys.which(self$dockerbin) == "")
        stop("the docker binary cannot be found; provide the correct location.")

      self$homedir <- dir
      self$voldir <- paste0(self$homedir, ":", "/home/biodev")
    },
    finalize = function() {
      # stops container and removes it.
      print("finalizer called")
      private$clean_container()
    }
  ),
  private = list(
    norm_path = function(file, container.dir = "/tmp", bind.dir = ".") {
      file <- normalizePath(file, mustWork = FALSE)
      dir <- dirname(file)
      file <- file.path(container.dir, bind.dir, basename(file))
      vol <- paste0(dir, ":", file.path(container.dir, bind.dir))
      list(file = file, volume = vol)
    },

    unique_id = function(seed = NULL) {
      if (! is.null(seed))
        digest::sha1(seed)
      else
        digest::sha1(runif(1))
    },

    clean_container = function() {
      args <- paste("container stop", self$id)
      system2(self$dockerbin, args)

      args <- paste("container rm", self$id)
      system2(self$dockerbin, args)
    }
  ))
