#TOPIC 5 LANDCOVER  #analisi temporale del cambiamento nell'uso del suolo

library(raster)
library(RStoolbox) # classification
install.packages("ggplot2")
library(ggplot2)  #pacchetto che serve per la restituione grafica, ora lo usiamo per calcoalre le frequnze delle classi
install.packages("gridExtra")
library(gridExtra) # for grid.arrange plotting
install.packages("patchwork")
setwd("D:/lab/") # Windows
library(patchwork)

# NIR 1, RED 2, GREEN 3
#importo immagine def 1 che è del 1992
l92 <- brick("defor1_.jpg")
plotRGB(l92, r=1, g=2, b=3, stretch="lin")

#build a multiframe with ggplot2 (pacchetto for elegant data illiustration)
ggRGB(l92, r=1, g=2, b=3, stretch="lin") #è plot RGB MA usa ggplot 2 che è pacchetto diverso #funz basata su pacchetto gg2 e rstoolbox, serve per fare multiframe in modo piu vrlovr

#importo immagine def 2 che è del 2006
l06 <- brick("defor2_.jpg")
plotRGB(l06, r=1, g=2, b=3, stretch="lin")
ggRGB(l06, r=1, g=2, b=3, stretch="lin")  #sulla x e y ci sono coordinate

#build multiframe without ggplot
par(mfrow=c(1,2))
plotRGB(l92, r=1, g=2, b=3, stretch="lin")
plotRGB(l06, r=1, g=2, b=3, stretch="lin")

# multiframe with ggplot2 and gridExtra (assegno p1 e p2 ai plot come se fossero degli oggetti)
p1 <- ggRGB(l92, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(l06, r=1, g=2, b=3, stretch="lin")
p1+p2  #ho creato multiframe con due immagini accostate questo è fatto grazie a patchwork
p1/p2  #ho creato multiframe con due immagini una sopra l'altra
grid.arrange(p1, p2, nrow=2)

# unsupervised classification
l92c <- unsuperClass(l92, nClasses=2)  #è importante definire il numero di classi se 2 classi una è acqua e suolo nudo l'altra è vegetazione
l92c #è il modellino di classificazione, ha due classi 
plot(l92c$map)  #qui voglio la mappa che è contneuta nel modello che puo contenere tante info come statistiche ecc
# class 2: forest (verde)
# class 1: agriculture and water (bianca) (attenzione le classi possono essere invertite perch ele decide il software)

# set.seed() would allow you to attain the same results ...

l06c <- unsuperClass(l06, nClasses=2)
plot(l06c$map)
# class 1: agriculture and water (bianca)
# class 2: forest (verde)


l06c3 <- unsuperClass(l06, nClasses=3)  #modello a 3 classi
plot(d2c3$map)

#la classificazione è servita per poter caloclare l'area sulla base dei pixel visualizzati es: 20 pixel 15 foresta 5 agricolo
# frequencies, ora calcolo il numero di pixel per classe per trovare un area
freq(l92c$map)
#value  count
#[1,]     1  34017   #pixel classe 1 agric
#[2,]     2 307275   #pixel classe 2 foresta

freq(l06c$map)
#value  count
#[1,]     1 164162     #pixel classe 1 agri
#[2,]     2 178564     #pixel classe 2 for
