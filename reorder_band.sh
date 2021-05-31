#!/bin/bash

echo -e "ENTER YOUR INPUT FILE"
read word_1
echo -e "ENTER YOUR THE NAME OF OUTPUT FILE"
read word_2

echo -e "ENTER THE FIRST BAND"
read word_3
echo -e "ENTER THE SECOND BAND"
read word_4
echo -e "ENTER THE THIRD BAND"
read word_5


gdal_translate $word_1 $word_2 -b $word_3 -b $word_4 -b $word_5 -co COMPRESS=DEFLATE -co PHOTOMETRIC=RGB

xdg-open $word_2
