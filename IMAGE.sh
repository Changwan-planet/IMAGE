#!/bin/bash

#path="K3A_20200907060727_30108_00027108_L1G/"
#fn="K3A_20200907060727_30108_00027108_L1G_R.tif"

path="Landsat8/"
path2="/home/changwan/IMAGE/"
fn="LC08_L2SP_115035_20210323_20210402_02_T1_SR_B"
ext=".TIF"
ext2=".TIF "

echo $path$fn\1$ext

##gdal_translate -of JPEG -co QUALITY=90 -co PROGRESSIVE=ON -outsize 1400 1400 -r bilinear \
##$path$fn\2$ext test.jpg 

#"-of" : set the output form
#"-co QUALITY : quality of 90 out of 100
#"-co PROGRASSIVE=ON" : load progressively

#"-outsize" : is set in the pixels--x(horizontal) first and y(vertical) second.

#"-r" : resampling method. bilinear is suitable for satellite image and it's
#quick and shapren as an additional step. 
#

#RGB COMPOSITION
gdal_merge.py -o $path2$fn\_rgb$ext -separate $path$fn\2$ext2\
$path$fn\3$ext2''$path$fn\4$ext2 \
-co PHOTOMETRIC=RGB -co COMPRESS=DEFLATE\
-a_nodata=100

#"-separate" : followed by the filenames for the bands we want
#"-c PHOTOMETRIC=RGB : interpret the colors correctly
#"-c COMPRESS=DEFLATE : is as small as possible without throwing away any data

#REORDER THE BANDS
##gdal_translate $path2$fn\_rgb$ext2 $path2$fn\_rgb2$ext2 -b 3 -b 2 -b 1 \
##-co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB

#"-co PHOTOMETRIC=RGB" : any image viewer will display the bands as red, green 
#blue (instead of an alpha channel of something).


#ALGORITHMIC IMAGE ENHANCEMENT
#gdal_translate $path2$fn\_rgb2$ext2 $path2$fn\_scaled3$ext2 -scale 0 65454 0 65535 \
#-exponent 1 -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB 

#"-scale min max 0 0 65535(16-bit): stretches each band equally 
#from a range of min-max to a range of 0-65535.
#"-exponent 0.5" : raise each band to the power of 1/2(square root) 
#It's a quick and dirty way to get a preview image.

#

