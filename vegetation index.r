# 25/03/22

library(raster)

#settaggio cartella di lavoro, uso virgolette perchè lab è esterna ad R
setwd("C:/lab/dati")


#calcoliamo spectral vegetation index
#indice spettrale, noi partiamo con quelli di vegetazione, la pinata quado sta
#male la pinata cambia colore in molte lunchezze d'onda a nche in quelle che noi non vediamo
#questo cambiamento quindi indica uno stres
#possiamo usare le bande che abbiamo visto fino ada ora per creare questi indici



install.packages("RStoolbox")
library(RStoolbox)



l1992 <- brick("defor1_.jpg")
l1992



#questa immagie non è georefernziata e ha solo 3 bande
#i valori minimi e massimi ci interessano che vanno da 0 a 255 mentre nelle immagini passate
#erano da 0 a 1. questo perche ogni pixel è diverso da quelli vicini e ha diverse riflettanze
#questo vuole dire che in un immagine con tanti pixel questa è molto pesa, per risolvere
#questa cosa interviene Shannon. Per ridurre la dimensione di un file, parte daun informazione binaria
# 0 o 1, questo concetto si chiama bit. La regola generale è 2^n.
# noi stiamo usando immagini a 8 bit, cioè 2^8 CON 256 VALORI POSSIBILI nella mappa, questo
#se partiamo da 1, come valore minimo, se invece partiamo da 0 avremmo 255.
#gran parte delle immahgini che usiamo son a 8 bit perche così si risparmia molto spazio



plotRGB(l1992, r=1, g=2, b=3, stretch="lin")



#banda 1 è quella dell'infrarosso vicino, quindi siccome di solito le bade si monato in
#in sequanza abbaimo la banda 2 che è rossa e la terza che è il green



#importo la seconda immagine



l2006 <- brick("defor2_.jpg")
l2006



plotRGB(l2006, r=1, g=2, b=3, stretch="lin")



#es. plot in multiframe le due immagini una sopra l'altra



par(mfrow=c(2,1))
plotRGB(l1992, r=2, g=1, b=3, stretch="lin")
plotRGB(l2006, r=2, g=1, b=3, stretch="lin")




#calcolo indice speziale DVI (difference vegetation index)
#il massimo di DVI in uscita è 255



dvi1992 = l1992[[1]] - l1992[[2]]
dvi1992



#plorriamo questo primo DVI



cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # specifying a color scheme
plot(dvi1992, col=cl)



#faccio tutto con il 2006



dvi2006 = l2006[[1]] - l2006[[2]]
dvi2006
plot(dvi2006, col=cl)



#un'altro metodo per calcolare DVI è al posto dei numero, nel caloclo, tra le parentesi mettere
# i nomi es. dvi2006 = l2006$defor2_.1 - l2006$defor2_.2



#possiamo fare una differena tra i due DVI



dvi_diff = dvi1992 - dvi2006



#la warning ci dice che in una piccola parte le immgini non si sovrappongon
#dovuto al modo in cuolo abbaimo scaricato le immagin ua ppotrebbe avere una riga
#di pixel in meno



cld <- colorRampPalette(c('blue','white','red'))(100)
dev.off()
plot(dvi_diff, col=cld)



#così vediamo bene dove è avvenuta la deforestazione


31/03/22
#range DVI dipnde dai bit dell'immagine e faccio valore mIN e valroe mAX, ATTENZIONE perchè non è STANDARDIZZATO  (vedi reg 31.03 min 20 circa)
#MAX DVI: quando NIR è max ed R min--> 255 MIN DVI è contrario quindi 0-255=-255
#range DVI (8bit): -255 a 255
#range DVI dipnde dai bit dell'immagine e faccio valore mIN e valroe mAX e poidivido per la loro somma perche STANDARDIZZO 
#range NDVI (8bit): -1 a 1 (perche faccio MIN -255/255=-1)

#range DVI (16bit): -65535 a 65535
#range NDVI (16bit): -1 a 1

#USO NDVI perchè mi permette di comparare immagini anche con bit diversi essendo che il range è uguale 

#RISOLUZIONE RADIOMETRICA: quanti bit ci sono nell'immagine
#calcolo DVI 1992
dvi1992 <- l1992[[1]] - l1992[[2]]   #(sarebbe NIR, elemento 1- RED, elemento 2)
dvi1992

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
# specifying a color scheme, lo decido io perchè ha solo 1 strato
plot(dvi1992, col=cl)

##calcolo DVI 2006
dvi2006 <- l2006[[1]] - l2006[[2]]#(sarebbe NIR, elemento 1- RED, elemento 2)
#or
dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2
dvi2006

plot(dvi2006, col=cl)


#multiframe di confronto tra 1992 e 2006
par(mfrow=c(2,1))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)  #giallo significa forte deforestazione

#differnza di dvi tr 1992 e 2006
dvi_dif <- dvi1992 - dvi2006
cld <- colorRampPalette(c('blue','white','red'))(100)

dev.off()

plot(dvi_dif, col=cld)
#immagine con valori alti uguali a rosso (forte deforestazione), mentre colori bassi è blu

#ogni volta lancio library  e working directory

#NDVI1992
ndvi1992 = dvi1992/ (l1992[[1]]+l1992[[2]])

#or
ndvi1992 = ( l1992[[1]] - l1992[[2]]) / (l1992[[1]] + l1992[[2]])

plot(ndvi1992, col=cl)

#multiframe con plotRGB sopra e ndvi sotto

par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch = "lin")
plot(ndvi1992, col=cl)
#acqua del rio è azzurra perchè sembra suolo nudo infatti gran parte del fiume è cosi


ndvi2006 = dvi2006/ (l2006[[1]]+l2006[[2]])
plot(ndvi2006, col=cl)

#multiframe 2006
par(mfrow=c(2,1))
plotRGB(l2006, r=1, g=2, b=3, stretch = "lin")
plot(ndvi2006, col=cl)

#multiframe NDVI1992 e NDVI2006
par(mfrow=c(2,1))
plot(ndvi1992, col=cl)  #ndvi alto
plot(ndvi2006, col=cl)  #ndvi basso, vicno allo zero cioè suolo nudo perchè la foresta è stata distrutta

#RStoolbox che serve per fare analisi dati
#spectralIndices è una funzione che calcola indici spettrali come NDVI

#AUTOMATIC CALC OF SPECTRAL INDICES
#prima installo e carico con library RStoolbox

install.packages("RStoolbox")
library(RStoolbox)

si1992 <- spectralIndices(l1992, green=3, red=2, nir=1)


install.packages("rasterdiv")
library(rasterdiv)
plot(copNDVI)
