best <- function(state, outcome) {
        
        ## Read outcome data
        data <- read.csv("~/git/datasciencecoursera/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
        suppressWarnings(data[, 11] <- as.numeric(data[, 11]))
        suppressWarnings(data[, 17] <- as.numeric(data[, 17]))
        suppressWarnings(data[, 23] <- as.numeric(data[, 23]))
        ## Check that state and outcome are valid
        states <- unique(data$State)
        outcomes <- c("heart attack", "heart failure", "pneumonia")
        if (!(state %in% states)) {
                stop("invalid state")
        } 
        
        if (!(outcome %in% outcomes)) {
                stop("invalid outcome")
        }
        ## Return hospital name in that state with lowest 30-day death
        ## rate
        colposition <- data.frame(outcomeinput = c("heart attack", "heart failure", "pneumonia"), 
                                  colnumber = c(11, 17, 23))
        colnum <- colposition[colposition$outcomeinput == outcome, 2]
        datastate <- data[data$State == state, ]
        rownum <- which.min(datastate[, colnum])
        return(datastate[rownum, ]$Hospital.Name)
}