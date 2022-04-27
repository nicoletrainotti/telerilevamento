#TOPIC 4 CLASSIFICATION (passaggio da dati continui a classi)
#pixel sono plottati in un grafico cartesiano e poi quelli con valori simili sono raggruppati per tipo di veg/litologia ecc

# R_code_classification.r

#h2o assorbe quasi tutto nell IR mentre rilflette nelle altre bande--> in IR valori molto bassi perchè assorbe

library(raster)
library(RStoolbox)  #otganizzazione dati satellitari


setwd("D:/lab/") # Windows
 

so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")  #solar orbiter è il sensore e satellite che acquisisce dati sul moviemnto del sole
so   #solar orbiter

plotRGB(so, 1,2,3, stretch="lin")   #rgb è omesso

soc <- unsuperClass(so, nClasses=3)
plot(soc$map)

soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map,col=cl)

cl <- colorRampPalette(c('yellow','black','red'))(100)
plot(soc20$map,col=cl)

# Download Solar Orbiter data and proceed further!

# Grand Canyon
# https://landsat.visibleearth.nasa.gov/view.php?id=80948

# When John Wesley Powell led an expedition down the Colorado River and through the Grand Canyon in 1869, he was confronted with a daunting landscape. At its highest point, the serpentine gorge plunged 1,829 meters (6,000 feet) from rim to river bottom, making it one of the deepest canyons in the United States. In just 6 million years, water had carved through rock layers that collectively represented more than 2 billion years of geological history, nearly half of the time Earth has existed.

gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")   #immagine del grand canyon da earth observatory, è immagine ,ultispettrale con piu bande, quindi uso brick

plotRGB(gc, r=1, g=2, b=3, stretch="lin")   #ricompongo le 3 bande in cui rosso=1 verde=2 blue=3 (di solito blu e rosso sono invertiti ma qua sono gia stati elaborati)
plotRGB(gc, r=1, g=2, b=3, stretch="hist")   #ho cambiato lo stretch da lin a hist e serve per una visualizzazione diversa perche aumento gli estremi e non è piu lineare(vedi lez 21.04 min 1.05.00)
#hist molto comodo per far rislatare i coloru delle immagini

gcc2 <- unsuperClass(gc, nClasses=2)   #unsuperclass è una funzione in cui la classificazione non è supervisionata--> dico al software di crearsi da solo le classi
#nSamples sono i nuovi pixel e sono diversi per ogniuno--> xlassificazione è diversa per tutti 
gcc2  #ha solo 2 valori che sono le due classi
#unsperclass resyitusice solo il "blocco" map (reg min 1.13.30)
plot(gcc2$map)  #lego la mappa al modello comn dollaro

#set.seed(17)  è una funzione che mantiene la classificazione

#exercise classify the map in 4 classes
gcc4 <- unsuperClass(gc, nClasses=4)
plot(gcc4$map)


#non mi piacciono i coloir allora cambio la classificazione con la palette
clc <- colorRampPalette(c("yellow", "red", "blue", "black"))
plot(gcc4$map, col=clc)   # MI DA QUESTO ERRORE (Error in col[x] : object of type 'closure' is not subsettable) 
#4 classi ho almeno 2 litologie, h20 e ombre, se volgio altri gruppi devo aumentare le classi
