#!/bin/bash
#THIS CODE MAKE THE ERROR#

echo -e "ENTER THE FILE PANCHROMETIC"
read word_1
echo -e "ENTER THE FILE OF RGB FILE"
read word_2

: <<END
echo -e "ENTER THE FILE OF BAND 3"
read word_3
echo -e "ENTER THE FILE OF BAND 4"
read word_4
word_1="LC08_L1TP_132027_20200327_20200409_01_T1_B8.TIF"
word_2="LC08_L1TP_132027_20200327_20200409_01_T1_B2.TIF"
word_3="LC08_L1TP_132027_20200327_20200409_01_T1_B3.TIF"
word_4="LC08_L1TP_132027_20200327_20200409_01_T1_B4.TIF"
END

path="/home/changwan/IMAGE/"


#gdal_pansharpen.py $path$word_1 $path$word_2 $path$word_3 $path$word_4 pan_out.TIF 

echo PANSHARPENING
gdal_pansharpen.py $word_1 $word_2 pan_out.TIF -r bilinear -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB

echo SCALE
gdal_translate pan_out.TIF pan_scaled4.TIF -scale 0 65535 0 65535 -exponent 1 -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB


echo ALPHA BAND AND NODATA=0
gdalwarp -srcnodata 0 -dstalpha pan_scaled4.TIF pan_final.TIF

xdg-open pan_final.TIF
