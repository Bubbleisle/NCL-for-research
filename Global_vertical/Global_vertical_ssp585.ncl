
f1=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-ssp585-2071-2100-remap-34l-ave.nc","r");t;d
f2=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-ssp585-2071-2100-remap-34l-ave.nc","r")
f3=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-ESM4-ssp585-2071-2100-remap-34l-ave.nc","r")
f4=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-ssp585-2071-2100-remap-34l-ave.nc","r");t

fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")

t1=f1->thetao(:,:,:)
t2=f2->thetao(:,:,:)
t3=f3->thetao(0,:,:,:)
t4=f4->thetao(0,:,:,:)

ts2=(t1+t2+t3+t4)/4
ts2v=new((/34/),float,ts2@_FillValue)
;计算总深度只需要把下面一个循环给注释掉，修改filename即可，同样1000m以浅的深度就需要计算下面的循环，注意filename是否修改

do m = 0,1079,1
    do n = 0,1439,1
        if .not.ismissing(ts2(20,m,n)) then
            ts2(0:33,m,n)=ts2@_FillValue
        end if 
    end do
end do
;/

do i = 0,33
    ts2v(i)=wgt_areaave(ts2(i,:,:), area, 1, 0)
end do 

filename = "/mnt/e/CMIP6-data/Vertical-1000m-ssp585.txt"
slist = [/ts2v/]
write_table(filename, "w", slist, "%8.3f")
