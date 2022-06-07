#installing and loading packages
install.packages("raster")
install.packages("viridis")
install.packages("lidR")
install.packages("sdm")
library(raster)
library(RStoolbox)
library(rasterdiv)
library(rgdal)
library(ggplot2)
library(patchwork)
library(viridis)
library(lidR)
library(sdm)


#setting working directory ("" are mandatory when calling a soruce external to R)
setwd("D:/lab/dati") 



?brick #fucnction to import a pack of data --> Create a RasterBrick object
l2011 <- brick ("p224r63_2011.grd")
l2011


plot(l2011) #plot is a generic function to represent an object in the space (x & y axis), also used for images

#valori bassi nero, alti bianco
#color ramp per scegliere colori
#colori in R https://www.r-graph-gallery.com/42-colors-names.html

colorRampPalette(c("black","grey", "light grey")) (100) #colorRamp is used for colors in R, here is use the function c to combine an array
cl <- colorRampPalette(c("black","grey", "light grey")) (100) # 100 is the number of colours 

plot(l2011, col=cl) #change rhe colour of the image by argument col=cl

#plotting a single band (blue band)

#start selecting the blue band B1_sre

l2011
plot(l2011$B1_sre) #plotting l2011

#alternative method to plot one band 
plot(l2011[[1]]) #select the first element 


#change colour to this plot 
cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
plot(l2011$B1_sre, col=cl)


#plot an image with a scale of blue
clblue <- colorRampPalette(c("dark blue", "dark cyan", "light blue")) (100)  #blue palette
plot(l2011$B1_sre, col=clblue)


#export the image as a pdf
pdf("banda1.pdf") #image saved in the working directory
plot(l2011$B1_sre, col=clblue)
dev.off() #closes the image creation process



#export the image as a pdf png
png("banda1.png")
plot(l2011$B1_sre, col=clblue)
dev.off()


#plot an image with a scale of green, for green band
clgreen <- colorRampPalette(c("dark green", "green", "light green")) (100) 
plot(l2011$B2_sre, col=clgreen)


#build a multiframe with band 1 and 2 colored respectively with blue and green
par(mfrow=c(1,2)) #par mfrow is used to create a multiframe, decide respectively the number of lines and column  within the c vector 
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
dev.off() 

#export pdf with the multiframe
pdf("multiframe.pdf")
par(mfrow=c(1,2))
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
dev.off()



#multiframe with one column and two lines blue band first, green band after

pdf("multiframe2.pdf")
par(mfrow=c(2,1)) #mfrow is used to arrange multiple plot in a multiframe with 1 line and 2 columns
plot(l2011$B2_sre, col=clgreen)
dev.off()

#plot an image with a scale of red
clred <- colorRampPalette(c("brown3", "brown2", "brown1")) (100) #palette in red 
plot(l2011$B3_sre, col=clred)

#??
#plot an image with a sc
clif <- colorRampPalette(c("red", "orange", "yellow")) (100)
plot(l2011$B4_sre, col=clif)


#multiframe with all the four bands
pdf("multiframe3.pdf")
par(mfrow=c(2,2))
plot(l2011$B1_sre, col=clblue)
plot(l2011$B2_sre, col=clgreen)
plot(l2011$B3_sre, col=clred)
plot(l2011$B4_sre, col=clif)
dev.off()


#plot of l2011 in the NIR channel 
plot(l2011$B4_sre)  #as an alternative use the indexing [4] plot(l2011$[[4]])

#setting up RGB layers 
#monto layers RGB  r=3 banda 3 è il rossp
plotRGB(l2011, r=3, g=2, b= 1, stretch = "lin")  #stretch is an argument to see values more clearly 
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")  #shift of the bands, vegetation reflects in the NIR--> set the NIR band in the red component (r=4)-->vegetation in red
plotRGB(l2011, r=3, g=4, b= 1, stretch = "lin")  #set the NIR band in the green component (g=4)-->vegetation is green 
plotRGB(l2011, r=3, g=3, b= 4, stretch = "lin")  #set the NIR band in the blue component (b=4)-->vegetation is blue, bare soil is yellow



plotRGB(l2011, r=3, g=4, b= 1, stretch = "hist") #stretch "hist" is used to increment the difference



#?
#multiframe with RGB visible piu immagini con RGB VISIBLE (colori naturali) 



par(mfrow=c(1,2))  #images along line
plotRGB(l2011, r=3, g=2, b= 1, stretch = "lin")
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")

pdf("multiframe5.pdf")
par(mfrow=c(2,1))  #images along columns
plotRGB(l2011, r=3, g=2, b= 1, stretch = "lin")
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")
dev.off()

#satellite image of 1988
l1988 <- brick("p224r63_1988.grd")
plot(l1988)

#multiframe to compare images of 2011 and 1988
pdf("multiframe6.pdf")
par(mfrow=c(2,1))  
plotRGB(l1988, r=4, g=3, b= 2, stretch = "lin")
plotRGB(l2011, r=4, g=3, b= 2, stretch = "lin")
dev.off()

#indice di vegetazione, salute della pianta è analizatta con i camb di lungh d'onde
#indice DVI= differncd veg index dato da diff tra riflettanza NIR  e riflett RED
#max biomassa la foglia riflette NIR #riflettanza alta in NIR e bassa in ROSSO
#se salute scarsa riflette eno quindi NIR riflesso diminuisce--> DVI cala


#TOPIC 2 SPECTRAL INDICES
install.packages("RStoolbox")
library(RStoolbox)

#import file defor1_.jpg 
l1992<-brick("defor1_.jpg")
plot(l1992)
l1992 #it has only 3 bands, 8 bit --> values from 0 to 255 #ha solo 3 bande, valori min 0 a max 255


#plot with RGB scheme
plotRGB(l1992, r=1, g=2, b=3, stretch = "lin")


#import file defor2_.jpg  
l2006<-brick("defor2_.jpg")
plot(l2006)
l2006
plotRGB(l2006, r=1, g=2, b=3, stretch = "lin")

#multiframe to compare images of 2006 and 1992
pdf("multiframe7.pdf")
par(mfrow=c(2,1))
plotRGB(l2006, r=1, g=2, b=3, stretch = "lin")
plotRGB(l1992, r=1, g=2, b=3, stretch = "lin")
dev.off()

#use NDVI to compare images with different bits but with the same range 

#RADIOMETRIC RESOLUTION to distinguish differences in light intensity, expressed in bit 
#high resolution means higher accuracy

#calculate DVI 1992
dvi1992 <- l1992[[1]] - l1992[[2]]   #(sarebbe NIR, elemento 1- RED, elemento 2)
dvi1992

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
# specifying a color scheme
plot(dvi1992, col=cl)

#calculate DVI 2006
dvi2006 <- l2006[[1]] - l2006[[2]]#NIR-RED
#or
dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2  #band 1- band 2
dvi2006

plot(dvi2006, col=cl)


#multiframe to compare dvi for 2006 and 1992
par(mfrow=c(2,1))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)  #note that yellow is bare soil-->strong deforestation

#differnce DVI for 2006 and 1992
dvi_dif <- dvi1992 - dvi2006
cld <- colorRampPalette(c('blue','white','red'))(100)


plot(dvi_dif, col=cld) 


#NDVI1992
ndvi1992 = dvi1992/ (l1992[[1]]+l1992[[2]])

#or
ndvi1992 = (l1992[[1]] - l1992[[2]]) / (l1992[[1]] + l1992[[2]])

plot(ndvi1992, col=cl)

#multiframe with plotRGB and NDVI
par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch = "lin")
plot(ndvi1992, col=cl)



#multiframe con plotRGB and ndvi

par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch = "lin")
plot(ndvi1992, col=cl)


ndvi2006 = dvi2006/ (l2006[[1]]+l2006[[2]])
plot(ndvi2006, col=cl)

#multiframe 2006
par(mfrow=c(2,1))
plotRGB(l2006, r=1, g=2, b=3, stretch = "lin")
plot(ndvi2006, col=cl)

#multiframe NDVI1992 e NDVI2006
par(mfrow=c(2,1))
plot(ndvi1992, col=cl)  
plot(ndvi2006, col=cl)  

#RStoolbox package to analyze data
#spectralIndices function to calucalte spectral indices like NDVI


.libPaths("C:/Program Files/R/R-4.1.2/library")

install.packages("RStoolbox")
install.packages("rasterdiv")
install.packages("rgdal")
library(RStoolbox)
library(rasterdiv)
library(rgdal)


si1992 <- spectralIndices(l1992, green=3, red=2, nir=1)
plot(si1992, col=cl)

si2006 <- spectralIndices(l2006, green=3, red=2, nir=1)
plot(si2006, col=cl)



#copNDVI è ndvi di copernicus, è raster a 8 bit e riguarda ndvi di un set (media dal 1999 al 2017)
#piu ce veg piu alto è lindice e quindi piu biomassa c'è --> stao ecositema è buono

plot(copNDVI) 
#copNDVI is ndvi of  copernicus # global biomass


#TOPIC 3 TIME SERIES ANALYSIS
#time series analysis of Greendland LST data
library(raster)
setwd("D:/lab/greenland")


#raster is used to to create a RasterLayer object

# BRICK is used for a satellite image with more bands  
# RASTER is used for a single layer 
lst2000 <- raster("lst_2000.tif")
lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

plot(lst2000)  

#plot all the four images

plot(lst2005)
plot(lst2010)
plot(lst2015)

cl2 <- colorRampPalette(c("blue", "lightblue", "pink", "red"))(100)
par(mfrow=c(2,2))  
plot(lst2000, col=cl2)  #for this year lower temaeratures are much extended
plot(lst2005, col=cl2)
plot(lst2010, col=cl2)
plot(lst2015, col=cl2)

#lapply is a function that thakes a list of files and applies a function on it

#create a list: list.files

rlist <- list.files(pattern = "lst")#pattern is a common characteristic for every file
rlist

import <- lapply(rlist, raster)

stack()  #blocco comune di tutti i dati

tgr <- stack(import)  #equal to rasterbrick but created in a  different way, instead of doing a mf, create a list, lapply and lastly stack

plot(tgr, col=cl2)#plotting without using a mf

plot(tgr$lst_2000, col=cl2)#plot first band 
#or
plot(tgr[[1]], col=cl2)

??
  plotRGB #plotto ai 3 colori
plotRGB(tgr, r=1, g=2, b=3, stretch = "lin")  # banda blu ho lst_2015


#TOPIC 3 NOX decreasing during lockdown
setwd("D:/lab/EN")

#during lockdown were registered lower emissions of NOX, whoch were derived from traffic.
#Sentinel12 is  a satellite with 10 meters resolution, which is able to misure NOx based on reflectance 

library(raster)
setwd("D:/lab/EN") 

# import image of January 2020
EN01 <- raster("EN_0001.png")
cl <- colorRampPalette(c('red','orange','yellow'))(100) 
plot(EN01, col=cl)
dev.off()

#last image before the end of the lockdown
EN13 <- raster("EN_0013.png") 
plot(EN13, col=cl)

# Import all the files separately 
EN01 <- raster("EN_0001.png")
EN02 <- raster("EN_0002.png")
EN03 <- raster("EN_0003.png")
EN04 <- raster("EN_0004.png")
EN05 <- raster("EN_0005.png")
EN06 <- raster("EN_0006.png")
EN07 <- raster("EN_0007.png")
EN08 <- raster("EN_0008.png")
EN09 <- raster("EN_0009.png")
EN10 <- raster("EN_0010.png")
EN11 <- raster("EN_0011.png")
EN12 <- raster("EN_0012.png")
EN13 <- raster("EN_0013.png")

# Plot all the files 
par(mfrow=c(4,4))
plot(EN01, col=cl)
plot(EN02, col=cl)
plot(EN03, col=cl)
plot(EN04, col=cl)
plot(EN05, col=cl)
plot(EN06, col=cl)
plot(EN07, col=cl)
plot(EN08, col=cl)
plot(EN09, col=cl)
plot(EN10, col=cl)
plot(EN11, col=cl)
plot(EN12, col=cl)
plot(EN13, col=cl)

# instead of importing separately use stack
EN <- stack(EN01, EN02, EN03, EN04, EN05, EN06, EN07, EN08, EN09, EN10, EN11, EN12, EN13)

# Plot the stack 
plot(EN, col=cl)

# Plot of the first image of the stack
plot(EN$EN_0001, col=cl)


# list.files creates a list with all the images which have EN in common
rlist <- list.files(pattern="EN")
rlist

# use lapply to apply function raster to all images in the list
list_rast <- lapply(rlist, raster)
list_rast

# create a stack with list of file raster
EN_stack <- stack(list_rast)
EN_stack


# Exercise: plot only the first image of the stack
cl <- colorRampPalette(c('red','orange','yellow'))(100)  
plot(EN_stack$EN_0001, col=cl)
# or
plot(EN_stack[[1]], col=cl)

# plot EN01 besides 13
par(mfrow=c(1,2))
plot(stack_EN$EN_0001, col=cl, main="inizio")
plot(stack_EN$EN_0013, col=cl, main="fine")
?plot
# oppure stack di due elementi

s_113 <- stack(stack_EN[[1]], stack_EN[[13]])
plot(s_113, col=cl) 

# difference between intial and final NOX values

difen <- stack_EN[[1]] - stack_EN[[13]]
# oppure: dif <- EN_stack$EN_0001 - EN_stack$EN_0013
cldif <- colorRampPalette(c('blue','white','red'))(100)
plot(difen, col=cldif) 

#european zones with stronger decrease

plotRGB(EN_stack, r=1, g=7, b=13, stretch="lin")
plotRGB(EN_stack, r=1, g=7, b=13, stretch="hist")

#TOPIC 4 CLASSIFICATION (passing from continous data to classes)
#pixel are plotted in cartesian graph, similar values are grouped together 

#water absorbs almost everything in the IR while it reflects in all the other bands (low values in IR becuse it absorbes)


library(raster)
library(RStoolbox)

setwd("D:/lab/") # Windows


so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")  #solar orbiter is a satellite sensor that registers data on sun movements 
so   #solar orbiter

plotRGB(so, 1,2,3, stretch="lin")   #rgb is omitted 

soc <- unsuperClass(so, nClasses=3)
plot(soc$map)

soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map,col=cl)

cl <- colorRampPalette(c('yellow','black','red'))(100)
plot(soc20$map,col=cl)

# Download Solar Orbiter data and proceed further!

# Grand Canyon
# https://landsat.visibleearth.nasa.gov/view.php?id=80948


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


#change colors witha  color palette
clc <- colorRampPalette(c("yellow", "red", "blue", "black"))
plot(gcc4$map, col=clc)   # MI DA QUESTO ERRORE (Error in col[x] : object of type 'closure' is not subsettable) 
#4 classi ho almeno 2 litologie, h20 e ombre, se volgio altri gruppi devo aumentare le classi




#TOPIC 5 LANDCOVER  #temporal analysis to investigate land use change 

library(raster)
library(RStoolbox) # package for classification
install.packages("ggplot2")
library(ggplot2)  #package for graphic restitution, in this case we use it to calculate frequencies
install.packages("gridExtra")
library(gridExtra) # for grid.arrange plotting
install.packages("patchwork") #used to do multiframe with multiple plots 
setwd("D:/lab/") # Windows
library(patchwork)


# NIR 1, RED 2, GREEN 3
#import defor 1,  image from 1992
l92 <- brick("defor1_.jpg")
plotRGB(l92, r=1, g=2, b=3, stretch="lin")

#build a multiframe with ggplot2 (package for elegant data illiustration)
ggRGB(l92, r=1, g=2, b=3, stretch="lin") #è plot RGB MA usa ggplot 2 che è pacchetto diverso #funz basata su pacchetto gg2 e rstoolbox, serve per fare multiframe in modo piu vrlovr

#import defor 2, image frmo 2006
l06 <- brick("defor2_.jpg")
plotRGB(l06, r=1, g=2, b=3, stretch="lin")
ggRGB(l06, r=1, g=2, b=3, stretch="lin")  

#build multiframe without ggplot
par(mfrow=c(1,2))
plotRGB(l92, r=1, g=2, b=3, stretch="lin")
plotRGB(l06, r=1, g=2, b=3, stretch="lin")

# multiframe with ggplot2 and gridExtra (assign p1 and p2 to the plots as if they were objects)
p1 <- ggRGB(l92, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(l06, r=1, g=2, b=3, stretch="lin")
p1+p2  #crated a multiframe with two plots next to each other thanks to patchwork
p1/p2  #crated a multiframe with two plots on top of each other thanks to patchwork
grid.arrange(p1, p2, nrow=2)

# unsupervised classification
l92c <- unsuperClass(l92, nClasses=2)  #it is important to define the number of classes, for example if i choose 2 classes one is water and bare soil and the other is vegetation
l92c #this is the classification model with two classes
plot(l92c$map)  #selection of the needed information from the model, in this case i selected the map
# class 2: forest (green)
# class 1: agriculture and water (white) (warning the classes could be swithed becuse are assigend automativally and randomly by the software)


l06c <- unsuperClass(l06, nClasses=2)
plot(l06c$map)
# class 1: agriculture and water (white)
# class 2: forest (green)


l06c3 <- unsuperClass(l06, nClasses=3)  #model with 3 classes
plot(d2c3$map)

#the classification is useful to calculate the area, counting the number of pixels with different colors ex: 15 pixel green (forest) and 2 pixel white (bare soil)

# frequencies, i calculate the number of pixels
freq(l92c$map)
#value  count
#[1,]     1  34017   #pixel class 1 agricultural land
#[2,]     2 307275   #pixel class 2 forest

freq(l06c$map)
#value  count
#[1,]     1 164162     #pixel class 1 agricultural land
#[2,]     2 178564     #pixel class 2 forest



s1 <- 306583 + 34709

prop1 <- freq(d1c$map) / s1
# proportion of forest: 0.8983012
# proprtion of agriculture: 0.1016988

s2 <- 342726
prop2 <- freq(d2c$map) / s2
# proportion of forest: 0.5206958
# proportion of agriculture: 0.4793042

# build a dataframe
cover <- c("Forest","Agriculture")   #classes 
percent_1992 <- c(89.83, 10.16)      #values in % for 1992
percent_2006 <- c(52.06, 47.93)      #values in % for 2006

percentages <- data.frame(cover, percent_1992, percent_2006)
percentages  #it's the dataframe

# let's plot them!
ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="white")
ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="white")

p1 <- ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="white")


grid.arrange(p1, p2, nrow=1)  


#TOPIC 6 VIARIABILITY 03.05.22
#variability measures on the Similaun, they represent differences between environment (grassland and pine forests)


#if data is numerous i obtain a normal distribution of data, where at the center there is the mean value and in the tail the variation that goes from 98 to 100%
#with variance i obtain the stretch of the curve 


library(raster)
library(RStoolbox) # for image viewing and variability calculation
library(ggplot2) # for ggplot plotting
library(patchwork)  #for multiframe

x <- c (21,22,23,24,25)
m <- (21+22+23+24+25) / 5  #mean it moves together with outlier values while median isn't influenced 


setwd("D:/lab/") # Windows
sen <- brick("sentinel_similaun.png")  #first band is NIR second is red and third green 

#plot the image by ggRGB function
ggRGB(sen, r=1,g=2,b=3)   #rgb e stretch can also be omitted


#in the image i clearly see the forest in red and the water in dark blue

#change the classification putting the vegetation green instead of red and the rock is violet
ggRGB(sen, r=2,g=1,b=3) 

#plot two images together in a multiframe 
g1 <- ggRGB(sen, r=1,g=2,b=3)
g2 <- ggRGB(sen, r=2,g=1,b=3) 
g1+g2 
g1/g2   

(g1+g2)/(g2+g1) #4 graphs, disrributed two by two

#to calcualte coefficent of variability i need a variable
#in this case we choose the bands as our variable, to select a few of them i can do a multivariate analysis or a NDVI

#calculate the variability for the NIR band (first element of the sentinel image)

nir <- sen[[1]]  #first element of the sentinel image
nir # calling nir i selct one out of  4  bands

#focal function   
#concept of the "moving window"  in which the orignal image (input image) and the window move calulating the pixels 

sd3 <- focal(nir, w=matrix(1/9, 3, 3), fun=sd)  #w èis the matrix (matrix of 3 pixel fot 3 pixel-> 9 pixel in total BUT the base unit is  1/9 pixel)  #fun is the function to calculate
#be carful in object naming (see sd case)

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(sd3, col=clsd)

#plotting with ggplot
# con geomraster i add the geometry i want(es: plot a barre, a punti...)
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer))  #ggplot is left emtpy, geom raster with the image and the graphics. mapping are the aestetics (how and what to put)
#fill is the type of fill in this case is the band
#zones of changes between grass and forests are valleys with high variability (light colour)


library(viridis)#package to simpify colour visulization

#images with scale of colours with viridis
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis() +
  ggtitle("Standard deviation by viridis package")
#change legend with option = "civilis", legend that higlights the maximum valules 
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option = "cividis") +
  ggtitle("Standard deviation by viridis package")

#images with scale colour inferno
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option = "inferno") +
  ggtitle("Standard deviation by viridis package")


sd7 <- focal(nir, ) #increase the window


#TOPIC 7 MULTIVARIATE ANALYSIS

#it is possbile to compact everything in a single band which is the most informative (the one i use to calulate variability)
#there are several types of MA, her ewe use PCA (princiapal component analysis), which selcts onyìly one dimension


setwd("D:/lab/dati")

library(raster)
library(RStoolbox)

p224r63_2011 <- brick("p224r63_2011_masked.grd")
plot(p224r63_2011)  #here i see there are 7 bands 

#resampling, from a high number of pixel (30 mln) i need to reduce it by decreasig the resolution (resampling works in blocks which give the mean of all the pixels )
l

p224r63_2011res <- aggregate(p224r63_2011, fact=10) 
p224r63_2011res100 <- aggregate(p224r63_2011, fact=100) 

#assinig  objects to build multiframes
g1 <- ggRGB(p224r63_2011, 4,3,2)
g2 <- ggRGB(p224r63_2011res, 4,3,2)
g3 <- ggRGB(p224r63_2011res100, 4,3,2)

#building muliframes
g1+g2
g1+g2+g3


#PCA analysis

p224r63_2011respca <- rasterPCA(p224r63_2011res) #i created an object from a  model 
p224r63_2011respca   

summary(p224r63_2011respca$model)  #gives me the information on the model
#proportion of variance, how much variance is explained by each component 
#PC1 is the new visualization with the first main component, PC7 has no information just backround noise 
plot(p224r63_2011respca$map)

ggplot() + geom_raster(p224r63_2011respca$map, mapping = aes(x=x, y=y, fill=PC1)) + scale_fill_viridis(option = "cividis") +
  ggtitle("PC1")
g1 <- ggplot() + geom_raster(p224r63_2011respca$map, mapping = aes(x=x, y=y, fill=PC1)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC1")  #it conservs all the info

g2 <- ggplot() + geom_raster(p224r63_2011respca$map, mapping = aes(x=x, y=y, fill=PC7)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC7")  #it is monoclor becuse it loeses all the info

g1+g2


g3 <- ggplot() + geom_raster(p224r63_2011res, mapping = aes(x=x, y=y, fill=B4_sre)) + scale_fill_viridis(option = "inferno") +
  ggtitle("NIR")  #here i select band 4 which is the NIR band 

g1+g3  #where the Nir reflectance is higher,  PC1 is lower becuse they are INV correlated

#warning: 
#attenzione: se guardo valori delle componenti vedo nel plot del NIR i valori di riflettanza nella leggenda mentre per PC1 non hanno significato sono solo valori su una classe

g4 <- ggRGB(p224r63_2011res, 4,3,2)

g1+g4  #the forest corresponds to lower values of PCA (with resampled image)

g5 <- ggRGB(p224r63_2011, 4,3,2)

g1+g5#the forest corresponds to lower values of PCA (with otignal image)

g5 <- ggRGB(p224r63_2011, 2,3,4,)  # invert 2 and 4--> put infrared in the blue component 


g5 <- ggRGB(p224r63_2011, 2,3,4, stretch = "hist")  #use streth to increas the contrast
g1+g5

plotRGB(p224r63_2011, 2,3,4, stretch="lin") #this is quite similar to PCA this means that PCA effectively inclued most of the info


plotRGB(p224r63_2011respca$map, 1,2,3, stretch = "lin")   #max info possible, here i calcualte the variability, colors do not have  a significance because they just represent the 3 components


#VARAIBILITY 2 on multivariate bands

library(raster)
library(RStoolbox)

setwd("D:/lab/")

siml <- brick("sentinel_similaun.png")

#NIR 1
#red 2
#green 3

ggRGB(siml, 1,2,3)
ggRGB(siml, 3,1,2) #per evidenziare suolo nudo inverto  ordine NIR e infrarosso nel verde  (suolo diventa viola)


#calculate PCA on this iamge

simlPCA <- rasterPCA(siml)
simlPCA  #call model

#how much variance is represneted by each componet
summary(simlPCA$model)   #comp 1 explains only 77% 

g1 <- ggplot() + geom_raster(simlPCA$map, mapping = aes(x=x, y=y, fill=PC1)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC1") #higher values corrlated to vegetation

g3 <-  ggplot() + geom_raster(simlPCA$map, mapping = aes(x=x, y=y, fill=PC3)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC3")   #with PC3 the band gives few info

g2 <-  ggplot() + geom_raster(simlPCA$map, mapping = aes(x=x, y=y, fill=PC2)) + scale_fill_viridis(option = "inferno") +
  ggtitle("PC2")

g1+g3

#caluclate variability on PC1
pc1 <- simlPCA$map[[1]]

sd3 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)

ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option = "inferno") +
  ggtitle("Standard deviation of PC1")   #highlights the point with higher variability--> shows a discontinuity

#this methods of MA can also applied to tables


#TOPIC DATI LIDAR 20.05

setwd("D:/lab/")
dsm_2013 <- raster("D:/lab/dati_lidar/2013Elevation_DigitalElevationModel-0.5m.tif")
dsm_2013  #info digital surface model

dtm_2013 <- raster("D:/lab/dati_lidar/2013Elevation_DigitalTerrainModel-0.5m.tif")


chm_2013 <- dsm_2013 - dtm_2013

chm_2013

ggplot() + geom_raster(chm_2013, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis() +
  ggtitle("CHM 2013 San Genesio")
#i see houses, plants and agricoltural fields


#data from 2004 with lower resolution
dsm_2004 <- raster("D:/lab/dati_lidar/2004Elevation_DigitalElevationModel-2.5m.tif")
dtm_2004 <- raster("D:/lab/dati_lidar/2004Elevation_DigitalTerrainModel-2.5m.tif")

chm_2004 <- dsm_2004 - dtm_2004

ggplot() + geom_raster(chm_2004, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis() +
  ggtitle("CHM 2004 San Genesio")

#difference chm_2004 e chm_2013
diff_chm <- chm_2013-chm_2004  #they have different resolution so before calualting i need to do a resampling 

#resample of 2013 to 2004, i keep the lower resolution
chm_2013r <- resample(chm_2013, chm_2004)  #resamplign an image on the base of the other


diff_chm <- chm_2013r-chm_2004

ggplot() + geom_raster(diff_chm, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis() +
  ggtitle("CHM differnce") #dark areas are decreasing(deforestation) while light areas  are increasing (growinn forests)

#reading the point cloud
point_cloud <- readLAS("D:/lab/dati_lidar/point_cloud.laz")
plot(point_cloud)
