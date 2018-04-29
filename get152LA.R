 ---
title: "152LAGeoGrid"
author: "Matthew Malcher"
date: "28 April 2018"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
require(dplyr); require(sf)
```


# Intro
This is an attempt to use the examples and packages from: https://github.com/jbaileyh/geogrid to make a hexagon geogrid for the 152LA's in england which have social care responsibilities.

# Get Geography

The 152 LA's are made up of

* 33 London Boroughts
* 36 Metropolitan Districts
* 27 Shire Counties
* 56 Unitary Authorities
```{r}
geo <- st_read("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Counties_and_Unitary_Authorities_December_2017_Boundaries/MapServer/4/query?where=1%3D1&outFields=shape,ctyua17cd,long,lat,ctyua17nm&outSR=4326&f=json", quiet=T) %>% filter(!grepl('W',ctyua17cd ))

```


## Upper tier local authorities
http://geoportal.statistics.gov.uk/datasets/lower-tier-local-authority-to-upper-tier-local-authority-december-2017-lookup-in-england-and-wales/geoservice

There are 113 Upper Tier Local Authorities between England and Wales
* 22 Unitary Authorities in Wales
* 91 Upper Tier LA's in England

```{r message=F, warning=F}
LTLA2UTLA <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LTLA17_UTLA17_EW_LU/FeatureServer/0/query?where=1%3D1&outFields=LTLA17CD,LTLA17NM,UTLA17CD,UTLA17NM&returnGeometry=false&outSR=4326&f=json", quiet=T)

```


## Regions

```{r}
LAD2RGN <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD17_RGN17_EN_LU/FeatureServer/0/query?where=1%3D1&outFields=LAD17CD,LAD17NM,RGN17CD,RGN17NM&returnGeometry=false&outSR=4326&f=json", quiet=T)

```

## Combined Authorities
```{r}
LAT2CAUTH <- st_read("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LAD17_CAUTH17_EN_LU/FeatureServer/0/query?where=1%3D1&outFields=LAD17CD,LAD17NM,CAUTH17CD,CAUTH17NM&returnGeometry=false&outSR=4326&f=json", quiet=T)
```


# Combine Lookups into Geom
Note - the shire counties (bottom 27) wont join using the LT LA code. You could join the other way using  CTY17CD code to get LAD17CD - perhaps doing some stuff to stop the join exploding
```{r}
geo <- geo %>%
  left_join(LTLA2UTLA, by=c("ctyua17cd"="LTLA17CD")) %>%
  left_join(LAD2RGN, by=c("ctyua17cd"="LAD17CD")) %>%
  left_join(LAT2CAUTH) 

```



