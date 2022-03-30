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

#24/03/22
#plot of l2011 in the NIR channel (solo banda infrarosso vicino)
plot(l2011$B4_sre)  #in alternariva posso usare l'indexing [4] plot(l2011$[[4]])

#dal blu al rosso le freq diventano sempore piu grandi
#posso usare solo 3 bande per volta nel plottaggio imm satellitare

#monto layers RGB  r=3 banda 3 è il rossp
plotRGB(l2011, r=3, g=2, b= 1, stretch = "lin")  #stretch = amplia i valori per vederli meglio (ottengo immagine a colori naturali)
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")   # ho shiftato tutte le bande, la pianta rifelette molto nell'NIR (ho montato la banda del NIR sulla componente r (red))--> tutto quello che rifeltte nell'NIR diventerà rosso
plotRGB(l2011, r=3, g=4, b= 1, stretch = "lin") #ho inserito NIR nella componente g (green), la vegetazione, che riflette nel NIR diventa verde florescente  
plotRGB(l2011, r=3, g=3, b= 4, stretch = "lin")  #monta banda 4 sul blu--> vegtezione è blu, cio che è giallo è suolo nudo


#stretch lineare è fatto con linea, funzione lineare
#stretch istogrammi uso una funzione s, i valori intermedi si alzano molto velocemte
plotRGB(l2011, r=3, g=4, b= 1, stretch = "hist") #incremento di mo,to la differenziazione

#multiframe, piu immagini con RGB VISIBLE (colori naturali) 
# lin stretch sopra a false colors 
# hist stretch 

par(mfrow=c(1,2))  #messe lungo riga
plotRGB(l2011, r=3, g=2, b= 1, stretch = "lin")
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")

pdf("multiframe5.pdf")
par(mfrow=c(2,1))  #messe lungo colonna
plotRGB(l2011, r=3, g=2, b= 1, stretch = "lin")
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")
dev.off()

#confronto con immagine sat del 1988
l1988 <- brick("p224r63_1988.grd")  #brick è una funzione che crea un imaggine da satellite con tanti layer all'interno
plot(l1988)

pdf("multiframe6.pdf")  #differnza tra 2011 e 1988
par(mfrow=c(2,1))  #messe lungo colonna
plotRGB(l1988, r=4, g=3, b= 2, stretch = "lin")
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")
dev.off()



