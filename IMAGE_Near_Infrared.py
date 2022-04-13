
import glob
from os.path import isdir
import os
#import pygmt
import sys
from osgeo import ogr, osr, gdal, gdalconst, gdal_array
import numpy as np
import matplotlib.pyplot as plt

#data_dir='/home/changwan/IMAGE/'
#fp=os.path.join("LC08_L2SP_115035_20210323_20210402_02_T1_SR_B2.TIF")
#print (fp)
#os.chdir(data_dir)


#Define a function to normalize each band array by the 
#min and max values.

#b4_file = glob.glob('**_N.tif') #near infrared band
#b3_file = glob.glob('**B3.TIF') #green band
#b4_file = glob.glob('**B4.TIF') #red band

#print(b2_file)
#print(b3_file)
#print(b4_file)
#b2_file.type
#fp=os.path.join(data_dir, b4_file)

fp_r="/home/changwan/IMAGE/K3A_20200323060952_27569_00037135_L1R_R.tif"
fp_g="/home/changwan/IMAGE/K3A_20200323060952_27569_00037135_L1R_G.tif"
fp_b="/home/changwan/IMAGE/K3A_20200323060952_27569_00037135_L1R_B.tif"
fp_n="/home/changwan/IMAGE/K3A_20200323060952_27569_00037135_L1R_N.tif"


#print(fp)

def norm(band):
    band_min, band_max = band.min(), band.max()
    return ((band - band_min)/(band_max - band_min))

#Open each band using gdal
#list to string with "".join function
#b2_file="".join(b2_file)
#b3_file="".join(b2_file)
#b4_file="".join(b2_file)

#b2 = gdal.Open(b2_file)
#b3 = gdal.Open(b3_file)
b_r = gdal.Open(fp_r)
b_g = gdal.Open(fp_g)
b_b = gdal.Open(fp_b)
b_n = gdal.Open(fp_n)

#Call the norm function on each band as array converted to float          
b_r = norm(b_r.ReadAsArray().astype(float))
b_g = norm(b_g.ReadAsArray().astype(float))
b_b = norm(b_b.ReadAsArray().astype(float))
b_n = norm(b_n.ReadAsArray().astype(float))


np.seterr(divide='ignore', invalid='ignore')

#Band Ratio
#b_ratio = np.divide(b_r, b_n)

print(b_r.shape[1])
print(len(b_r))

xx = len(b_r)
yy = b_r.shape[1]

x_r = range(0, xx-1, 1)
y_r = range(0, yy-1, 1)

b_ratio = np.zeros([xx, yy])

for x in x_r:
 for y in y_r:    
  b_ratio[x,y] = b_r[x,y] / b_b[x,y]

#for x in range(0,100,1):
# for y in range(0,100,1):    
#  print(b_ratio[x,y])


#Create RGB
RGB = np.dstack((b_b,b_g,b_r))

# Visualize Band Ratio
"""
#plt.imshow(b_n[1000:3000,1000:3000], cmap='RdBu_r')
plt.subplot(2, 1, 1)
plt.imshow(b_ratio[1000:3000,1000:3000], cmap='RdBu_r')
#plt.imshow(b_ratio, cmap='RdBu_r')
plt.colorbar()

plt.subplot(2, 1, 2)
plt.imshow(RGB[1000:3000,1000:3000])

plt.tight_layout()
plt.show()     
"""

#Visualizea
"""
sx = 4000
sy = 4000
ex = 4000
ey = 4000
x = np.arange(0,1,0.1)
plt.scatter(b_n[sx:ex,sy:ey], b_r[sx:ex,sy:ey], marker = '+', color = "red")
plt.scatter(b_b[sx:ex,sy:ey], b_r[sx:ex,sy:ey], marker = '+', color = "blue")
plt.scatter(b_g[sx:ex,sy:ey], b_r[sx:ex,sy:ey], marker = '+', color = "green")
plt.plot(x,x, color = 'black')


#plt.subplot(1,3,1)
#plt.scatter(b_b,b_r)
#plt.title('B/R')
#plt.subplot(1,3,2)
#plt.scatter(b_g,b_r)
#plt.title('G/R')
#plt.subplot(1,3,3)
#plt.scatter(b_n,b_r)
#plt.title('N/R')
"""

px = 1 
py = 1 

spectra = np.zeros([x, xx])
ss = range(0, 4, 1)
print(ss)
for x in x_r:
 for s in ss:   
  spectra[s,x] = b_b[s, x] 
  spectra[s,x] = b_g[s, x] 
  spectra[s,x] = b_r[s, x]
  spectra[s,x] = b_n[s, x]

print(spectra[0:4,1000])

xt = [450, "520-600", "630-690", "760-900"]
#default_xticks = range(len(xt))
default_xticks = range(450,900,10)


plt.plot(spectra[0:4,1000:1010], marker='+')
plt.xticks(default_xticks,xt)
plt.show()

"""
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
"""
