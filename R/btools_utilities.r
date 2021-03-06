# btools_utilities.r
# Don Boyd
# 2/21/2017

# library("devtools")

# library("btools")


#****************************************************************************************************
#                String manipulation functions ####
#****************************************************************************************************

#' @title Capitalize first letter of each word
#'
#' @description \code{capwords} capitalize first letter of each word
#' @usage capwords(s, strict=FALSE)
#' @param s The string to capitalize words of
#' @param strict TRUE or FALSE
#' @details All white space is removed from the trailing (right) side of the string.
#' @return The initial-capped result.
#' @keywords capwords
#' @export
#' @examples
#' capwords("string to capitalize words in")
capwords <- function(s, strict=FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)), 
                           {s <- substring(s,2); if(strict) tolower(s) else s},
                           sep = "", 
                           collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}


#' @title Trim leading white space in strings
#'
#' @description \code{trimlead} trims leading white space in strings
#' @usage trimlead(s)
#' @param s The string to trim.
#' @details All white space is removed from the leading (left) side of the string.
#' @return The trimmed string.
#' @keywords trimlead
#' @export
#' @examples
#' trimlead("   original string has leading and trailing spaces   ")
trimlead <- function(s) {sub("^\\s+", "", s)}


#' @title Trim trailing white space in strings
#'
#' @description \code{trimtrail} trims trailing white space in strings
#' @usage trimtrail(s)
#' @param s The string to trim.
#' @details All white space is removed from the trailing (right) side of the string.
#' @return The trimmed string.
#' @keywords trimtrail
#' @export
#' @examples
#' trimtrail("   original string has leading and trailing spaces   ")
trimtrail <- function(s) {sub("\\s+$", "", s)}


#' @title Trim white space at either end of strings
#'
#' @description \code{trim.ws} trims white space around strings
#' @usage trim.ws(s)
#' @param s The string to trim.
#' @details All white space is removed from the ends.
#' @return The trimmed string.
#' @keywords trim.ws
#' @export
#' @examples
#' trim.ws("   original string has leading and trailing spaces   ")
trim.ws <- function(s) {gsub("^\\s+|\\s+$", "", s)}



#****************************************************************************************************
#                Numeric and date manipulation functions ####
#****************************************************************************************************

#' @title Convert character to numeric
#'
#' @description \code{cton} converts character to numeric
#' @usage cton(cvar)
#' @param cvar The character string input. No default.
#' @details Replaces spaces, comma, $, and percent sign in a string with NULL and then converts to numeric.
#' Keeps letters so that scientific notation will be evaluated properly.
#' Also look at \code{extract_numeric} in package stringr
#' @keywords cton
#' @export
#' @examples
#' char <- "$198,234.75"
#' cton(char)
cton <- function(cvar) {as.numeric(gsub("[ ,$%]", "", cvar))}


#' @title Convert NA to zero
#'
#' @description \code{naz} converts NA to zero
#' @usage naz(vec)
#' @param vec The vector to convert
#' @details Converts all NAs in a vector to zero.
#' @return The revised vector.
#' @keywords naz
#' @export
#' @examples
#' naz(NA)
naz <- function(vec) {return(ifelse(is.na(vec), 0, vec))}


#' Convert Excel numeric date to date.
#' 
#' @param xdate a numeric vector containing dates in Excel format.
#' @return date
#' @export
#' @examples
#' xdate(30000)
xdate <- function(xdate) {
  # convert Excel numeric date to date
  date <- as.Date(as.numeric(xdate), origin = "1899-12-30")
  return(date)
}


#****************************************************************************************************
#                Statistical functions ####
#****************************************************************************************************

#' Compute the sample 25th percentile.
#' 
#' @param x a numeric vector containing the values whose 25th percentile is to be computed.
#' @param na.rm a logical value indicating whether NA values should be stripped before the computation proceeds.
#' @return numeric
#' @export
#' @examples
#' p25(1:100)
#' p25(c(1:10, NA, 11:100), na.rm=TRUE)
p25 <- function(x, na.rm=FALSE) {as.numeric(quantile(x, .25, na.rm=na.rm))}


#' Compute the sample 50th percentile (median).
#' 
#' @param x a numeric vector containing the values whose 50th percentile is to be computed.
#' @param na.rm a logical value indicating whether NA values should be stripped before the computation proceeds.
#' @return numeric
#' @export
#' @examples
#' p50(1:100)
#' p50(c(1:10, NA, 11:100), na.rm=TRUE)
p50 <- function(x, na.rm=FALSE) {as.numeric(quantile(x, .50, na.rm=na.rm))}

#' Compute the sample 75th percentile.
#' 
#' @param x a numeric vector containing the values whose 75th percentile is to be computed.
#' @param na.rm a logical value indicating whether NA values should be stripped before the computation proceeds.
#' @return numeric
#' @export
#' @examples
#' p75(1:100)
#' p75(c(1:10, NA, 11:100), na.rm=TRUE)
p75 <- function(x, na.rm=FALSE) {as.numeric(quantile(x, .75, na.rm=na.rm))}

#' Compute the sample value for a specific percentile, p.
#' 
#' @param x a numeric vector containing the values whose p-th percentile is to be computed.
#' @param p the percentile.
#' @param na.rm a logical value indicating whether NA values should be stripped before the computation proceeds.
#' @return numeric
#' @export
#' @examples
#' pany(1:100, .33)
#' pany(c(1:10, NA, 11:100), .33, na.rm=TRUE)
pany <- function(x, p, na.rm=FALSE) {as.numeric(quantile(x, p, na.rm=na.rm))}


#****************************************************************************************************
#                Rolling mean and sum functions ####
#****************************************************************************************************
# the rollmean versions are fast but cannot handle NA input values
# the rollapply version is slower but handles NAs, so use it - that's what I do

#' @title Get 4-period moving average (3 lags + current)
#'
#' @description \code{ma4} get 4-period moving average
#' @usage ma4(x)
#' @param x The vector to operate on.
#' @details 4-period moving average
#' @keywords ma4
#' @export
#' @examples
#' ma4(7:21)
ma4 <- function(x) {
  # note that this requires zoo, which is on the Depends line in the Description file
  zoo::rollapply(x, 4, function(x) mean(x, na.rm=TRUE), fill=NA, align="right")
}

#' @title Get 4-period moving sum (3 lags + current)
#'
#' @description \code{sum4} get 4-period moving sum
#' @usage sum4(x)
#' @param x The vector to operate on.
#' @details 4-period moving sum
#' @keywords sum4
#' @export
#' @examples
#' sum4(7:21)
sum4 <- function(x) {ma4(x) * 4}

ma <- function (x, n) {
  x.ma <- zoo::rollapply(x, n, function(x) mean(x, na.rm = TRUE), fill = NA, align = "right")
  return(x.ma)
}




#****************************************************************************************************
#                Miscellaneous functions ####
#****************************************************************************************************

#' @title Show head and tail of a vector, matrix, table, data frame or function
#'
#' @description \code{ht} head and tail of a vector, matrix, table, data frame or function
#' @usage ht(df, nrecs=6)
#' @param df The object. No default.
#' @param nrecs number of records, rows, whatever to show at head and at tail
#' @details show head and tail of a vector, matrix, table, data frame or function
#' @keywords ht
#' @export
#' @examples
#' ht(mtcars, 4)
ht <- function(df, nrecs=6){
  print(head(df, nrecs))
  print(tail(df, nrecs))
}


#' @title Describe memory usage and collect garbage
#'
#' @description \code{memory} describe memory usage and collect garbage
#' @usage memory(maxnobjs=5)
#' @param maxnobjs The number of objects to display. Default is 5.
#' @details Describes memory usage and collects garbage 
#' @keywords memory
#' @export
#' @examples
#' memory(4)
memory <- function(maxnobjs=5){
  # function for getting the sizes of objects in memory
  objs <- ls(envir = globalenv())
  nobjs <- min(length(objs), maxnobjs)
  
  getobjs <- function() {
    f <- function(x) utils::object.size(get(x)) / 1048600
    sizeMB <- sapply(objs, f)
    tmp <- data.frame(sizeMB)
    tmp <- cbind(name=row.names(tmp), tmp) %>% arrange(desc(sizeMB))
    # tmp <- tmp[order(-tmp$sizeMB), ]
    row.names(tmp) <- NULL
    tmp$sizeMB <- formatC(tmp$sizeMB, format="f", digits=2, big.mark=",", preserve.width="common")
    return(tmp)
  }
  
  print(paste0("Memory available: ", utils::memory.size(NA)))
  print(paste0("Memory in use before: ", utils::memory.size()))
  
  if(nobjs>0){
    print("Memory for selected objects: ")
    print(head(getobjs(), nobjs))
  }
  print(gc())
  print(paste0("Memory in use after: ", utils::memory.size()))
}


#' Format a numeric vector in dollar (or comma) format
#' 
#' @param x Numeric vector.
#' @param d Integer, number of decimal places.
#' @param parens Logical - enclose negative numbers with parentheses?
#' @param dsign Logical - leading dollar sign?
#' @export
#' @examples
#' x <- c(-10, -1.235, -23456.789, 1, 10, 100, 1000000, 1789456.23456789)
#' dollar_d(x)
#' dollar_d(x, 1)
#' dollar_d(x, 1, dsign=FALSE)
#' dollar_d(x, 1, parens=TRUE)
#' dollar_d(x, 1, parens=TRUE, dsign=FALSE)
dollar_d <- function(x, d=0, parens=FALSE, dsign=TRUE){
  # require("scales")
  xc <- scales::comma(round(abs(x), d))
  if(parens) xc <- ifelse(x >= 0, xc, paste0("(", xc, ")")) else
    xc <- ifelse(x >= 0, xc, paste0("-", xc))
  if(dsign) xc <- paste0("$", xc)
  return(xc)
}


#' ifelse that can be used safely with dates
#' 
#' @param cond Logical expression.
#' @param yes Resulting value if cond is TRUE.
#' @param no Resulting value if cond is FALSE.
#' @export
#' @examples
#' # snippet: mutate(date=safe.ifelse(freq=="A", as.Date(paste0(olddate, "-01-01")), date))
safe.ifelse <- function(cond, yes, no) {
  # so dates don't lose their class!
  structure(ifelse(cond, yes, no), class = class(yes))
}


#' function to deal with NA logical values
#' 
#' @param x vector.
#' @export
is.true <- function(x) {!is.na(x) & x}


#' Factor to numeric
#'
#' \code{f2n} returns a numeric vector, converted from factor
#'
#' @usage f2n(fctr)
#' @param fctr factor that we want to convert to numeric
#' @details
#' Returns a pure numeric vector
#' @return numeric vector
#' @keywords f2n
#' @export
#' @examples
#' set.seed(1234)
#' fctr <- factor(sample(1:4, 50, replace=TRUE), levels=1:4)
#' fctr
#' f2n(fctr)
f2n <- function(fctr) {as.numeric(levels(fctr)[fctr])}


