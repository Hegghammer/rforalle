#' Get a data file
#'
#' @description Downloads a specified file from the `data` directory of the source repository. A wrapper for \code{hent_fil()}. The filename must be among those returned by \code{hent_oversikt('data')}.
#'
#' @param file string; basename of a file
#' @param full logical; whether to save as is or trim the "kapXX_" prefix upon saving.
#' @param destdir string; path to the download directory.
#'
#' @return no return value, called for side effects
#' @export
#'
#' @examples
#' \dontrun{
#' hent_data("kap13_test.bib")
#'
#' hent_data(hent_oversikt("data")[1], full = TRUE, destdir = tempdir())
#'
#' datafiler <- hent_oversikt("data")
#' for (i in datafiler) {hent_data(i)}
#' }

hent_data <- function(file, full = FALSE, destdir = getwd()) {
  rforalle::hent_fil(file = file, type = 'data', full = full, destdir = destdir)
}

#' Get a code file
#'
#' @description Downloads a specified file from the `kode` directory of the source repository. A wrapper for \code{hent_fil()}. The filename must be among those returned by \code{hent_oversikt('kode')}.
#'
#' @param file string; basename of a file.
#' @param full logical; whether to save as is or trim the "kapXX_" prefix upon saving.
#' @param destdir string; path to the download directory.
#'
#' @return no return value, called for side effects
#' @export
#'
#' @examples
#' \dontrun{
#' hent_kode("kap05.R")
#'
#' hent_data(hent_oversikt("kode")[1], full = TRUE, destdir = tempdir())
#'
#' datafiler <- hent_oversikt("kode")
#' for (i in datafiler) {hent_kode(i)}
#' }

hent_kode <- function(file, full = FALSE, destdir = getwd()) {
  rforalle::hent_fil(file = file, type = "kode", full = full, destdir = destdir)
}

#' Get list of available files
#'
#' @description Lists files in source repository available for download with \code{hent_data()} or \code{hent_kode()}.
#'
#' @param selection string; "alle", "data", or "kode'.
#'
#' @return a character vector with filenames (or filepaths in the case of "alle").
#' @export
#'
#' @examples
#' \dontrun{
#' hent_oversikt("data")
#'
#' hent_oversikt("kode")
#'
#' hent_oversikt("alle")
#' }

hent_oversikt <- function(selection = "alle") {
  if (! selection %in% c("alle", "data", "kode")) {
    stop("Feil utvalgtype. Selection maa vaere 'alle', 'data' eller 'kode'.")
  }
  url <- "https://api.github.com/repos/Hegghammer/rbok/git/trees/main?recursive=1"
  req <- httr::GET(url)
  httr::stop_for_status(req)
  files <- unlist(lapply(httr::content(req)$tree, "[", "path"), use.names = FALSE)
  dt <- basename(grep("data/", files, value = TRUE))
  kd <- basename(grep("kode/", files, value = TRUE))
  if (selection == 'alle') {
    return(files[! files %in% c("README.md", "kilder.md", "data", "kode")])
  } else if (selection == "data") {
    return(dt)
  } else if (selection == "kode") {
    return(kd)
  }
}

#' Get files
#'
#' @description Helper function for \code{hent_data()} and \code{hent_kode}.
#'
#' @param file string; passed on from \code{hent_data()} or \code{hent_kode}
#' @param type "data" or "kode"; passed on from \code{hent_data()} or \code{hent_kode}
#' @param full logical; passed on from \code{hent_data()} or \code{hent_kode}
#' @param destdir string; passed on from \code{hent_data()} or \code{hent_kode}
#'
#' @export
#' @examples
#' \dontrun{
#' hent_fil("kap13_test.bib", "data", full = FALSE, destdir = tempdir())
#' }

hent_fil <- function(file, type, full, destdir) {
  if (! type %in% c("data", "kode")) {
    stop("Feil mappetype. Type maa vaere 'data' eller 'kode'.")
  }
  avail <- rforalle::hent_oversikt(type)
  if (! file %in% avail) {
    stop(glue::glue("Filen utilgjengelig. Sjekk filnavn med hent_oversikt('{type}')."))
  }
  stem <- glue::glue('https://github.com/Hegghammer/rbok/raw/main/{type}/')
  url <- paste0(stem, file)
  if (isTRUE(full)) {
    destfile <- file
  } else {
    destfile <- gsub("kap\\d{2}_", "", file)
  }
  destpath <- file.path(destdir, destfile)
  message(glue::glue("Laster ned '{file}' til {destdir} .."))
  utils::download.file(url, destfile = destpath)
}

#' View the source repository on Github
#'
#' @description Opens a browser at \url{https://github.com/Hegghammer/rbok/}.
#'
#' @export
#' @examples
#' \dontrun{
#' se_github()
#' }

se_github <- function() {
  utils::browseURL("https://github.com/Hegghammer/rbok/")
}
