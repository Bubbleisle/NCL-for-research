f1=addfile("/mnt/e/CMIP6-data/mlotst/summer/AWI-hist-1985-2014-summer-remap-ave.nc", "r")
f2=addfile("/mnt/e/CMIP6-data/mlotst/summer/GFDL-CM4-hist-1985-2014-summer-remap-ave.nc", "r")
f3=addfile("/mnt/e/CMIP6-data/mlotst/summer/GFDL-ESM4-hist-1985-2014-summer-remap-ave.nc", "r")
f4=addfile("/mnt/e/CMIP6-data/mlotst/summer/MPI-hist-1985-2014-summer-remap-ave.nc", "r")
f5=addfile("/mnt/e/CMIP6-data/mlotst/summer/AWI-ssp585-2071-2100-summer-remap-ave.nc", "r")
f6=addfile("/mnt/e/CMIP6-data/mlotst/summer/GFDL-ESM4-ssp585-2071-2100-summer-remap-ave.nc", "r")
f7=addfile("/mnt/e/CMIP6-data/mlotst/summer/MPI-ssp585-2071-2100-summer-remap-ave.nc", "r")
f8=addfile("/mnt/e/CMIP6-data/mlotst/summer/GFDL-CM4-ssp585-2071-2100-summer-remap-ave.nc", "r")

ar=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
area=ar(150:929)

f11=addfile("/mnt/e/CMIP6-data/mlotst/winter/AWI-hist-1985-2014-winter-remap-ave.nc", "r")
f12=addfile("/mnt/e/CMIP6-data/mlotst/winter/GFDL-CM4-hist-1985-2014-winter-remap-ave.nc", "r")
f13=addfile("/mnt/e/CMIP6-data/mlotst/winter/GFDL-ESM4-hist-1985-2014-winter-remap-ave.nc", "r")
f14=addfile("/mnt/e/CMIP6-data/mlotst/winter/MPI-hist-1985-2014-winter-remap-ave.nc", "r")
f15=addfile("/mnt/e/CMIP6-data/mlotst/winter/AWI-ssp585-2071-2100-winter-remap-ave.nc", "r")
f16=addfile("/mnt/e/CMIP6-data/mlotst/winter/GFDL-ESM4-ssp585-2071-2100-winter-remap-ave.nc", "r")
f17=addfile("/mnt/e/CMIP6-data/mlotst/winter/MPI-ssp585-2071-2100-winter-remap-ave.nc", "r")
f18=addfile("/mnt/e/CMIP6-data/mlotst/winter/GFDL-CM4-ssp585-2071-2100-winter-remap-ave.nc", "r")


ff1=addfile("/mnt/e/CMIP6-data/Heatmap/AWI-ssp585-2071-2100-remap-17l-ave.nc", "r"); float thetao ( time, depth, lat, lon )_FillValue :   1e+30
ff2=addfile("/mnt/e/CMIP6-data/Heatmap/GFDL-CM4-ssp585-2071-2100-remap-17l-ave.nc", "r"); float thetao ( lev, lat, lon )_FillValue :   1e+20
ff3=addfile("/mnt/e/CMIP6-data/Heatmap/GFDL-ESM4-ssp585-2071-2100-remap-17l-ave.nc", "r")
ff4=addfile("/mnt/e/CMIP6-data/Heatmap/MPI-ssp585-2071-2100-remap-17l-ave.nc", "r")

t1=ff1->thetao(:,:,:)
t2=ff2->thetao(:,:,:)
t3=ff3->thetao(0,:,:,:)
t4=ff4->thetao(0,:,:,:)
ts=(t1+t2+t3+t4)/4

d10=f1->mlotst(0,{0:65},:)
d20=f2->mlotst(0,{0:65},:)
d30=f3->mlotst(0,{0:65},:)
d40=f4->mlotst(0,{0:65},:)
d50=f5->mlotst(0,{0:65},:)
d60=f6->mlotst(0,{0:65},:)
d70=f7->mlotst(0,{0:65},:)
d80=f8->mlotst(0,{0:65},:)

d11=f11->mlotst(0,{-65:0},:)
d12=f12->mlotst(0,{-65:0},:)
d13=f13->mlotst(0,{-65:0},:)
d14=f14->mlotst(0,{-65:0},:)
d15=f15->mlotst(0,{-65:0},:)
d16=f16->mlotst(0,{-65:0},:)
d17=f17->mlotst(0,{-65:0},:)
d18=f18->mlotst(0,{-65:0},:)

d1=new((/780,1440/), float, 0)
d2=new((/780,1440/), float, 0)
d3=new((/780,1440/), float, 0)
d4=new((/780,1440/), float, 0)
d5=new((/780,1440/), float, 0)
d6=new((/780,1440/), float, 0)
d7=new((/780,1440/), float, 0)
d1(0:389,:)=d10
d1(390:779,:)=d11
d2(0:389,:)=d20
d2(390:779,:)=d12
d3(0:389,:)=d30
d3(390:779,:)=d13
d4(0:389,:)=d40
d4(390:779,:)=d14
d5(0:389,:)=d50
d5(390:779,:)=d15
d6(0:389,:)=d60
d6(390:779,:)=d16
d7(0:389,:)=d70
d7(390:779,:)=d17


dh=(d1+d2+d3+d4)/4
ds=(d5+d6+d7)/3
ds4d=new((/17,780,1440/),float,ts@_FillValue)
dh4d=new((/17,780,1440/),float,ts@_FillValue)

do m=0,779,1
    do n=0,1439,1
        if ismissing(ts(0,m,n)) then 
            ds4d(0,m,n)=ds(m,n)
            dh4d(0,m,n)=dh(m,n)
        else        
            i=0
            do while (.not.ismissing(ts(i,m,n)));.and. i.lt.30)
                i=i+1
            end do
            ds4d(i-1,m,n)=ds(m,n)
            dh4d(i-1,m,n)=dh(m,n)
        end if 
    end do
end do

ss=new((/16/),float,0)
hh=new((/16/),float,0)

do i=0,15,1
        ss(i)=wgt_areaave(ds4d(i,:,:), area, 1, 0);opt=1 means compute the weighted mean of all non-missing values; 
        hh(i)=wgt_areaave(dh4d(i,:,:), area, 1, 0);opt=1 means compute the weighted mean of all non-missing values; 
end do 

filename = "/mnt/e/CMIP6-data/MLD-ssp585-summer-6565.txt"

slist = [/ss/]
hlist = [/hh/]

write_table(filename, "w", slist, "%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f")
write_table(filename, "a", hlist, "%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f,%7.2f")
exit

