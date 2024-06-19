;input
    f1=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-ssp245-2071-2100-remap-34l-ave.nc","r");t;d
    f2=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-ssp245-2071-2100-remap-34l-ave.nc","r")
    f3=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-ESM4-ssp245-2071-2100-remap-34l-ave.nc","r")
    f4=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-ssp245-2071-2100-remap-34l-ave.nc","r");t
    f5=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-hist-1985-2014-remap-34l-ave.nc","r");t;d
    f6=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-hist-1985-2014-remap-34l-ave.nc","r")
    f7=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-ESM4-hist-1985-2014-remap-34l-ave.nc","r")
    f8=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-HR-hist-1985-2014-remap-34l-ave.nc","r");t

    fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")

    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")

    t1=f1->thetao(0,:,:,:)
    t2=f2->thetao
    t3=f3->thetao
    t4=f4->thetao(0,:,:,:)
    t5=f5->thetao(0,:,:,:)
    t6=f6->thetao
    t7=f7->thetao
    t8=f8->thetao(0,:,:,:)
    lat=f1->lat
    lon=f1->lon
    lev1=f4->lev
    lev=dble2flt(lev1)
    depth=fd->deptho
    ;depth0=where(depth.ge.2000, depth@_FillValue, depth)

    ts=(t1+t2+t3+t4)/4
    th=(t5+t6+t7+t8)/4
    delete(f1)
    delete(f2)
    delete(f3)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(f7)
    delete(f8)
    delete(t1)
    delete(t2)
    delete(t3)
    delete(t4)
    delete(t5)
    delete(t6)
    delete(t7)
    delete(t8)

    BT0=new((/1080,1440/), float,th@_FillValue);bottome temp-pic
    BT1=new((/1080,1440/), float,th@_FillValue);bottome temp-first 5 years ave -4co2

    BTab=new((/1080,1440/), float,th@_FillValue);absolute-bottome temp rise
    BTre=new((/1080,1440/), float,th@_FillValue); relative-bottome temp rise (absolute-ave temprise at the depth)

    ta0=new((/34/), float,th@_FillValue); ave temp at diff depth - pic
    ta1=new((/34/), float,th@_FillValue); ave temp at diff depth - 4co2
;calculate 
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


;input sic
    ;=========================================================
    ;  SIC data
    ;=========================================================
    ;read historical data
        f1=addfile("/mnt/e/CMIP6-data/sic/AWI-hist-feb-1985-2014-remap.nc","r")
        f2=addfile("/mnt/e/CMIP6-data/sic/GFDL-CM4-hist-feb-1985-2014-remap.nc","r")
        f3=addfile("/mnt/e/CMIP6-data/sic/GFDL-ESM4-hist-feb-1985-2014-remap.nc","r")
        f4=addfile("/mnt/e/CMIP6-data/sic/MPI-hist-feb-1985-2014-remap.nc","r")
        f5=addfile("/mnt/e/CMIP6-data/sic/AWI-hist-sep-1985-2014-remap.nc","r")
        f6=addfile("/mnt/e/CMIP6-data/sic/GFDL-CM4-hist-sep-1985-2014-remap.nc","r")
        f7=addfile("/mnt/e/CMIP6-data/sic/GFDL-ESM4-hist-sep-1985-2014-remap.nc","r")
        f8=addfile("/mnt/e/CMIP6-data/sic/MPI-hist-sep-1985-2014-remap.nc","r")

        sic1=f1->siconc(0,:,:)
        sic2=f2->siconc(0,:,:)
        sic3=f3->siconc(0,:,:)
        sic4=f4->siconc(0,:,:)
        sic5=f5->siconc(0,:,:)
        sic6=f6->siconc(0,:,:)
        sic7=f7->siconc(0,:,:)
        sic8=f8->siconc(0,:,:)

    sicsh=(sic1+sic2+sic3+sic4)/4
    sicnh=(sic5+sic6+sic7+sic8)/4
    sich=new((/1080,1440/), float, sicsh@_FillValue)
    sich(0:539,:)=sicsh(0:539,:)
    sich(540:1079,:)=sicnh(540:1079,:)
    ;delete historical data and read in ssp245 data
        delete(f1)
        delete(f2)
        delete(f3)
        delete(f4)
        delete(f5)
        delete(f6)
        delete(f7)
        delete(f8)
        delete(sic1)
        delete(sic2)
        delete(sic3)
        delete(sic4)
        delete(sic5)
        delete(sic6)
        delete(sic7)
        delete(sic8)
        delete(sicsh)
        delete(sicnh)

        f1=addfile("/mnt/e/CMIP6-data/sic/AWI-ssp245-feb-2071-2100-remap.nc","r")
        f2=addfile("/mnt/e/CMIP6-data/sic/GFDL-CM4-ssp245-feb-2071-2100-remap.nc","r")
        f3=addfile("/mnt/e/CMIP6-data/sic/GFDL-ESM4-ssp245-feb-2071-2100-remap.nc","r")
        f4=addfile("/mnt/e/CMIP6-data/sic/MPI-ssp245-feb-2071-2100-remap.nc","r")
        f5=addfile("/mnt/e/CMIP6-data/sic/AWI-ssp245-sep-2071-2100-remap.nc","r")
        f6=addfile("/mnt/e/CMIP6-data/sic/GFDL-CM4-ssp245-sep-2071-2100-remap.nc","r")
        f7=addfile("/mnt/e/CMIP6-data/sic/GFDL-ESM4-ssp245-sep-2071-2100-remap.nc","r")
        f8=addfile("/mnt/e/CMIP6-data/sic/MPI-ssp245-sep-2071-2100-remap.nc","r")
        
        sic1=f1->siconc(0,:,:)
        sic2=f2->siconc(0,:,:)
        sic3=f3->siconc(0,:,:)
        sic4=f4->siconc(0,:,:)
        
        sic5=f5->siconc(0,:,:)
        sic6=f6->siconc(0,:,:)
        sic7=f7->siconc(0,:,:)
        sic8=f8->siconc(0,:,:)
        
    sicsh=(sic1+sic2+sic3+sic4)/4
    sicnh=(sic5+sic6+sic7+sic8)/4
    sics=new((/1080,1440/), float, sicsh@_FillValue)
    sics(0:539,:)=sicsh(0:539,:)
    sics(540:1079,:)=sicnh(540:1079,:)
    sics!0="lat"
    sics!1="lon"
    sics&lat=f5->lat
    sics&lon=f5->lon
    sich!0="lat"
    sich!1="lon"
    sich&lat=f5->lat
    sich&lon=f5->lon

    ;=========================================================
    ;  draw depth plots with explicit levels
    ;=========================================================
;define wks
    tempre=new(5, graphic)

    wks1=gsn_open_wks("png","/mnt/e/pics/BTre-245-4000m")
;draw depth and SIC
    gsn_define_colormap(wks1,"NCV_blu_red")
    res=True
    res@gsnFrame              = False 
    res@lbLabelBarOn          = False 
    res@gsnDraw               = False 
    res@cnInfoLabelOn         = False
    res@cnMonoLineColor       = False
    ;res@mpProjection="LambertConformal"
    ;res@gsnMaskLambertConformal = True
    res@gsnRightString        = "" 
    res@gsnLeftString         = "" 
    res@cnLevelSelectionMode  = "ExplicitLevels"
    res@cnLevels              = (/200,1000/)
    res@cnLevelFlags        = (/"LineOnly","LineOnly"/)
    res@cnLineColors=(/"green","blue"/)
    res@cnLineThicknessF=3

    res2=True
    res2@gsnFrame              = False 
    res2@lbLabelBarOn          = False 
    res2@gsnDraw               = False
    res2@cnInfoLabelOn         = False 
    res2@cnFillOn=True
    res2@cnLinesOn=True
    res2@cnLineColor="black"
    res2@cnLineThicknessF=0.5
    res2@cnMonoFillColor = True
    res2@cnLevelSelectionMode="ExplicitLevels"
    res2@cnLevels=(/3999,6000/)
    res2@cnMonoFillPattern    = False
    res2@cnFillPatterns=(/-1,8,-1/)
    res2@cnMonoFillScale      = False            ; want different densities 
    res2@cnFillScales         = (/1,0.5,1/) ;
    res2@tiMainString = ""
    res2@gsnLeftString = "Depth of Shaded area >=4000m"
    res@gsnLeftStringOrthogonalPosF=1
    res2@gsnCenterString = ""
    res2@gsnRightString = ""
    ;res2@cnFillDotSizeF       = 0.005
    ;plot5=gsn_csm_contour(wks1,depth,res)
    plot6=gsn_csm_contour(wks1,depth,res)
    plot7=gsn_csm_contour(wks1,depth,res)
    plot8=gsn_csm_contour(wks1,depth,res)
    plot9=gsn_csm_contour(wks1,depth,res)
    plot10=gsn_csm_contour(wks1,depth,res2)

    ;=========================================================
    ;  draw SIC plots 
    ;=========================================================

    sres                = True   ; plot mods desire
    sres@gsnDraw        = False  ; draw plot
    sres@gsnFrame       = False  ; advance frome
    sres@cnFillOn       = False  ; turn on color fill
    sres@cnLinesOn      = True   ; turn on contour lines
    sres@cnInfoLabelOn  = False  ; turn off info label
    sres@cnLineLabelsOn = False  ; contour labels
    sres@cnLevelSelectionMode = "ExplicitLevels"  ; set explicit contour levels
    sres@cnLineColor="purple"
    sres@cnLineThicknessF = 5
    sres@cnLevels = (/20./)
    sres@cnLineDashPattern=1
    sres@tiMainString = ""
    sres@gsnLeftString = ""
    sres@gsnCenterString = ""
    sres@gsnRightString = ""

    sresh=sres
    delete(sresh@cnLineColor)
    sresh@cnLineColor="blue"
    sicmaps = gsn_csm_contour(wks1,sics,sres)
    sicmaph = gsn_csm_contour(wks1,sich,sresh)
;draw BT 
    ;=========================================================
    ;  draw BT plots 
    ;=========================================================

    tres=True
    tres@gsnFrame               = False 
    tres@gsnDraw                = False
    tres@lbLabelBarOn           = False
    tres@cnLinesOn              = False
    tres@cnFillOn               =True
    ;tres@mpProjection="LambertConformal"
    ;tres@gsnMaskLambertConformal = True
    tres@mpLandFillColor       = "transparent"
    tres@gsnRightString        = "" 
    tres@gsnLeftString         = "" 
    ;tres@mpLabelFontHeightF    =0.1
;define tres
    tres@cnFillColors=(/74,87,100,113,138,151,164,177,190,203,216,229,242,255/)
    tres@cnLevelSelectionMode 	= "ExplicitLevels"  ; manually set cont levels\
    tres@cnLevels              = (/-0.5,-0.2,-0.1,0,0.1,0.4,0.8,1.5,2,2.5,3,3.5/);(/-0.5,-0.2,-0.1,0,0.1,0.2,0.4,0.8,1.2,2,4,5/);(/-1,-0.2,-0.1,0,0.1,0.2,0.4,0.8,1.2,2,4,5/)
    ;tres@cnLevelFlags        = (/"NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine"/)
;define other tres
    tres@tmEqualizeXYSizes= True
    tres@tmXBLabelFontHeightF=0.01 
    tres@vpKeepAspect           = True
    tres@cnLineLabelsOn         =False
    tres@tiMainFontHeightF      =0.015
    tres@tiMainString          ="Seas Around Norway"
    tres@vpXF                   = 0.06       ; Same X location as first plot
    tres@vpYF                   = 0.8        ; Lower on the page
    tres@vpWidthF               =0.32
    tres@vpHeightF              =0.16
    tres@mpMaxLatF              =  78             ; Europe
    tres@mpMinLatF              =  50
    tres@mpMaxLonF              =  54
    tres@mpMinLonF              =  0;/

    tres0=tres
    ;tres0@lbLabelBarOn           = False
    tres0@tiMainString          ="Seas Around China"
    tres0@vpXF                  =0.7
    tres0@vpYF                  =0.54
    tres0@vpWidthF              =0.3
    tres0@vpHeightF             =0.3
    tres0@mpMaxLatF            =  42             ; China
    tres0@mpMinLatF             = 2
    tres0@mpMaxLonF             =  130
    tres0@mpMinLonF             =  99

    tres3=tres
    delete(tres3@mpMaxLatF)
    delete(tres3@mpMaxLonF)
    delete(tres3@mpMinLatF)
    delete(tres3@mpMinLonF)
    ;tres3@lbLabelBarOn           = False
    tres3@tiMainString           ="Global"
    tres3@vpXF                   =0.07
    tres3@vpYF                   =0.54
    tres3@vpWidthF              =0.6
    tres3@vpHeightF             =0.3

    tres1=tres
    ;tres1@lbLabelBarOn           = False
    tres1@tiMainString          ="Seas Around Australia"
    tres1@vpXF                  = 0.38       ; Same X location as first plot
    tres1@vpYF                  = 0.8        ; Lower on the page
    tres1@vpHeightF             =0.16
    ;tres1@vpWidthF              =0.48
    tres1@mpMaxLatF             =  -5             ; Australia
    tres1@mpMinLatF             = -45
    tres1@mpMaxLonF             =  160
    tres1@mpMinLonF             = 105

    tres2=tres
    ;tres2@lbLabelBarOn           = False
    tres2@tiMainString          ="East Coast of America"
    tres2@vpXF                  = 0.68       ; Same X location as first plot
    tres2@vpYF                  = 0.8        ; Lower on the page
    tres2@vpHeightF             =0.16
    tres2@mpMaxLatF             =  52             ; East coast 2
    tres2@mpMinLatF             = 25
    tres2@mpMaxLonF             =  -42
    tres2@mpMinLonF             =  -83

    tempre(0)=gsn_csm_contour_map(wks1,BTre,tres)
    tempre(1)=gsn_csm_contour_map(wks1,BTre,tres0)
    tempre(2)=gsn_csm_contour_map(wks1,BTre,tres1)
    tempre(3)=gsn_csm_contour_map(wks1,BTre,tres2)
    tempre(4)=gsn_csm_contour_map(wks1,BTre,tres3)

    ;overlay(tempre(0),plot5)
    overlay(tempre(0),plot6)
    overlay(tempre(1),plot7)
    overlay(tempre(2),plot8)
    overlay(tempre(3),plot9)
    overlay(tempre(4),plot10)
    overlay(tempre(4),sicmaph)
    overlay(tempre(4),sicmaps)

    ypts0 = (/78.0, 78.0, 50.0, 50.0, 78.0/)        ; Europe
    xpts0 = (/0.0, 54.0, 54.0, 0.0, 0.0/)
    ypts1 = (/52.0, 52.0, 24.0, 24.0, 52.0/)        ;East coast of america
    xpts1 = (/277.0, 318.0, 318.0, 277.0, 277.0/)
    ypts2 = (/42.0, 42.0, 2.0, 2.0, 42.0/)          ;china
    xpts2 = (/99.0, 130.0, 130.0, 99.0, 99.0/)
    ypts3 = (/-5.0, -5.0, -45.0, -45.0, -5.0/)      ;australia
    xpts3 = (/105.0, 160.0, 160.0, 105.0, 105.0/)
    ypts4 = (/-75.0, -65.0/)   
    xpts4 = (/303.0,303.0/)
    ypts5 = (/73.0, 79.0/)   
    xpts5 = (/158.0,158.0/)

    resp                  = True                      ; polyline mods desired
    resp@gsLineColor      = "black"                     ; color of lines
    resp@gsLineThicknessF = 2.0                       ; thickness of lines
    ;resp@gsLineLabelString= "Europe"                    ; adds a line label string
    dum4 = new(4,graphic)  
    dum5 = new(4,graphic)  
    dum6 = new(4,graphic)  
    dum7 = new(4,graphic)  

    do i = 0 , 3
        dum4(i)=gsn_add_polyline(wks1,tempre(4),xpts0(i:i+1),ypts0(i:i+1),resp)      
        dum5(i)=gsn_add_polyline(wks1,tempre(4),xpts1(i:i+1),ypts1(i:i+1),resp)        
        dum6(i)=gsn_add_polyline(wks1,tempre(4),xpts2(i:i+1),ypts2(i:i+1),resp)        
        dum7(i)=gsn_add_polyline(wks1,tempre(4),xpts3(i:i+1),ypts3(i:i+1),resp)      
    end do 

    ;dum8=gsn_add_polyline(wks1, tempre(4),xpts4(0:1),ypts4(0:1),resp)
    ;dum9=gsn_add_polyline(wks1, tempre(4),xpts5(0:1),ypts5(0:1),resp)

    lbar_h  = 0.07
    lbar_w  = 0.8
    lbar_x  = 0.1
    lbar_y  = 0.19
    nboxes = 13                            ; # of labelbar boxes
    ;clen   = 256                          ; # of colors in color map
    ;stride = ((clen-1) - 2) / nboxes    
;fillcolors and labels
    fill_colors =(/74,87,100,113,138,151,164,177,190,203,216,229,242,255/) ;(/94,100,107,113,146,160,172,184,196,208,220,232,244,255/) 
    ;labels    = "" + fspan(400,6000,400) + ""

    labels=(/"-0.5","-0.2","-0.1","0","0.1","0.4","0.8","1.5","2","2.5","3","3.5"/);(/"-0.5","-0.2","-0.1","0","0.1","0.2","0.4","0.8","1.2","2","4","5"/);(/-0.5,-0.1,-0.05,0,0.05,0.1,0.4,0.8,1.2,2,4,5/)
    ;labels=(/"400","1200","2000","2800","3600","4400","5200","6000",""/)
;draw
    lbres                      = True
    lbres@lbAutoManage              = False         ; we control label bar
    lbres@lbFillColors              = fill_colors   ; use nice strided colors  
    lbres@lbPerimOn                 = False         ; Turn off labelbar perimeter.
    lbres@lbMonoFillPattern         = True          ; one pattern, all solid
    lbres@vpHeightF            = lbar_h
    lbres@vpWidthF             = lbar_w
    lbres@lbOrientation        = "Horizontal"
    lbres@lbLabelPosition      = "Bottom"
    lbres@lbBottomMarginF      = 0.0
    lbres@lbLeftMarginF        = 0.0
    lbres@lbRightMarginF       = 0.0
    lbres@lbTopMarginF         = 0.0
    lbres@lbLabelsOn           = True
    lbres@lbBoxEndCapStyle = "TriangleBothEnds"
    lbres@lbLabelAlignment = "InteriorEdges"
    lbres@lbLabelFontHeightF   =0.01


    lbid5 = gsn_create_labelbar_ndc(wks1,nboxes,labels,lbar_x,lbar_y,lbres)
    draw(lbid5)
    draw(tempre)
    frame(wks1)