;read in files
    f1=addfile("/mnt/e/CMIP6-data/Heatmap/AWI-ssp245-2071-2100-remap-17l-ave.nc", "r"); float thetao ( time, depth, lat, lon )_FillValue :   1e+30
    f2=addfile("/mnt/e/CMIP6-data/Heatmap/GFDL-CM4-ssp245-2071-2100-remap-17l-ave.nc", "r"); float thetao ( lev, lat, lon )_FillValue :   1e+20
    f3=addfile("/mnt/e/CMIP6-data/Heatmap/GFDL-ESM4-ssp245-2071-2100-remap-17l-ave.nc", "r")
    f4=addfile("/mnt/e/CMIP6-data/Heatmap/MPI-ssp245-2071-2100-remap-17l-ave.nc", "r")
    f6=addfile("/mnt/e/CMIP6-data/Heatmap/AWI-hist-1985-2014-remap-17l-ave-.nc", "r")
    f7=addfile("/mnt/e/CMIP6-data/Heatmap/GFDL-CM4-hist-1985-2014-remap-17l-ave.nc", "r")
    f8=addfile("/mnt/e/CMIP6-data/Heatmap/GFDL-ESM4-hist-1985-2014-remap-17l-ave.nc", "r")
    f9=addfile("/mnt/e/CMIP6-data/Heatmap/MPI-HR-hist-1985-2014-remap-17l-ave.nc", "r")
    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
    lev=f1->depth
    lat=f1->lat
    lon=f1->lon
    t1=f1->thetao(0,:,:,:)
    t2=f2->thetao(:,:,:)
    t3=f3->thetao(:,:,:)
    t4=f4->thetao(0,:,:,:)
    t6=f6->thetao(0,:,:,:)
    t7=f7->thetao(:,:,:)
    t8=f8->thetao(:,:,:)
    t9=f9->thetao(0,:,:,:)
    ts=(t1+t2+t3+t4)/4
    th=(t6+t7+t8+t9)/4
    ts!1="lat"
    ts!2="lon"
    ts&lat=lat
    ts&lon=lon
    th!1="lat"
    th!2="lon"
    th&lat=lat
    th&lon=lon
    delete(t1)
    delete(t2)
    delete(t3)
    delete(t4)
    delete(t6)
    delete(t7)
    delete(t8)
    delete(t9)
;Tab Tre
    Tab=ts-th
    ta0=new((/17/), float,th@_FillValue); ave temp at diff depth - his
    ta1=new((/17/), float,th@_FillValue); ave temp at diff depth - ssp245
    do i= 0,16,1
        ta0(i)=wgt_areaave(th(i,:,:), area, 1, 0)
        ta1(i)=wgt_areaave(ts(i,:,:), area, 1, 0)
    end do
    dta_1=ta1-ta0; ave temp rise at diff depth : pic-4co2
    dta1=conform_dims(dimsizes(th), dta_1, 0); turn into 3d

    ;relative temp
    Tre=new((/17,1080,1440/), float,th@_FillValue)
    do i= 0,16,1
        Tre(i,:,:)=ts(i,:,:)-th(i,:,:)-dta1(i,:,:)
    end do

    Tre!1="lat"
    Tre!2="lon"
    Tre&lat=f1->lat
    Tre&lon=f1->lon
    Tab!1="lat"
    Tab!2="lon"
    Tab&lat=f1->lat
    Tab&lon=f1->lon

    Tabm=dim_avg_n(Tab, 2)
    Trem=dim_avg_n(Tre, 2)
;draw slice
    lat_t = f1->lat
    z_t   = f1->depth
    wks1 = gsn_open_wks("png","/mnt/e/Zonalmean-ab") 
    wks2 = gsn_open_wks("png","/mnt/e/Zonalmean-re")      ; send graphics to PNG file
    res=True

    cmap = read_colormap_file("NCV_blu_red" )
    res@cnFillOn             = True       ; turn on color fill
    res@cnLineLabelsOn       = False      ; turns off contour line labels
    res@cnInfoLabelOn        = False      ; turns off contour info label
    res@cnFillPalette        = cmap(102:255,:); set color map
    res@lbOrientation        = "vertical" ; vertical label bar
    res@cnLevelSelectionMode = "ManualLevels"
    res@cnLinesOn            =False
    res@cnMaxLevelValF       = 2
    res@cnMinLevelValF       = -0.2
    res@cnLevelSpacingF      = 0.2
    res@sfXArray             = lat_t      ; uses lon_t as plot x-axis
    res@sfYArray             = z_t        ; convert cm to m
    res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
    res@trYReverse               = True   ; reverses y-axis
    res@tiMainString              = "Zonal mean-Tab" ; main title
    res@tmXBMajorOutwardLengthF = False
    res@tmXBMinorOutwardLengthF = False
    res2=res
    delete(res2@cnFillPalette)
    delete(res2@cnMaxLevelValF)
    delete(res2@cnMinLevelValF)
    res2@cnFillPalette        = cmap(0:255,:); set color map
    res2@cnMaxLevelValF       = 1.2
    res2@cnMinLevelValF       = -1.2
    res2@tiMainString              = "Zonal mean-Tre"

    plot1 = gsn_csm_contour(wks1,Tabm,res)     ; create plot
    plot2 = gsn_csm_contour(wks2,Trem,res2)  
;
;
;