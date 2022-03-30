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

#lezione 18/03/22



#plottare una singola banda, quella del BLU
#prima di tuto devo individuarla B1_sre (banda blu)
l2011
plot(l2011$B1_sre) #vantaggiooso perche capisco cosa sto plottando



#2° metodo
plot(l2011[[1]]) #seleziono elemento n°1 che è proprio la banda ddel blu



#camibio la legenda anche a questo grafico
cl <- colorRampPalette(c("black", "grey", "light grey")) (100) #100 sono le possibili tonalità tra i tre colori impostati
plot(l2011$B1_sre, col=cl)



#plotto che va da blu scuro a chiaro passando da azzurro
clblue <- colorRampPalette(c("dark blue", "dark cyan", "light blue")) (100) #100 sono le possibili tonalità tra i tre colori impostati
plot(l2011$B1_sre, col=clblue)



#esporto l'immagine in blu come un pdf, salvo in cartella lab
pdf("banda1.pdf") #salvato nella working directory (come nei progetti in R, ma attenzione perchè i dati raster non sonosalvati bene se uso working directory di r )
plot(l2011$B1_sre, col=clblue)
dev.off()



#esporto l'immagine in blu come un png, salvo in cartella lab
png("banda1.png") #salvato nella working directory (come nei progetti in R, ma attenzione perchè i dati raster non sonosalvati bene se uso working directory di r )
plot(l2011$B1_sre, col=clblue)
dev.off()



#plotto che va da verde scuro a chiaro
clgreen <- colorRampPalette(c("dark green", "green", "light green")) (100) #100 sono le possibili tonalità tra i tre colori impostati
plot(l2011$B2_sre, col=clgreen)




#immagine con solo alcune bande (mf=multiframe)
par(mfrow=c(1,2)) #1 righe 2 colonne, nrow vuol dire che parto dalle righe
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
dev.off() #serve per chiudere la finestra che ho aperto con par



pdf("multiframe.pdf")
par(mfrow=c(1,2)) #1 righe 2 colonne, nrow vuol dire che parto dalle righe
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
dev.off()



#voglio plot invertito con blu sopra e verde sotto
#multiframe gli dico di rimepire da colonna 2 righe 1 colonna



pdf("multiframe2.pdf")
par(mfrow=c(2,1)) #1 righe 2 colonne, nrow vuol dire che parto dalle righe
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
dev.off()



clred <- colorRampPalette(c("brown3", "brown2", "brown1")) (100) #100 sono le possibili tonalità tra i tre colori impostati
plot(l2011$B3_sre, col=clred)



clif <- colorRampPalette(c("red", "orange", "yellow")) (100) #100 sono le possibili tonalità tra i tre colori impostati
plot(l2011$B4_sre, col=clif)



pdf("multiframe3.pdf")
par(mfrow=c(2,2))
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
plot(l2011$B3_sre, col=clred)
plot(l2011$B4_sre, col=clif)
dev.off()



dev.off()
pdf("multiframe4.pdf")
par(mfrow=c(2,2))
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
plot(l2011$B3_sre, col=clred)
plot(l2011$B4_sre, col=clif)
dev.off()

# 25/03/22



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
