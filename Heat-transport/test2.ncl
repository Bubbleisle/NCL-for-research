f1=addfile("/mnt/f/CMIP6-data/vo/AWI-hist-1985-2014-summer-remap.nc", "r")

voh=f1->vo(0,:,:,:)
lat=f1->lat    
lon=f1->lon
depth=f1->depth
depth(0)=0
lev=dble2flt(depth)

latx=28
lons=120
lone=130
lonm=127
depthlev=34
dlm=15

vh1=voh(0:depthlev,{latx},{lons:lonm})
vh2=voh(0:depthlev,{latx},{lons:lone})

lonnum1=dimsizes(vh1)
lonnum=lonnum1(1);the size of the longitude dim,uesd in the loop
lonnum2=dimsizes(vh2)
lonnum2=lonnum2(1);the size of the longitude dim,uesd in the loop

print(lonnum)
print(lonnum2)
exit






x  = fspan(1.8, 3.4, 8)          ; generate 8 equally spaced values
dx = x(1)-x(0)
x@_FillValue=999
x(0)=x@_FillValue
w  = exp(x)
y=new((/2,3,10/),float,x@_FillValue)
m=dimsizes(y)
print(m(2))
printVarSummary(m)
exit

m=cumsum(y, 0)
print(m)
exit

simpeq_8 =simpeq(y,dx)  ; = 23.9175 
print(simpeq_8)

latx=35
lons=119
lone=127
vv=vo(:,{latx},{lons:lone})
lonnum1=dimsizes(vv)
lonnum=lonnum1(1)
q=0
w=0
do while(vv(q,w).not.ismissing .and. w.lt.lonnum)
    w=w+1
else
    q=q+1
    continue
depthlev=15