from osgeo import gdal, gdalconst
#from osgeo import ogr
import sys, os


#import gdal
import numpy as np
import pandas as pd




os.chdir('/home/changwan/GMT/')


fn = 'YSF_reference_line.shp'
driver = ogr.GetDriverByName('ESRI Shapefile')
dataSource = driver.Open(fn, 0)
if dataSource is None:
    print( 'Could not open ' + fn)
    sys.exit(1) #exit with an error code
