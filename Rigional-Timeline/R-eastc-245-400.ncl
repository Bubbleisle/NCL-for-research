f1=addfile("/mnt/e/CMIP6-data/Timeline/AWI-ssp245-1981-2100-remap-34l.nc", "r")
f2=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-CM4-ssp245-1970-2100-remap-34l.nc","r")
f3=addfile("/mnt/e/CMIP6-data/Timeline/GFDL-ESM4-ssp245-1970-2100-remap-34l.nc","r")
f4=addfile("/mnt/e/CMIP6-data/Timeline/MPI-ssp245-1985-2100-remap-34l.nc","r");t

area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
aa=area(684:851)

t1=f1->thetao(4:119,0:10,{24:52},{277:318});200:13-2000:26
t2=f2->thetao(15:130,0:10,{24:52},{277:318})
t3=f3->thetao(15:130,0:10,{24:52},{277:318})
t4=f4->thetao(:,0:10,{24:52},{277:318})

ts=(t1+t2+t3+t4)/4
delete(t1)
delete(t2)
delete(t3)
delete(t4)

BT2=new((/116,168,165/), float,ts@_FillValue);time+lat+lon
BTs=new((/116/), float,ts@_FillValue)

do y=0,115,1
    do m = 0,167,1
        do n = 0,164,1
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

do i= 0,115,1
    BTs(i)=wgt_areaave(BT2(i,:,:), aa, 1, 0)
end do

filename = "/mnt/e/CMIP6-data/Timeline-Eastcoast-ssp245-200.txt"
slist = [/BTs/]
write_table(filename, "w", slist, "%8.3f")
exit
