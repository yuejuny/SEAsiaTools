
EndLocation <- function(loc, vec){
  # loc and vec are numeric vectors of length 3
  #    Given Vector and its starting point, find the end point of the vector, where
  #    vector has information (azimuth,horizontal distance and vertical distance) 
  #    # converted from OpenSHA jave to python (credit to OpenSHA developers)
  #    org.opensha.commons.geo.Location*
  #    Line extension (limited, not to infinite)
  R <- 6371.0 # earth radius in km
  loc[1:2] <- loc[1:2] * pi / 180.0 # convert degree to arc
  lon1 <- loc[1]
  lat1 <- loc[2]
  dep1 <- loc[3]
  az <- vec[1]
  DH <- vec[2]
  DV <- vec[3]

  # refer to http://williams.best.vwh.net/avform.htm#LL 
  sinLat1 <- sin(lat1)
  cosLat1 <- cos(lat1)
  ad <- DH / R
  sinD <- sin(ad)
  cosD <- cos(ad)

  # compute the location information for the end point loc2 
  lat2 <- asin( sinLat1*cosD + cosLat1*sinD*cos(az) )
  dlon <- atan2( sin(az)*sinD*cosLat1, cosD - sinLat1*sin(lat2))
  lon2 <- lon1 + dlon
  dep2 <- dep1 + DV

  lat2 <- lat2*180/pi # arc to degree
  lon2 <- lon2*180/pi # arc to degree
  return(c(lon2,lat2,dep2))
}

rupture.polygon <- function(Lon,Lat,Depth,Length,Width,Azimuth,
                            DipAngle,DipAzi,segmentID){
  # Lon,Lat,Azimuth,DipAngle,DipAzi in decimal degree
  # Depth, Length, Width in km
  
  cloc <- c(Lon, Lat, Depth)
  az <- Azimuth * pi / 180
  dip <- DipAngle * pi / 180
  dipAz <- DipAzi * pi / 180

  vec <- c(az,Length/2.0,0)
  p1 <- EndLocation(cloc,vec)
  vec[1] <- az + pi
  p2 <- EndLocation(cloc,vec)

  vec <- c(dipAz - pi, Width / 2 * cos(dip), 0.0)
  loc1 <- EndLocation(p1, vec)
  loc4 <- EndLocation(p2, vec)
  vec[1] <- dipAz
  loc2 <- EndLocation(p1, vec)
  loc3 <- EndLocation(p2, vec)

  lonlat <- data.frame(x = c(loc1[1],loc2[1],loc3[1],loc4[1],loc1[1]),
                       y = c(loc1[2],loc2[2],loc3[2],loc4[2],loc1[2]))
  sr <- Polygon(coords = lonlat, hole = F)
  srs <- Polygons(list(sr), ID = paste0(segmentID))
  return(srs)
}

