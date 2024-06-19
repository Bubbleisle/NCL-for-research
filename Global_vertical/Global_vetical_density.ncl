
;read in temp file ----ts&th
    f1=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-ssp585-2071-2100-remap-34l-ave.nc","r");t;d
    f2=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-ssp585-2071-2100-remap-34l-ave.nc","r")
    f3=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-ESM4-ssp585-2071-2100-remap-34l-ave.nc","r")
    f4=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-ssp585-2071-2100-remap-34l-ave.nc","r");t
    f5=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-hist-1985-2014-remap-34l-ave.nc","r");t;d
    f6=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-hist-1985-2014-remap-34l-ave.nc","r")
    f7=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-ESM4-hist-1985-2014-remap-34l-ave.nc","r")
    f8=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-HR-hist-1985-2014-remap-34l-ave.nc","r");t
    fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
    t1=f1->thetao(0:20,:,:)
    t2=f2->thetao(0:20,:,:)
    t3=f3->thetao(0,0:20,:,:)
    t4=f4->thetao(0,0:20,:,:)
    t5=f5->thetao(0,0:20,:,:)
    t6=f6->thetao(0:20,:,:)
    t7=f7->thetao(0:20,:,:)
    t8=f8->thetao(0,0:20,:,:)
    lat=f1->lat
    lon=f1->lon
    ts=(t1+t2+t3+t4)/4
    th=(t5+t6+t7+t8)/4
    delete(t1)
    delete(t2)
    delete(t3)
    delete(t4)
    delete(t5)
    delete(t6)
    delete(t7)
    delete(t8)
    delete(f1)
    delete(f2)
    delete(f3)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(f7)
    delete(f8)
;read in salinity file ----ss&sh

    f1=addfile("/mnt/f/CMIP6-data/so/AWI-ssp585-2071-2100-remap-34l.nc","r")
    f2=addfile("/mnt/f/CMIP6-data/so/GFDL-CM4-ssp585-2071-2100-remap-34l.nc","r")
    f3=addfile("/mnt/f/CMIP6-data/so/GFDL-ESM4-ssp585-2071-2100-remap-34l.nc","r")
    f4=addfile("/mnt/f/CMIP6-data/so/MPI-ssp585-2071-2100-remap-34l-2.nc","r")
    f5=addfile("/mnt/f/CMIP6-data/so/AWI-hist-1985-2014-remap-34l.nc","r")
    f6=addfile("/mnt/f/CMIP6-data/so/GFDL-CM4-hist-1985-2014-remap-34l.nc","r")
    f7=addfile("/mnt/f/CMIP6-data/so/GFDL-ESM4-hist-1985-2014-remap-34l.nc","r")
    f8=addfile("/mnt/f/CMIP6-data/so/MPI-hist-1985-2014-remap-34l-2.nc","r")
    s1=f1->so(0,0:20,:,:)
    s2=f2->so(0,0:20,:,:)
    s3=f3->so(0,0:20,:,:)
    s4=f4->so(0,0:20,:,:)
    s5=f5->so(0,0:20,:,:)
    s6=f6->so(0,0:20,:,:)
    s7=f7->so(0,0:20,:,:)
    s8=f8->so(0,0:20,:,:)
    lev1=f1->depth(0:20)
    lev=dble2flt(lev1)
    ss=(s1+s2+s3+s4)/4
    sh=(s5+s6+s7+s8)/4
    delete(s1)
    delete(s2)
    delete(s3)
    delete(s4)
    delete(s5)
    delete(s6)
    delete(s7)
    delete(s8)
    delete(f1)
    delete(f2)
    delete(f3)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(f7)
    delete(f8)
;calculate potential density(pd)with rho_mwjf
delete(area@_FillValue)
area@_FillValue=1e+30

pds=new((/21,1080,1440/),float, ss@_FillValue)
pdh=new((/21,1080,1440/),float, ss@_FillValue)
pds1=new((/20/),float,ss@_FillValue)
pdh1=new((/20/),float,ss@_FillValue)
;pds2=new((/20/),float,ss@_FillValue)
;pdh2=new((/20/),float,ss@_FillValue)

do i=0,20,1
    pds(i,:,:)=rho_mwjf(ts(i,:,:), ss(i,:,:), lev(i))
    pdh(i,:,:)=rho_mwjf(th(i,:,:), sh(i,:,:), lev(i))
end do

pds2=1000.*(pds-1.) 
pdh2=1000.*(pdh-1.) 

pdsa=wgt_areaave(pds2, area, 1, 0)
pdha=wgt_areaave(pdh2, area, 1, 0)

/;
filename = "/mnt/e/CMIP6-data/Vertical-5500m-density-585.txt"
slist = [/pdsa,pdha/]
write_table(filename, "w", slist, "%8.3f,%8.3f")
exit
;/
do m = 0,1079,1
    do n = 0,1439,1
        if .not.ismissing(pds2(20,m,n)) then
            pdh2(0:19,m,n)=pdh2@_FillValue
            pds2(0:19,m,n)=pds2@_FillValue
        end if 
    end do
end do

do i = 0,19
    pds1(i)=wgt_areaave(pds2(i,:,:), area, 1, 0)
    pdh1(i)=wgt_areaave(pdh2(i,:,:), area, 1, 0)
end do 

filename = "/mnt/e/CMIP6-data/Vertical-1000m-density-585.txt"
slist = [/pds1,pdh1/]
write_table(filename, "w", slist, "%8.3f,%8.3f")

