f1=addfile("/mnt/e/CMIP6-data/Timeline/AWI-1950-1984-remap-34l.nc", "r")
f2=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-CM4-1950-1984-remap-34l.nc","r")
f3=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-CM4-1950-1984-remap-34l.nc","r")
f4=addfile("/mnt/e/CMIP6-data/Timeline/MPI-1950-1984-remap-34l.nc","r");t

area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
aa=area(270:509)

t1=f1->thetao(:,0:10,{-45:-5},{105:160});200:13-2000:26
t2=f2->thetao(:,0:10,{-45:-5},{105:160})
t3=f3->thetao(:,0:10,{-45:-5},{105:160})
t4=f4->thetao(:,0:10,{-45:-5},{105:160})

delete(f1)
delete(f2)
delete(f3)
delete(f4)
ts=(t1+t2+t3+t4)/4
delete(t1)
delete(t2)
delete(t3)
delete(t4)

BT2=new((/35,240,221/), float,ts@_FillValue);time+lat+lon
BTs=new((/35/), float,ts@_FillValue)

do y=0,34,1
    do m = 0,239,1
        do n = 0,220,1
            if .not.ismissing(ts(y,10,m,n)) then 
                BT2(y,m,n)=ts@_FillValue        
            else if .not.ismissing(ts(y,1,m,n)) then; in ocean area
                i=1
                do while(i.le.9 .and. .not.ismissing(ts(y,i,m,n)))
                    i=i+1
                end do
                BT2(y,m,n)=ts(y,i-1,m,n)
            else 
                BT2(y,m,n)=ts@_FillValue         
            end if
            end if
        end do
    end do
end do

do i= 0,34,1
    BTs(i)=wgt_areaave(BT2(i,:,:), aa, 1, 0)
end do

filename = "/mnt/e/CMIP6-data/Timeline-Australia-hist1950-1984-200.txt"
slist = [/BTs/]
write_table(filename, "w", slist, "%8.3f")
exit
