rankall <- function(outcome, num = "best") {
        ## Read outcome data
        data <- read.csv("~/git/datasciencecoursera/rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
        suppressWarnings(data[, 11] <- as.numeric(data[, 11]))
        suppressWarnings(data[, 17] <- as.numeric(data[, 17]))
        suppressWarnings(data[, 23] <- as.numeric(data[, 23]))
        ## Check that state and outcome are valid
        states <- unique(data$State)
        outcomes <- c("heart attack", "heart failure", "pneumonia")
        
        if (!(outcome %in% outcomes)) {
                stop("invalid outcome")
        }
        ## For each state, find the hospital of the given rank
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name

        colposition <- data.frame(outcomeinput = c("heart attack", "heart failure", "pneumonia"), 
                                  colnumber = c(11, 17, 23))
        
        names <- character(0)
        
        for (state in states) {
                datastate <- data[data$State == state, ]
                colnum <- colposition[colposition$outcomeinput == outcome, 2]
                datastate <- datastate[complete.cases(datastate[, colnum]), ]
                datastate <- datastate[order(datastate[, colnum], datastate$Hospital.Name), ]
                
                if (num == "best") {
                        ranknum <- 1  
                } 
                
                else if (num == "worst") {
                        ranknum <- nrow(datastate)
                } 
                
                else suppressWarnings(ranknum <- as.numeric(num))
                
                names <- c(names, datastate[ranknum, ]$Hospital.Name)
        }
        
        return(data.frame(hospital = names, state = states))
}