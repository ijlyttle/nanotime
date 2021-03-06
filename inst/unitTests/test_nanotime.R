## nanotime constructors
test_nanotime_generic <- function() {
  checkEquals(S3Part(nanotime(1), strict=TRUE), as.integer64(1))
  checkEquals(nanotime(1), new("nanotime", as.integer64(1)))
}
test_nanotime_character <- function() {
  checkEquals(nanotime("1970-01-01T00:00:00.000000001+00:00"), nanotime(1))
}
test_nanotime_matrix <- function() {
  m <- matrix(c(10*24*3600+0:9, 9897654321+0:9), 10, 2)
  checkEquals(nanotime.matrix(m), nanotime("1970-01-11T00:00:00.987654321+00:00")+0:9)  
}
test_nanotime_POSIXct <- function() {
  p <- as.POSIXct("1970-01-01 00:00:00", tz="America/New_York")
  checkEquals(nanotime(p), nanotime("1970-01-01T00:00:00.000000000-05:00"))
}
test_nanotime_POSIXlt <- function() {
  l <- as.POSIXlt("1970-01-01 00:00:00", tz="America/New_York")
  checkEquals(nanotime(l), nanotime("1970-01-01T00:00:00.000000000-05:00"))
}
test_nanotime_Date <- function() {
  d <- as.Date(10, origin="1970-01-01")
  checkEquals(nanotime(d), nanotime("1970-01-11T00:00:00.000000000-05:00"))
}

## format
test_format_default <- function() {
  oldFormat <- getOption("nanotimeFormat")
  oldTz <- getOption("nanotimeTz")
  options(nanotimeFormat=NULL)
  options(nanotimeTz=NULL)
  checkEquals(format(nanotime("1970-01-01T00:00:00.000000000+00:00")),
              "1970-01-01T00:00:00.000000000+00:00")
  checkEquals(format(nanotime("1680-07-17T00:00:01.000000000+00:00")),
              "1680-07-17T00:00:01.000000000+00:00")
  checkEquals(format(nanotime("2120-01-01T00:00:59.987654321+00:00")),
              "2120-01-01T00:00:59.987654321+00:00")
  options(nanotimeFormat=oldFormat)
  options(nanotimeTz=oldTz)
}
test_format_tz <- function() {
  oldFormat <- getOption("nanotimeFormat")
  oldTz <- getOption("nanotimeTz")
  options(nanotimeFormat=NULL)

  a <- nanotime("1970-01-01T00:00:00.000000000+00:00")
  a_ny <- "1969-12-31T19:00:00.000000000-05:00"
  
  options(nanotimeTz=NULL)
  checkEquals(format(a, tz="America/New_York"), a_ny)

  options(nanotimeTz="UTC")
  checkEquals(format(a, tz="America/New_York"), a_ny)

  attr(a, "tzone") <- "UTC"
  checkEquals(format(a, tz="America/New_York"), a_ny)

  options(nanotimeFormat=oldFormat)
  options(nanotimeTz=oldTz)
}
test_format_tzone <- function() {
  oldFormat <- getOption("nanotimeFormat")
  oldTz <- getOption("nanotimeTz")
  options(nanotimeFormat=NULL)

  a <- nanotime("1970-01-01T00:00:00.000000000+00:00")
  attr(a, "tzone") <- "America/New_York"
  a_ny <- "1969-12-31T19:00:00.000000000-05:00"

  checkEquals(format(a), a_ny)

  options(nanotimeTz="UTC")
  checkEquals(format(a), a_ny)

  options(nanotimeFormat=oldFormat)
  options(nanotimeTz=oldTz)
}
test_format_tz_from_options <- function() {
  oldFormat <- getOption("nanotimeFormat")
  oldTz <- getOption("nanotimeTz")
  options(nanotimeFormat=NULL)
  options(nanotimeTz="America/New_York")

  a <- nanotime("1970-01-01T00:00:00.000000000+00:00")
  a_ny <- "1969-12-31T19:00:00.000000000-05:00"

  checkEquals(format(a), a_ny)

  options(nanotimeFormat=oldFormat)
  options(nanotimeTz=oldTz)
}
test_format_fmt_default <- function() {
  oldFormat <- getOption("nanotimeFormat")
  oldTz <- getOption("nanotimeTz")
  options(nanotimeFormat=NULL)
  options(nanotimeTz=NULL)

  a_str <- "1970-01-01T00:00:00.000000000+00:00"
  a <- nanotime(a_str)

  checkEquals(format(a), a_str)

  options(nanotimeFormat=oldFormat)
  options(nanotimeTz=oldTz)
}
test_format_fmt_from_options <- function() {
  oldFormat <- getOption("nanotimeFormat")
  oldTz <- getOption("nanotimeTz")
  options(nanotimeFormat="%Y/%m/%dT%H:%M:%E9S%Ez")
  options(nanotimeTz="America/New_York")

  a <- nanotime("1970/01/01T00:00:00.000000000+00:00")
  a_ny <- "1969/12/31T19:00:00.000000000-05:00"

  checkEquals(format(a), a_ny)

  options(nanotimeFormat=oldFormat)
  options(nanotimeTz=oldTz)
}

## conversions
test_as_POSIXct <- function() {
  a <- nanotime(0)
  attr(a, "tzone") <- "America/New_York"
  p <- as.POSIXct(a)
  checkEquals(p, as.POSIXct("1969-12-31 19:00:00", tz="America/New_York"))

  oldTz <- getOption("nanotimeTz")
  options(nanotimeTz="America/New_York")
  b <- nanotime(0)
  p <- as.POSIXct(b)
  checkEquals(p, as.POSIXct("1969-12-31 19:00:00", tz="America/New_York"))

  options(nanotimeTz=NULL)
  c <- nanotime(0)
  p <- as.POSIXct(c)
  checkEquals(p, as.POSIXct("1970-01-01 00:00:00", tz="UTC"))
  
  options(nanotimeTz=oldTz)
}
test_as_POSIXct <- function() {
  a <- nanotime(0)
  attr(a, "tzone") <- "America/New_York"
  p <- as.POSIXlt(a)
  checkEquals(p, as.POSIXlt("1969-12-31 19:00:00", tz="America/New_York"))

  oldTz <- getOption("nanotimeTz")
  options(nanotimeTz="America/New_York")
  b <- nanotime(0)
  p <- as.POSIXlt(b)
  checkEquals(p, as.POSIXlt("1969-12-31 19:00:00", tz="America/New_York"))

  options(nanotimeTz=NULL)
  c <- nanotime(0)
  p <- as.POSIXlt(c)
  checkEquals(p, as.POSIXlt("1970-01-01 00:00:00", tz="UTC"))
  
  options(nanotimeTz=oldTz)
}
test_as_Date <- function() {
  checkEquals(as.Date(nanotime(0)), as.Date("1970-01-01"))
}

## c, subset, subassign and binds
test_c <- function() {
  a <- c(nanotime(1), nanotime(2))
  names(a) <- NULL                      # 'c' will leave a spurious name
  checkEquals(a, nanotime(1:2))

  a <- c(nanotime(1:2), nanotime(3:4))
  names(a) <- NULL                      # 'c' will leave a spurious name
  checkEquals(a, nanotime(1:4))
}
test_subset <- function() {
  a <- nanotime(1:10)
  checkEquals(a[3], nanotime(3))
  checkEquals(a[1:10], a)
}
test_subsassign <- function() {
  a <- nanotime(1:10)
  a[3] <- nanotime(13)
  checkEquals(a[3], nanotime(13))
  a[1:10] <- nanotime(10:1)
  checkEquals(a[1:10], nanotime(10:1))
}
