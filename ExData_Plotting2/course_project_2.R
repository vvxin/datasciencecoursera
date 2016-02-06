# <Exploratory data analysis> - Coursera , 2016 Jan
# Assignment: Course Project 2
# Data source: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

setwd("/Users/simba/git/ExData_Plotting2/")

# plot-1

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

yearsum <- with(NEI, aggregate(Emissions, by = list(year), sum))

png("plot1.png", width = 480, height = 480)
plot(yearsum, 
     type = "b", 
     ylab = "PM2.5 Emissions (ton)", 
     xlab = "Year", 
     main = "Annual Emissions")
dev.off()

# plot-2
baltimore <- NEI[which(NEI$fips == "24510"), ]
baltimoresum <- with(baltimore, aggregate(Emissions, by = list(year), sum))

png("plot2.png", width = 480, height = 480)
plot(baltimoresum, 
     type = "b", 
     ylab = "PM2.5 Emissions (ton)", 
     xlab = "Year", 
     main = "Annual Emissions - Baltimore")
dev.off()

# plot-3
library(plyr)
library(ggplot2)

baltimoretype <- ddply(baltimore, .(type, year), summarize, Emissions = sum(Emissions))
png("plot3.png", width = 480, height = 480)
qplot(x = year, y = Emissions, data = baltimoretype, 
      group = type, color = type, 
      geom = c("point", "line"), 
      ylab = "PM2.5 Emissions (ton)", 
      xlab = "Year", 
      main = "Total Emissions by Type")
dev.off()

# plot-4

coal <- SCC[grep("Coal",SCC$SCC.Level.Three),"SCC.Level.Three"]

# Manually Check if all are "coal combustion-related sources"
unique(coal)
# [1] Anthracite Coal                                          
# [2] Bituminous/Subbituminous Coal                            
#X[3] Coal-based Synfuel                                       
# [4] Waste Coal                                               
# [5] Gasified Coal                                            
# [6] Lignite Coal                                             
# [7] Coal                                                     
#X[8] Coal Bed Methane Natural Gas                             
#X[9] Coal Mining, Cleaning, and Material Handling (See 305310)
#X[10] Coal Mining, Cleaning, and Material Handling (See 305010)
# [11] Bituminous Coal   

# 3,8,9,10 obviously not coal combustion-related sources
coalcumbustion <- unique(coal)[-c(3,8,9,10)]
coalSCC <- SCC[SCC$SCC.Level.Three %in% coalcumbustion , 1]
coalemission <- NEI[NEI$SCC %in% coalSCC,]
coalsum <- with(coalemission, aggregate(Emissions, by = list(year), sum))
coalsum <- setNames(coalsum,c("year","emissions"))

png("plot4.png", width = 480, height = 480)
qplot(x = year, y = emissions, data = coalsum, 
      geom = c("point", "line"), 
      ylab = "PM2.5 Emissions (ton)", 
      xlab = "Year", 
      main = "Total Emissions from Coal-Combustion Sources")
dev.off()

# plot-5
motorSCC = SCC[grep("[Mm]obile|[Vv]ehicles", SCC$EI.Sector), 1]
motorbal <- baltimore[baltimore$SCC %in% motorSCC,]
motorbalsum <- with(motorbal, aggregate(Emissions, by = list(year),sum))
motorbalsum <- setNames(motorbalsum,c("year","emissions"))

png("plot5.png", width = 480, height = 480)
qplot(x = year, y = emissions, data = motorbalsum, 
      geom = c("point", "line"), 
      ylab = "PM2.5 Emissions (ton)", 
      xlab = "Year", 
      main = "Total Emissions from Motor Vehicle Sources - Baltimore")
dev.off()

# plot-6
la <- NEI[which(NEI$fips == "06037"), ]
motorla <- la[la$SCC %in% motorSCC, ]
motorlasum <- with(motorla, aggregate(Emissions, by = list(year),sum))
motorlasum <- setNames(motorlasum,c("year","emissions"))

motorcompare <- merge(motorbalsum, motorlasum, by = "year")
motorcompare <- setNames(motorcompare, c("year","baltimore","los.angels"))

# Normalise data of 2 cities to see trend only
normalised <- scale(motorcompare[,c(2,3)], center = T, scale = T)
normalised <- cbind(motorcompare[,1],as.data.frame(normalised))
names(normalised)[1] <- "year"

png("plot6.png", width = 480, height = 480)
plot(normalised$year, normalised$baltimore,
     type = "b",
     ylim = c(-1.5,1.5),
     col = "blue",
     xlab = "Year",
     ylab = "Normalised PM2.5 Emissions",
     main = "Trend of Emissions from Motor Vehicle Sources")
points(normalised$year, normalised$los.angels,
       type = "b",
       col = "red")
legend("topright",
       legend = c("Baltimore","Los Angels"),
       lwd = 2,
       col = c("blue","red"))
dev.off()