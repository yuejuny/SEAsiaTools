library(rgdal)
library(data.table)
library(bit64)
map <- readOGR(dsn='Z:/EngineeringG/BoundaryFiles',layer='US.TS4.continent.state.boundary')
STA.FIPS <- data.frame(FIPS=as.numeric(as.character(map$STATE_CODE)), NAME= map$STATE, stringsAsFactors = F)
summary(USIED_AllP_Nov3$NStory)
summary(USIED_AllP_Nov3$RVA)
summary(USIED_AllP_Nov3$RVD)
unique.lat.lon <- USIED_AllP_Nov3[,.N,by=.(Lat,Long)]
summary(unique.lat.lon$N)


