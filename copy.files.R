library(data.table)
# historical earthquake name and Id
main.dir <- 'w:/EngineerTeam/HistoricalEQValidation/Philippines'

RPHist.EQ <- fread('W:/EngineerTeam/HistoricalEQValidation/Philippines/R/RP.Historical.EQ.ID.Name.csv')
folder <- data.frame(EventID=c(5,9,14,18,20,24,25,29,54),
                     name=c('1897_Sulu', 
                            '1918_CelebesSea',
                            '1948_LadyCaycay',
                            '1968_Casiguran',
                            '1976_MoroGulf',
                            '1990_Bohol',
                            '1990_Luzon',
                            '1994_Mindoro',
                            '2012_Visayas'))
for(i in 1:nrow(folder)){
  id <- folder$EventID[i]
  eq.title <- RPHist.EQ[Event == id, Name]
  setwd(file.path(main.dir,folder$name[i]))
  file.copy(from=file.path(main.dir,'2013_Bohol/R/common.section.RMD'),
            to = './R/common.section.RMD',
            overwrite=T) 
  file.copy(from=file.path(main.dir,'2013_Bohol/R/custom.css'),
            to = './R/custom.css',
            overwrite=T) 
  if(file.exists('./R/loss.analysis.Rmd')) file.remove('./R/loss.analysis.Rmd')
  con <- file(file.path(main.dir,'2013_Bohol/R/loss.analysis.Rmd'), open='r')
  line <- readLines(con,1,warn=F)
  line.count <- 0
  outfile <- file('./R/loss.analysis.Rmd', open='w')
  sink(outfile)
  while(length(line)>0){
    line.count <- line.count + 1
    if(line.count == 2){
      line <- paste('title: "Philippines', eq.title,'"')
    }else if(line.count ==31){
      line <- paste0("data.dir <- 'W:/EngineerTeam/HistoricalEQValidation/Philippines/",folder$name[i],"'")
    }else if(line.count == 37){
      line <- paste("event.ID <- ", id)
    }
    cat(line)
    cat('\n')
    line <- readLines(con, 1, warn=F)
  }
  sink() #stop sinking
  if(isOpen(outfile)) close(outfile)
  if(isOpen(con)) close(con)
}

