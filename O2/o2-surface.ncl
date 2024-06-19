;add o2 data
    f2=addfile("/mnt/e/CMIP6-data/o2/GFDL-CM4-ssp245-2071-2100-remap-34l.nc","r")
    f3=addfile("/mnt/e/CMIP6-data/o2/GFDL-ESM4-ssp245-2071-2100-remap-34l.nc","r")
    f4=addfile("/mnt/e/CMIP6-data/o2/MPI-ssp245-2071-2100-remap-34l.nc","r");t
    f6=addfile("/mnt/e/CMIP6-data/o2/GFDL-CM4-hist-1985-2014-remap-34l.nc","r")
    f7=addfile("/mnt/e/CMIP6-data/o2/GFDL-ESM4-hist-1985-2014-remap-34l.nc","r")
    f8=addfile("/mnt/e/CMIP6-data/o2/MPI-hist-1985-2014-remap-34l.nc","r");t
    fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")

    t2=f2->o2(0,:,:,:)
    t3=f3->o2(0,:,:,:)
    t4=f4->o2(0,:,:,:)
    t6=f6->o2(0,:,:,:)
    t7=f7->o2(0,:,:,:)
    t8=f8->o2(0,:,:,:)
    lat=f2->lat
    lon=f2->lon
    lev1=f4->lev
    lev=dble2flt(lev1)
    depth=fd->deptho
    ;depth0=where(depth.ge.2000, depth@_FillValue, depth)

ts=(t2+t3+t4)/4
th=(t6+t7+t8)/4
dt=ts-th
;delete and assign attributes
    delete(t2)
    delete(t3)
    delete(t4)
    delete(t6)
    delete(t7)
    delete(t8)
    ts!1="lat"
    ts!2="lon"
    ts&lat=f2->lat
    ts&lon=f2->lon
    th!1="lat"
    th!2="lon"
    th&lat=f2->lat
    th&lon=f2->lon
    dt!1="lat"
    dt!2="lon"
    dt&lat=f2->lat
    dt&lon=f2->lon

wks = gsn_open_wks("png","/mnt/e/o2-ssp245-hist")      ; send graphics to PNG file
res=True
;cmap = read_colormap_file("MPL_Blues" )
res@cnFillOn             = True       ; turn on color fill
res@cnLineLabelsOn       = False      ; turns off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
res@cnLinesOn           =False
res@cnLevelSelectionMode = "ManualLevels"
res@cnMaxLevelValF      =0.03
res@cnMinLevelValF      =-0.03
res@cnLevelSpacingF     =0.005
res@tiMainString        ="Surface Oxygen Concentration (SSP245-Historical)"
plot = gsn_csm_contour_map(wks,dt(1,:,:),res)     ; create plot
exit

BT0=new((/1080,1440/), float,th@_FillValue);bottome temp-pic
BT1=new((/1080,1440/), float,th@_FillValue);bottome temp-first 5 years ave -4co2

BTab=new((/1080,1440/), float,th@_FillValue);absolute-bottome temp rise
BTre=new((/1080,1440/), float,th@_FillValue); relative-bottome temp rise (absolute-ave temprise at the depth)

ta0=new((/34/), float,th@_FillValue); ave temp at diff depth - pic
ta1=new((/34/), float,th@_FillValue); ave temp at diff depth - 4co2

do i= 0,33,1
    ta0(i)=wgt_areaave(th(i,:,:), area, 1, 0)
    ta1(i)=wgt_areaave(ts(i,:,:), area, 1, 0)
end do
;print(ta0)
;print(ta1)
dta_1=ta1-ta0; ave temp rise at diff depth : pic-4co2

dta1=conform_dims(dimsizes(th), dta_1, 0); turn into 3d

do m = 0,1079,1
    do n = 0,1439,1
        if .not.ismissing(th(33,m,n)) then;in the deepest area
            BT0(m,n)=th(33,m,n)
            BT1(m,n)=ts(33,m,n)
            BTab(m,n)=BT1(m,n)-BT0(m,n)           
            BTre(m,n)=BTab(m,n)-dta1(33,m,n)         
        else if .not.ismissing(th(1,m,n)) then; in ocean area
            i=1
            do while(i.le.32 .and. .not.ismissing(th(i,m,n)))
                i=i+1
            end do
            BT0(m,n)=th(i-1,m,n)
            BT1(m,n)=ts(i-1,m,n)
            BTab(m,n)=BT1(m,n)-BT0(m,n)
            BTre(m,n)=BTab(m,n)-dta1(i-1,m,n)
        else 
            BT0(m,n)=th(0,m,n); in land area BT0 equals land value which is fill value
            BT1(m,n)=ts(0,m,n)
            BTab(m,n)=BT1(m,n)-BT0(m,n)           
            BTre(m,n)=BTab(m,n)-dta1(0,m,n)
        end if
        end if
    end do
end do


depth!0="lat"
depth!1="lon"
depth&lat=lat
depth&lon=lon
BTab!0="lat"
BTab!1="lon"
BTab&lat=lat
BTab&lon=lon
BTre!0="lat"
BTre!1="lon"
BTre&lat=lat
BTre&lon=lon

