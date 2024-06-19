f1=addfile("/mnt/e/CMIP6-data/Timeline/AWI-ssp585-1981-2100-remap-34l.nc", "r")
f2=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-CM4-ssp585-1970-2100-remap-34l.nc","r")
f3=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-ESM4-ssp585-1970-2100-remap-34l.nc","r")
f4=addfile("/mnt/e/CMIP6-data/Timeline/MPI-ssp585-1985-2100-remap-34l.nc","r");t
area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")

t1=f1->thetao(4:119,10,:,:);400-13 100-7
t2=f2->thetao(15:130,10,:,:)
t3=f3->thetao(15:130,10,:,:)
t4=f4->thetao(:,10,:,:)

lat=f1->lat
lon=f1->lon

t0=(t1+t2+t3+t4)/4
;printVarSummary(t0)
ta0=new((/116/), float,t0@_FillValue)

do i= 0,115,1
    ta0(i)=wgt_areaave(t0(i,:,:), area, 1, 0)
end do

filename = "/mnt/e/CMIP6-data/Temp timeline at average depth of 585-200m.txt"
alist = [/ta0/]
write_table(filename, "w", alist, "%7.4f")