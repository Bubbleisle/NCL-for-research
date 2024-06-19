f5=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-hist-1985-2014-remap-34l-ave.nc","r");t;d
f6=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-hist-1985-2014-remap-34l-ave.nc","r")
f7=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-ESM4-hist-1985-2014-remap-34l-ave.nc","r")
f8=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-HR-hist-1985-2014-remap-34l-ave.nc","r");t
fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
t5=f5->thetao(0,:,:,:)
t6=f6->thetao(:,:,:)
t7=f7->thetao(:,:,:)
t8=f8->thetao(0,:,:,:)
th=(t5+t6+t7+t8)/4

delete(t5)
delete(t6)
delete(t7)
delete(t8)

thv=new((/34/),float,th@_FillValue)
;计算总深度只需要把下面一个循环给注释掉，修改filename即可，同样1000m以浅的深度就需要计算下面的循环，注意filename是否修改
/;
do m = 0,1079,1
    do n = 0,1439,1
        if .not.ismissing(th(20,m,n)) then
            th(0:33,m,n)=th@_FillValue
        end if 
    end do
end do
;/
do i = 0,33
    thv(i)=wgt_areaave(th(i,:,:), area, 1, 0)
end do 


filename = "/mnt/e/CMIP6-data/Vertical-5500m-historical.txt"
slist = [/thv/]
write_table(filename, "w", slist, "%8.3f")

