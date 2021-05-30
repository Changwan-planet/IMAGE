#!/bin/bash


path="K3A_20200907060727_30108_00027108_L1G/"
path2="/home/changwan/IMAGE/"
fn="K3A_20200907060727_30108_00027108_L1G_"

#path="Landsat8/"
#path2="/home/changwan/IMAGE/"
#fn="LC08_L2SP_115035_20210323_20210402_02_T1_SR_B"
ext=".tif"
ext2=".tif "

echo $path$fn\R$ext

##gdal_translate -of JPEG -co QUALITY=90 -co PROGRESSIVE=ON -outsize 1400 1400 -r bilinear \
##$path$fn\2$ext test.jpg 

#"-of" : set the output forma
#"-co QUALITY : quality of 90 out of 100
#"-co PROGRASSIVE=ON" : load progressively

#"-outsize" : is set in the pixels--x(horizontal) first and y(vertical) second.

#"-r" : resampling method. bilinear is suitable for satellite image and it's
#quick and shapren as an additional step. 


#RGB COMPOSITION
##gdal_merge.py -o $path2$fn\rgbn$ext -separate $path$fn\B$ext2\
##$path$fn\G$ext2 $path$fn\R$ext2 $path$fn\N$ext2 \
##-co PHOTOMETRIC=RGB -co COMPRESS=DEFLATE

#"-separate" : followed by the filenames for the bands we want
#"-c PHOTOMETRIC=RGB : interpret the colors correctly
#"-c COMPRESS=DEFLATE : is as small as possible without throwing away any data

#REORDER THE BANDS
#gdal_translate $path2$fn\rgbn$ext2 $path2$fn\rgbn2$ext2 -b 3 -b 2 -b 1 \
#-co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB

#"-co PHOTOMETRIC=RGB" : any image viewer will display the bands as red, green 
#blue (instead of an alpha channel of something).


#ALGORITHMIC IMAGE ENHANCEMENT
##gdal_translate $path2$fn\rgb2$ext2 $path2$fn\scaled3$ext2 -scale 0 12344 0 65535 \
##-exponent 1 -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB 

#"-scale min max 0 0 65535(16-bit): stretches each band equally 
#from a range of min-max to a range of 0-65535.
#"-exponent 0.5" : raise each band to the power of 1/2(square root) 
#It's a quick and dirty way to get a preview image.


#FALSE-COLOR
gdal_translate $path2$fn\rgbn$ext2 $path2$fn\rgbn2$ext2 -b 4 -b 2 -b 3 \
-scale 0 14326 0 65535 -exponent 1 \
-co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB


#PANSNARPENING
##gdal_pansharpen.py $path$fn\panshp$ext2 $path2$fn\scaled3$ext2 $path2$fn\panshp$ext2\
##-r bilinear -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB




