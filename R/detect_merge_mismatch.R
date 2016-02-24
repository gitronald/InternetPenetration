#' Detect Merge Mismatches
#'
#' @param var1 a variable from the larger data set to be merged
#' @param var2 a variable from the smaller data set to be merged
#'
#' @return a data.frame containing var1 and grep matches of var1 in var2
#' @export
#'
#' @examples
#' detect_merge_mismatch(c("species", "monkey", "human"),
#'                       c("human bowling ball", "rabid monkey", "devoloution"))
#'
detect_merge_mismatch <- function(var1, var2) {
  mismatch1 <- var1[which(!var1 %in% var2)]
  mismatch2 <- var2[which(!var2 %in% var1)]
  matches <- list()
  # Search for matches
  for(i in 1:length(mismatch1)){
    matches[[i]] <- mismatch2[grep(mismatch1[i], mismatch2, ignore.case = T)]
  }
  # Define no match as NA
  matches <- lapply(matches, function(x) {
    ifelse((length(x) < 1),
           x <- NA,
           x <- x)
  })

  # Bind matches into data.frame
  matched <- data.frame(as.matrix(cbind(var1 = mismatch1, matches)))

  # Update missing var1 list
  nomatch1 <- unlist(matched[which(is.na(matched[, 2])), "var1"])

  # Remove var2 cases already matched
  alreadyFound <- unlist(matched[, 2])
  alreadyFound <- alreadyFound[!is.na(alreadyFound)]
  # Update missing var2 list
  nomatch2 <- mismatch2[which(!mismatch2 %in% alreadyFound)]

  # Return in list
  final <- list(matched = matched,
                missing.var1 = nomatch1,
                missing.var2 = nomatch2)

  return(final)
}
