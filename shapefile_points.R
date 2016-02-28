require(maptools)
library(rgdal)
require(sp)
require(rgeos)
library(ggplot2)
library(tmap)
library(scales)
library(dplyr)
library(spatialEco)

## Read in lat and long data file
mappoints<-read.csv("china_test_latlon.csv", stringsAsFactors=FALSE)
head(mappoints)

## Read in shapefile--readOGR command allows most info to be imported in
shapefile<-readOGR(".", layer="China")

## Plot all data points over shapefile
ggplot()+geom_polygon(data=shapefile, aes(long, lat, group=group), colour="red", size=.1, fill="skyblue", alpha=.3)+
  geom_point(data=mappoints, aes(x=long, y=lati), colour="red", alpha=0.1)

## Make sure shapefile and mappoints file in the same format
proj4string(shapefile)
class(mappoints)

## This needs to be column names of lat and long (here long and lati)
coordinates(mappoints)<-~long+lati
class(mappoints)
proj4string(mappoints)

## Take information from shapefile proj4string and put into CRS string
proj4string(mappoints)<-CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

## Check that mappoints and shapefile are now in same format 
identical(proj4string(mappoints), proj4string(shapefile))

datamap<-spTransform(mappoints, CRS(proj4string(shapefile)))

## Select only lat lon within shapefile
intersect<-point.in.poly(datamap, shapefile)
intersect<-data.frame(intersect)

## Plot 
ggplot()+geom_polygon(data=shapefile, aes(x=long, y=lat, group=group), colour="red", size=.1, fill="skyblue", alpha=.3)+ 
  geom_point(data=intersect, aes(x=long, y=lati), colour="red", alpha=0.1)


