#!/bin/bash

#path="K3A_20200907060727_30108_00027108_L1G/"
#path2="/home/changwan/IMAGE/"
#fn="K3A_20200907060727_30108_00027108_L1G_"

path="/home/changwan/IMAGE/"
path2="/home/changwan/IMAGE/"

echo -e "ENTER YOUR FILE NAME"
read word
echo "YOUR FILE NAME: $word"

#fn="LC08_L2SP_115035_20210323_20210402_02_T1_SR_B"
#fn="LC08_L2SP_114036_20210316_20210328_02_T1_SR_B"
#fn="LC08_L2SP_114035_20210316_20210328_02_T1_SR_B"

fn=$word

fn2="test"
ext=".tif"
ext2=".tif "

echo $path$fn\_B$ext

##gdal_translate -of JPEG -co QUALITY=90 -co PROGRESSIVE=ON -outsize 1400 1400 -r bilinear \
##$path$fn\2$ext test.jpg 

#"-of" : set the output forma
#"-co QUALITY : quality of 90 out of 100
#"-co PROGRASSIVE=ON" : load progressively
#"-outsize" : is set in the pixels--x(horizontal) first and y(vertical) second.
#"-r" : resampling method. bilinear is suitable for satellite image and it's
#quick and shapren as an additional step. 


echo PANSNARPENIG
gdal_pansharpen.py $path2$fn\panshp$ext2 $path2$fn\scaled3$ext2 $path2$fn\panshp$ext2\
##-r bilinear -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB


: << "END"
echo RGB COMPOSITION
gdal_merge.py -o $path2$fn2\_rgb3$ext -separate $path$fn\_B$ext2\
$path$fn\_G$ext2 $path$fn\_R$ext2\
-co PHOTOMETRIC=RGB -co COMPRESS=DEFLATE

#"-separate" : followed by the filenames for the bands we want
#"-c PHOTOMETRIC=RGB : interpret the colors correctly
#"-c COMPRESS=DEFLATE : is as small as possible without throwing away any data



echo REORDER THE BANDS
gdal_translate $path2$fn2\_rgb3$ext2 $path2$fn2\_rgb4$ext2 -b 3 -b 2 -b 1 \
-co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB

#"-co PHOTOMETRIC=RGB" : any image viewer will display the bands as red, green 
#blue (instead of an alpha channel of something).


echo MIN_MAX
#AWK CODE
#FIND THE MAX AND MIN VALUES IN THE TIFF FILE
zMin=`gdalinfo -mm ./test_rgb4$ext2 | sed -ne 's/.*Computed Min\/Max=//p'| tr -d ' ' | cut -d "," -f 1 | cut -d . -f 1`

zMax=`gdalinfo -mm ./test_rgb4$ext2 | sed -ne 's/.*Computed Min\/Max=//p'| tr -d ' ' | cut -d "," -f 2 | cut -d . -f 1`

echo $zMin $zMax > min_max.txt

echo $zMin $zMax

#max_min in a row | $n->field 
#This awk code find the max (or min) value in a row
Max=`awk '{max = $1; {for (i=1; i<=NF; i++) {if ($i > max) max=$i }};\
print max}' min_max.txt` 

Min=`awk '{min = $1; {for (i=1; i<=NF; i++) {if ($i < min) min=$i }};\
print min}' min_max.txt`

echo $Max $Min

echo ALGORITHMIC IMAGE ENHANCEMENT
gdal_translate $path2$fn2\_rgb4$ext2 $path2$fn2\_scaled4$ext2 -scale $Min $Max 0 65535 \
-exponent 1 -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB 

#"-scale min max 0 0 65535(16-bit): stretches each band equally 
#from a range of min-max to a range of 0-65535.
#"-exponent 0.5" : raise each band to the power of 1/2(square root) 
#It's a quick and dirty way to get a preview image.

echo ALPAH BAND
#CREATE AN OUTPUT ALPHA BAND IDENTIFY NODATA (UNSET/TRANSPARENTS) PIXELS
#YOU SHOULD CHANGE THE FILE NAME AS NEW ONE
gdalwarp -srcnodata 0 -dstalpha $path2$fn2\_scaled4$ext2 $path2$fn2\_out2$ext2




#MOSAIC MULTIPLE RASTER DATASET
##gdal_merge.py -o test_merged.TIF test_merge1.TIF test_merge2.TIF


#REORDER THE BANDS
##gdal_translate $path2$fn2\_merged$ext2 $path2$fn2\_merged2$ext2 \
##-b 3 -b 2 -b 1 -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB



echo PANSNARPENIG
gdal_pansharpen.py $path$fn\panshp$ext2 $path2$fn\scaled3$ext2 $path2$fn\panshp$ext2\
##-r bilinear -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB
END










##gdalbuildvrt -addalpha test.vrt $path2$fn2\_scaled3$ext2 
##gdal_translate -b 1 -b 2 -b 3 -mask 4 test.vrt test_out.TIF 


##gdalbuildvrt -srcnodata "0 0 0" test.vrt $path2$fn2\_scaled3$ext2 
##gdal_translate test.vrt test_out.TIF 
##gdal_edit.py -unsetnodata test_out.TIF

##gdal_calc.py -A test_rgb2.TIF --outfile="alpha.TIF" --calc="0" --NoDataValue="0" \
##--type=UInt16

#gdal_calc.py -A $path2$fn2\_scaled3$ext2 --A_band=1 --outfile="alpha.TIF" \
#--calc="0" --type=UInt16u
##gdal_edit.py -unsetnodata alpha.TIF #
##gdal_merge.py -o test_out.TIF test_scaled3.TIF alpha.TIF  



#gdal_calc.py -A $path2$fn2\_out2$ext2 --A_band=4 --outfile="test_out3.TIF" \
#--calc="0" --NoDataValue="0"



#NODATA
#gdalbuildvrt -hidenodata /home/changwan/IMAGE/test.vrt LC08_L2SP_114035_20210316_20210328_02_T1_SR_B_rgb2.TIF
#gdal_translate -a_nodata 0 test.vrt output.TIF

#gdalbuildvrt -hidenodata /home/changwan/IMAGE/test2.vrt LC08_L2SP_114036_20210316_20210328_02_T1_SR_B_rgb2.TIF
#gdal_translate -a_nodata 0 test2.vrt output2.TIF 

#gdalbuildvrt -hidenodata -vrtnodata none /home/changwan/IMAGE/test.vrt \
#Landsat8_2/LC08_L2SP_114035_20210316_20210328_02_T1_SR_B2.TIF
#gdal_translate test.vrt output3.TIF
#gdal_translate -mask 1 test.vrt output3.TIF

#gdalbuildvrt -hidenodata -vrtnodata none /home/changwan/IMAGE/test.vrt \
#Landsat8_2/LC08_L2SP_114036_20210316_20210328_02_T1_SR_B2.TIF
#gdal_translate test.vrt output4.TIF

#CREATE AN OUTPUT ALPHA BAND IDENTIFY NODATA (UNSET/TRANSPARENTS) PIXELS
#gdalwarp -srcnodata 65535 -dstalpha $path2$fn2\_scaled3$ext2 $path2$fn2\_out$ext2


##gdal_edit.py -unsetnodata test_out.TIF 


