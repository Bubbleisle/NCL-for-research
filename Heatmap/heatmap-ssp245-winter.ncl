f1=addfile("/mnt/e/CMIP6-data/Heatmap/winter/AWI-2071-2100-winter-remap-17l-ave.nc", "r"); float thetao ( time, depth, lat, lon )_FillValue :   1e+30
f2=addfile("/mnt/e/CMIP6-data/Heatmap/winter/GFDL-CM4-2071-2100-winter-remap-17l-ave.nc", "r")
f3=addfile("/mnt/e/CMIP6-data/Heatmap/winter/GFDL-ESM4-2071-2100-winter-remap-17l-ave.nc", "r")
f4=addfile("/mnt/e/CMIP6-data/Heatmap/winter/MPI-2071-2100-winter-remap-17l-ave.nc", "r")
f5=addfile("/mnt/e/CMIP6-data/Heatmap/winter/AWI-1985-2014-winter-remap-17l-ave.nc", "r")
f6=addfile("/mnt/e/CMIP6-data/Heatmap/winter/GFDL-CM4-1985-2014-winter-remap-17l-ave.nc", "r")
f7=addfile("/mnt/e/CMIP6-data/Heatmap/winter/GFDL-ESM4-1985-2014-winter-remap-17l-ave.nc", "r")
f8=addfile("/mnt/e/CMIP6-data/Heatmap/winter/MPI-1985-2014-winter-remap-17l-ave.nc", "r")

f11=addfile("/mnt/e/CMIP6-data/Heatmap/summer/AWI-2071-2100-summer-remap-17l-ave.nc", "r"); float thetao ( time, depth, lat, lon )_FillValue :   1e+30
f21=addfile("/mnt/e/CMIP6-data/Heatmap/summer/GFDL-CM4-2071-2100-summer-remap-17l-ave.nc", "r")
f31=addfile("/mnt/e/CMIP6-data/Heatmap/summer/GFDL-ESM4-2071-2100-summer-remap-17l-ave.nc", "r")
f41=addfile("/mnt/e/CMIP6-data/Heatmap/summer/MPI-2071-2100-summer-remap-17l-ave.nc", "r")
f51=addfile("/mnt/e/CMIP6-data/Heatmap/summer/AWI-1985-2014-summer-remap-17l-ave.nc", "r")
f61=addfile("/mnt/e/CMIP6-data/Heatmap/summer/GFDL-CM4-1985-2014-summer-remap-17l-ave.nc", "r")
f71=addfile("/mnt/e/CMIP6-data/Heatmap/summer/GFDL-ESM4-1985-2014-summer-remap-17l-ave.nc", "r")
f81=addfile("/mnt/e/CMIP6-data/Heatmap/summer/MPI-1985-2014-summer-remap-17l-ave.nc", "r")

ar=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
area=ar(150:929)
lev=f1->depth
t1=f1->thetao(0,:,{0:65},:)
t2=f2->thetao(0,:,{0:65},:)
t3=f3->thetao(0,:,{0:65},:)
t4=f4->thetao(0,:,{0:65},:)
t5=f5->thetao(0,:,{0:65},:)
t6=f6->thetao(0,:,{0:65},:)
t7=f7->thetao(0,:,{0:65},:)
t8=f8->thetao(0,:,{0:65},:)
t11=f11->thetao(0,:,{-65:0},:)
t21=f21->thetao(0,:,{-65:0},:)
t31=f31->thetao(0,:,{-65:0},:)
t41=f41->thetao(0,:,{-65:0},:)
t51=f51->thetao(0,:,{-65:0},:)
t61=f61->thetao(0,:,{-65:0},:)
t71=f71->thetao(0,:,{-65:0},:)
t81=f81->thetao(0,:,{-65:0},:)

d1=new((/17,780,1440/), float, 0)
d2=new((/17,780,1440/), float, 0)
d3=new((/17,780,1440/), float, 0)
d4=new((/17,780,1440/), float, 0)
d5=new((/17,780,1440/), float, 0)
d6=new((/17,780,1440/), float, 0)
d7=new((/17,780,1440/), float, 0)
d8=new((/17,780,1440/), float, 0)
d1(:,0:389,:)=t1
d1(:,390:779,:)=t11
d2(:,0:389,:)=t2
d2(:,390:779,:)=t21
d3(:,0:389,:)=t3
d3(:,390:779,:)=t31
d4(:,0:389,:)=t4
d4(:,390:779,:)=t41
d5(:,0:389,:)=t5
d5(:,390:779,:)=t51
d6(:,0:389,:)=t6
d6(:,390:779,:)=t61
d7(:,0:389,:)=t7
d7(:,390:779,:)=t71
d8(:,0:389,:)=t8
d8(:,390:779,:)=t81

ts=(d1+d2+d3+d4)/4
th=(d5+d6+d7+d8)/4

delete(t1)
delete(t2)
delete(t3)
delete(t4)
delete(t5)
delete(t6)
delete(t7)
delete(t8)
delete(t11)
delete(t21)
delete(t31)
delete(t41)
delete(t51)
delete(t61)
delete(t71)
delete(t81)
delete(d1)
delete(d2)
delete(d3)
delete(d4)
delete(d5)
delete(d6)
delete(d7)
delete(d8)

ts4d=new((/17,17,780,1440/),float,ts@_FillValue)
th4d=new((/17,17,780,1440/),float,ts@_FillValue)

do m=0,779,1
    do n=0,1439,1
        i=0
        do while (.not.ismissing(ts(i+1,m,n)));.and. i.lt.30)
            i=i+1
        end do
        ts4d(i,:,m,n)=ts(:,m,n)
    end do
end do

do m=0,779,1
    do n=0,1439,1
        i=0
        do while (.not.ismissing(th(i+1,m,n)));.and. i.lt.30)
            i=i+1
        end do
        th4d(i,:,m,n)=th(:,m,n)
    end do
end do

ss=new((/16,16/),float,0)
hh=new((/16,16/),float,0)
layer=new((/16/),float,0)
dd=new((/16,16/),float,0)

do i=0,15,1
    do j=0,15,1
        ss(i,j)=wgt_areaave(ts4d(i,j,:,:), area, 1, 0);opt=1 means compute the weighted mean of all non-missing values; 
        hh(i,j)=wgt_areaave(th4d(i,j,:,:), area, 1, 0);opt=1 means compute the weighted mean of all non-missing values; 
    end do
end do 
cc=ss-hh
cc@_FillValue=0

do i=0,15,1
    lay=ts(i,:,:)-th(i,:,:)
    layer(i)=wgt_areaave(lay, area, 1, 0)
    dd(:,i)=cc(:,i)-layer(i)
end do

filename = "/mnt/e/CMIP6-data/Heatmap-ssp245-winters-6565-17l.txt"

slist = [/ss(0,:),ss(1,:),ss(2,:),ss(3,:),ss(4,:),ss(5,:),ss(6,:),ss(7,:),ss(8,:),ss(9,:),ss(10,:),ss(11,:),ss(12,:),ss(13,:),ss(14,:),ss(15,:)/]
hlist = [/hh(0,:),hh(1,:),hh(2,:),hh(3,:),hh(4,:),hh(5,:),hh(6,:),hh(7,:),hh(8,:),hh(9,:),hh(10,:),hh(11,:),hh(12,:),hh(13,:),hh(14,:),hh(15,:)/]
clist = [/cc(0,:),cc(1,:),cc(2,:),cc(3,:),cc(4,:),cc(5,:),cc(6,:),cc(7,:),cc(8,:),cc(9,:),cc(10,:),cc(11,:),cc(12,:),cc(13,:),cc(14,:),cc(15,:)/]
dlist = [/dd(0,:),dd(1,:),dd(2,:),dd(3,:),dd(4,:),dd(5,:),dd(6,:),dd(7,:),dd(8,:),dd(9,:),dd(10,:),dd(11,:),dd(12,:),dd(13,:),dd(14,:),dd(15,:)/]
llist = [/layer/]
write_table(filename, "w", hlist, "%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f")
write_table(filename, "a", clist, "%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f")
write_table(filename, "a", dlist, "%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f")
write_table(filename, "a", slist, "%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f,%7.5f")
write_table(filename, "a", llist, "%7.5f")