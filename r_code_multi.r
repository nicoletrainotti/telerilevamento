#TOPIC 7 Analisi multivariata

#è posssibile compattare tutto in uuna singola banda --> uso stesse techinche applicate alle immagini satellitari
#la prima banda è quella con piu info, quella che userò per calcolare variabilità
#tanti tipi di multivariabili noi usaimo PCA ma tutti hanno come scopo di compattare la var in un unica dimensione piu semplice

setwd("D:/lab/dati")

library(raster)
library(RStoolbox)

p224r63_2011 <- brick("p224r63_2011_masked.grd")
plot(p224r63_2011)  #7 bande 

#resampling
#prima di fare MA devo fare un ricampionamento (resampling), 30 mln di pixel--> devo degradare la RISOLUZIONE--> ricampiono immagine lavorando per blocchi e mi da media dei pixel

p224r63_2011res <- aggregate(p224r63_2011, fact=10) 
p224r63_2011res100 <- aggregate(p224r63_2011, fact=100) 


g1 <- ggRGB(p224r63_2011, 4,3,2)
g2 <- ggRGB(p224r63_2011res, 4,3,2)
g3 <- ggRGB(p224r63_2011res100, 4,3,2)


g1+g2
g1+g2+g3


#PCA analysis

p224r63_2011respca <- rasterPCA(p224r63_2011res)   #ho creato un oggetto da un modello ma crea anche mappe ed altre cose
p224r63_2011respca   #crea  call mappa modello... $ ed ogni componente cosi come con classificazione

summary(p224r63_2011respca$model)  #ho le info sul modello
#proprtion of variance, quanta var è spiegata da ogni singola componente
#nuovs visualizzazione con PC1, prima comp principale con piu info mentre PC7 ha solo rumore

plot(p224r63_2011respca$map)

ggplot() + geom_raster(p224r63_2011respca$map, mapping = aes(x=x, y=y, fill=PC1)) + scale_fill_viridis(option = "cividis") +
  ggtitle("PC1")
g1 <- ggplot() + geom_raster(p224r63_2011respca$map, mapping = aes(x=x, y=y, fill=PC1)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC1")  #conserva tutta la info

g2 <- ggplot() + geom_raster(p224r63_2011respca$map, mapping = aes(x=x, y=y, fill=PC7)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC7")  #tutto monocolore perche rumorosa quindi perde tutta la info

g1+g2


g3 <- ggplot() + geom_raster(p224r63_2011res, mapping = aes(x=x, y=y, fill=B4_sre)) + scale_fill_viridis(option = "inferno") +
  ggtitle("NIR")  #con banda  4 che è NIR

g1+g3  #dove riflettanza nel NIR è piu alta, la PC1 è piu bassa perche sono INV correlati

#attenzione: se guardo valori delle componenti vedo nel plot del NIR i valori di riflettanza nella leggenda mentre per PC1 non hanno significato sono solo valori su una classe

g4 <- ggRGB(p224r63_2011res, 4,3,2)

g1+g4  #si vede come la parte di foresta corrisponde a valori bassi di PCA  (con immagine ricampionata)

g5 <- ggRGB(p224r63_2011, 4,3,2)

g1+g5 #si vede come la parte di foresta corrisponde a valori bassi di PCA  (con immagine originale, si vede un po meglio)

g5 <- ggRGB(p224r63_2011, 2,3,4,)  #♣inverto 2 e 4 cioe metto infrarosso nel blu


g5 <- ggRGB(p224r63_2011, 2,3,4, stretch = "hist")  #uso stretch hist che aumenta contrasto
g1+g5

plotRGB(p224r63_2011, 2,3,4, stretch="lin")  #molte simile alla PCA che abbiamo visto prima e significa che la PCA contiene la maggior parte delle info

#pc1map <- p224r63_2011respca$map[[1]]  #non serve farle perchè tanto nel prossimo comando di plotRGB metto i 3 livelli che sono le 3 bande
#pc2map <- p224r63_2011respca$map[[2]]
#pc3map <- p224r63_2011respca$map[[3]]

plotRGB(p224r63_2011respca$map, 1,2,3, stretch = "lin")    #max info che posso avere e su questa mappa calcolo la var, i colori non hannomsignificato sono semplicemnte le prime 3 componenti
