#questo è il primo script che usermo a lezione
install.packages("raster")
library(raster)

#grd file grafico
#gri info riflettanza pixel
#xml meta dato che descrive dati
#hdr serve per far capire le cooridnate
#spx contiene coord

#caricare dati
#file raster ha tante bande con riflettanza cioè quanta energia riflette rispetto a quella in entrata, colori diversi per le lungh d'onda
#sensore iperspettrale con 244 bande (corrisponde agli strati)

#funzione per import pacchetto di dati è brick, Create a RasterBrick object
?brick
brick("p224r63_2011.grd")
l2011 <- brick("p224r63_2011.grd")
l2011
#nlayers numero strati
#rughe per colonne da la risoluzione 4 mln pixel
#righe nrow colonne ncol
#source sorgente dati 
#sre spectrance reflexance #name sono i nomi delle bande sre (spectral reflectans) vale per tutte le bande tranne per quella del termico
#valori min 0 (tutto assorb) e max 1 (niente è assorbito), riflettanza quanto flusso viene riflesso (radiant flux) e quanto era in entrata
#valori arrivano anche fino a 255

#plot a function generico spazio x y, si puo usare anche per immagini

plot(l2011)
