#!/usr/bin/env python
import glob
from os.path import isdir
import os
import pygmt
import sys
from osgeo import ogr, osr, gdal, gdalconst, gdal_array
import numpy as np
import matplotlib.pyplot as plt

data_dir='/home/changwan/IMAGE/Landsat8'
#fp=os.path.join("LC08_L2SP_115035_20210323_20210402_02_T1_SR_B2.TIF")
#print (fp)
os.chdir(data_dir)


#Define a function to normalize each band array by the 
#min and max values.

b2_file = glob.glob('**B2.TIF') #blue band
b3_file = glob.glob('**B3.TIF') #green band
b4_file = glob.glob('**B4.TIF') #red band

print(b2_file)
print(b3_file)
print(b4_file)
#b2_file.type
#fp=os.path.join(data_dir + b2_file)
#print(fp)

def norm(band):
    band_min, band_max = band.min(), band.max()
    return ((band - band_min)/(band_max - band_min))

#Open each band using gdal
#list to string with "".join function
b2_file="".join(b2_file)
b3_file="".join(b2_file)
b4_file="".join(b2_file)

b2 = gdal.Open(b2_file)
b3 = gdal.Open(b3_file)
b4 = gdal.Open(b4_file)

#Call the norm function on each band as array converted to float          
b2 = norm(b2.ReadAsArray().astype(float))
b3 = norm(b3.ReadAsArray().astype(float))
b4 = norm(b4.ReadAsArray().astype(float))

 #Create RGB
RGB=np.dstack((b4,b3,b2))
       
#    del b2, b3, b4
               
# Visualize RGB
plt.imshow(RGB)
plt.show()    
    

    # Export RGB as TIFF file
    # Important: Here is where you can set the custom stretch
    # I use min as 2nd percentile and max as 98th percentile
    #sm.toimage(rgb,cmin=np.percentilnumpy.ndarray' object has no attribute 'ReadAsArraye(rgb,2),cmax=np.percentile(rgb,98)).save(b2_file[i].split('_01_')[0]+'_RGB.tif')
RGB.min()    

#Get nodata value from the GDAL band object
nodata = RGB.GetNoDataValue()

#Create a masked array for making calculations without nodata values
RGB = np.ma.masked_equal(RGB,nodata)
type(RGB)
