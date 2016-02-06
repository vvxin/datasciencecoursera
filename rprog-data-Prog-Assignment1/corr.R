corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files
        
        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0
        
        ## Return a numeric vector of correlations
        ## NOTE: Do not round the result!
        
        datafilelist <- list.files(path = directory,
                                   pattern = "*.csv",
                                   full.names = TRUE)
        result <- numeric()
        
        for (i in 1:length(datafilelist)) {
                onefile <- na.omit(read.csv(datafilelist[i]))
                if (nrow(onefile) > threshold) {
                        result <- c(result, cor(onefile$sulfate,onefile$nitrate))
                }
        }
        
        result
}