fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")

d=fd->deptho
lat=fd->lat
lon=fd->lon
d!0="lat"
d!1="lon"
d&lat=lat
d&lon=lon

da=d({-45:-5},{105:160})
dc=d({2:42},{99:130})
dec=d({24:52},{277:318})
de=d({50:78},{0:54})

aa=area(270:509)
ac=area(552:791)
aec=area(684:851)
ae=area(840:1007)

da4=where(da.gt.200, d@_FillValue, da)
da2=where(da.gt.1000, d@_FillValue, da)
dc4=where(dc.gt.200, d@_FillValue, dc)
dc2=where(dc.gt.1000, d@_FillValue, dc)
dec4=where(dec.gt.200, d@_FillValue, dec)
dec2=where(dec.gt.1000, d@_FillValue, dec)
de4=where(de.gt.200, d@_FillValue, de)
de20=where(de.gt.1000, d@_FillValue, de)

da4a=wgt_areaave(da4, aa, 1, 0)
da2a=wgt_areaave(da2, aa, 1, 0)
dc4a=wgt_areaave(dc4, ac, 1, 0)
dc2a=wgt_areaave(dc2, ac, 1, 0)
dec4a=wgt_areaave(dec4, aec, 1, 0)
dec2a=wgt_areaave(dec2, aec, 1, 0)
de4a=wgt_areaave(de4, ae, 1, 0)
de2a=wgt_areaave(de20, ae, 1, 0)

filename = "/mnt/e/CMIP6-data/Average depth-2001000.txt"
alist = [/da4a,da2a,dc4a,dc2a,dec4a,dec2a,de4a,de2a/]
write_table(filename, "w", alist, "%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f")
