f1=addfile("/mnt/e/CMIP6-data/Timeline/AWI-1950-1984-remap-34l.nc", "r")
f2=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-CM4-1950-1984-remap-34l.nc","r")
f3=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-CM4-1950-1984-remap-34l.nc","r")
f4=addfile("/mnt/e/CMIP6-data/Timeline/MPI-1950-1984-remap-34l.nc","r");t
area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")

t1=f1->thetao(:,5,:,:);400-13 100-7
t2=f2->thetao(:,5,:,:)
t3=f3->thetao(:,5,:,:)
t4=f4->thetao(:,5,:,:)

lat=f1->lat
lon=f1->lon

delete(f1)
delete(f2)
delete(f3)
delete(f4)
t0=(t1+t2+t3+t4)/4
delete(t1)
delete(t2)
delete(t3)
delete(t4)
ta0=new((/35/), float,t0@_FillValue)

do i= 0,34,1
    ta0(i)=wgt_areaave(t0(i,:,:), area, 1, 0)
end do

filename = "/mnt/e/CMIP6-data/Temp timeline at average depth of 50m-hist1950-1984.txt"
alist = [/ta0/]
write_table(filename, "w", alist, "%7.4f")