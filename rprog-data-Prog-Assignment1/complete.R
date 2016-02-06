complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files
        
        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases
        
        datafilelist <- list.files(path = directory,
                                   pattern = "*.csv",
                                   full.names = TRUE)
        
        n.complete <- data.frame()
        
        for (i in id) {
                n.file <- nrow(na.omit(read.csv(datafilelist[i])))
                n.complete <- rbind(n.complete,c(i,n.file))
        }
        
        names(n.complete) <- c("id","nobs")
        n.complete
}