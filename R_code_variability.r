#TOPIC 6 VIARIABILITY 03.05.22
#misure di variabilità sul Similaun che vanno a cogliere varizioni tra ambienti es: diff tra prateria sommitale e boschi conifere


#se acquisisco tanti dati riesco ad ottnere una distribuzione che spesso si distribusice secondo una normale
#al centro ce valore medio ai lati posso vedere la variazione che puo variare da 98% a 100%, dev st è la var, se la elevo al ^2 ottengo Varianza che evidenzia lo strech


#nel grafico età studnenti se inserisco campione outlier cioè età prof la curva diventa skewed cioè ha coda a dx, ma se inserisco tutti docenti la curva torna normale 

library(raster)
library(RStoolbox) # for image viewing and variability calculation
library(ggplot2) # for ggplot plotting
library(patchwork)

x <- c (21,22,23,24,25)
m <- (21+22+23+24+25) / 5  #media si sposta con outlier ma mediana invece non è influenzata


setwd("D:/lab/") # Windows
sen <- brick("sentinel_similaun.png")  #prima banda NIR seconda banda rosso terza verde

#EX plot the image by ggRGB function
ggRGB(sen, r=1,g=2,b=3)   #rgb e stretch posso anche no scriverli

#nell'immagine vedo bene la foresta in rosso e l'h2o in scuro


#cambio visione mettendo componente green la veegtazione che riflette nel infrarosso, la roccia è viola
ggRGB(sen, r=2,g=1,b=3) 

#plotto due immagini insieme con patchwork
g1 <- ggRGB(sen, r=1,g=2,b=3)
g2 <- ggRGB(sen, r=2,g=1,b=3) 
g1+g2   #due grafici accanto
g1/g2   #due grafici uno sopra l'altro

(g1+g2)/(g2+g1) #4 grafici 2 a 2 


# per calcolo coeff di var ci vuole una qualsiasi variabile come ad es in questo caso l'età
#in queste immagini abbiamo le diverse bande che sono variabili, per scegliere posso fare un indice spettrale NDVi o analisi multivariata (compatta piu dati in pochi assi cartesiani)

#calcolo la var sulla banda NIR che è quella che ci interssa di piu (NIR è il rpimo elemento dell'immagine sentinel)
nir <- sen[[1]]  #NIR è il rpimo elemento dell'immagine sentinel e l'assegno al nom e"nir"
nir # se chiamo nir mi esce che band: 1  (of  4  bands)

#focal function   
#concetto finestra mobile o "moving window"  in cui l'immagine originale (input image) e la finestra si muove e fa il calcolo che è asseganto al pixel centrale finche tutit i pixel hanno un valore

sd3 <- focal(nir, w=matrix(1/9, 3, 3), fun=sd)  #w è la matrice cioè dati nel quadrato (matrice di 3 pixel per 3 pixel-> 9 pixel tot MA l'unità di base è 1/9 pixel)  #fun è la funzione da calcolare
#attenzione a nominare l'oggetto perchè quando la chiamo sd poi non trova la funzione sd

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(sd3, col=clsd)

#plotting with ggplot
# con geomraster aggiungo la geometria che voglio fare es: plot a barre, a punti...
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer))  #ggplot va vuoto piu geom raster con immagine e grafiche. mapping sono le estetiche (come e cosa mettere nel grafico)
#fill è il tipo di riempimento e in questo caso uso la banda cioè il layer 
#vedo che le zone di passagio tra prato a bosoc e crepacci sono chiare e sono le piu variabili

#VARAIBILITY 2 on multivarite bands

library(raster)
library(RStoolbox)

setwd("D:/lab/")

siml <- brick("sentinel_similaun.png")

#NIR 1
#red
#green

ggRGB(siml, 1,2,3)
ggRGB(siml, 3,1,2) #per evidenziare suolo nudo inverto  ordine NIR e infrarosso nel verde  (suolo diventa viola)


#calcolo PCA su questa immagine

simlPCA <- rasterPCA(siml)
simlPCA  #call modello e mappa

#quantq varianza è spiegata da ogni componente 
summary(simlPCA$model)   #comp1 da sola spiega solo 77% perchè l'altra aveva range molot piu altro

g1 <- ggplot() + geom_raster(simlPCA$map, mapping = aes(x=x, y=y, fill=PC1)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC1") #valori piu alti correlati alla parte vegetale

g3 <-  ggplot() + geom_raster(simlPCA$map, mapping = aes(x=x, y=y, fill=PC3)) + scale_fill_viridis(option = "inferno") +
   ggtitle("PC3")   #con PC3 la banda da poche info
 
g2 <-  ggplot() + geom_raster(simlPCA$map, mapping = aes(x=x, y=y, fill=PC2)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC2")

g1+g3

#caloclo la var sulla PC1
pc1 <- simlPCA$map[[1]]

sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)

ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option = "inferno") +
  ggtitle("Standard deviation of PC1")   #mette in evidenzai i punti dove ce discontinuità ovvero variabilità piu forte
             
#questi metodi di MUA servono per compattare i dati quindi è applicabile anche a dati tabellari


library(viridis)#pachetto viridis per semplificare la visualizzazione dei colori nelle mappe

#immagine con scala di colori viridis
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis() +
  ggtitle("Standard deviation by viridis package")
#cambio legenda con option = "civilis", legenmds che sfuma di piu il blu cioè i minimi mettendo in evideniza i massimi
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option = "cividis") +
  ggtitle("Standard deviation by viridis package")

#immagine con scala di colori inferno
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option = "inferno") +
  ggtitle("Standard deviation by viridis package")


sd7 <- focal(nir, ) #ho aumentato la finestra
