#------ FUNCTION bin.average
# It calculates average y values for bins of x values.
# Input
# x, y, and bin.center are vectors.
# x and y should be the same length.
# 
bin.average <- function(bin.center,x,y)
{

  bin.center <- sort(bin.center)
  min.out <- rep(NA,length(bin.center))
  max.out <- rep(NA,length(bin.center))
  mean.out <- rep(NA,length(bin.center))
  median.out <- rep(NA,length(bin.center))
  for(i in 1:(length(bin.center)))
  {
    if (i == 1) 
    {
      idx <- x < (bin.center[i] + bin.center[i+1]) * 0.5
    }else if(i < length(bin.center)){
      idx <- (x < (bin.center[i] + bin.center[i+1]) * 0.5 ) &
             (x >= (bin.center[i-1] + bin.center[i]) * 0.5)
    }else{
      idx <- (x >= (bin.center[i-1] + bin.center[i]) * 0.5)
    }
    if(sum(idx)>0)
    {
      mean.out[i] <- mean(y[idx])
      min.out[i] <- min(y[idx])
      max.out[i] <- max(y[idx])
      median.out[i] <- median(y[idx])
    }
  }
  return(data.frame(x = bin.center,mean.y = mean.out, 
		    median.y = median.out,
		    max.y = max.out, min.y = min.out))
}



