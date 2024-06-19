;input
    f1=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/AWI-2071-2100-winter-remap-34l-ave.nc", "r"); float thetao ( time, depth, lat, lon )_FillValue :   1e+30
    f2=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/GFDL-CM4-2071-2100-winter-remap-34l-ave.nc", "r")
    f3=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/GFDL-ESM4-2071-2100-winter-remap-34l-ave.nc", "r")
    f4=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/MPI-2071-2100-winter-remap-34l-ave.nc", "r")
    f5=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/AWI-1985-2014-winter-remap-34l-ave.nc", "r")
    f6=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/GFDL-CM4-1985-2014-winter-remap-34l-ave.nc", "r")
    f7=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/GFDL-ESM4-1985-2014-winter-remap-34l-ave.nc", "r")
    f8=addfile("/mnt/e/CMIP6-data/Rigionalmap/winter/MPI-1985-2014-winter-remap-34l-ave.nc", "r")
    fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
    f11=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/AWI-2071-2100-summer-remap-34l-ave.nc", "r"); float thetao ( time, depth, lat, lon )_FillValue :   1e+30
    f21=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/GFDL-CM4-2071-2100-summer-remap-34l-ave.nc", "r")
    f31=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/GFDL-ESM4-2071-2100-summer-remap-34l-ave.nc", "r")
    f41=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/MPI-2071-2100-summer-remap-34l-ave.nc", "r")
    f51=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/AWI-1985-2014-summer-remap-34l-ave.nc", "r")
    f61=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/GFDL-CM4-1985-2014-summer-remap-34l-ave.nc", "r")
    f71=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/GFDL-ESM4-1985-2014-summer-remap-34l-ave.nc", "r")
    f81=addfile("/mnt/e/CMIP6-data/Rigionalmap/summer/MPI-1985-2014-summer-remap-34l-ave.nc", "r")

    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
    depth=fd->deptho
    lev=f1->depth
    lat=f1->lat
    lon=f1->lon
    t1=f1->thetao(0,:,{0:90},:)
    t2=f2->thetao(0,:,{0:90},:)
    t3=f3->thetao(0,:,{0:90},:)
    t4=f4->thetao(0,:,{0:90},:)
    t5=f5->thetao(0,:,{0:90},:)
    t6=f6->thetao(0,:,{0:90},:)
    t7=f7->thetao(0,:,{0:90},:)
    t8=f8->thetao(0,:,{0:90},:)
    t11=f11->thetao(0,:,{-90:0},:)
    t21=f21->thetao(0,:,{-90:0},:)
    t31=f31->thetao(0,:,{-90:0},:)
    t41=f41->thetao(0,:,{-90:0},:)
    t51=f51->thetao(0,:,{-90:0},:)
    t61=f61->thetao(0,:,{-90:0},:)
    t71=f71->thetao(0,:,{-90:0},:)
    t81=f81->thetao(0,:,{-90:0},:)

    d1=new((/34,1080,1440/), float, 0)
    d2=new((/34,1080,1440/), float, 0)
    d3=new((/34,1080,1440/), float, 0)
    d4=new((/34,1080,1440/), float, 0)
    d5=new((/34,1080,1440/), float, 0)
    d6=new((/34,1080,1440/), float, 0)
    d7=new((/34,1080,1440/), float, 0)
    d8=new((/34,1080,1440/), float, 0)
    d1(:,0:539,:)=t11
    d1(:,540:1079,:)=t1
    d2(:,0:539,:)=t21
    d2(:,540:1079,:)=t2
    d3(:,0:539,:)=t31
    d3(:,540:1079,:)=t3
    d4(:,0:539,:)=t41
    d4(:,540:1079,:)=t4
    d5(:,0:539,:)=t51
    d5(:,540:1079,:)=t5
    d6(:,0:539,:)=t61
    d6(:,540:1079,:)=t6
    d7(:,0:539,:)=t71
    d7(:,540:1079,:)=t7
    d8(:,0:539,:)=t81
    d8(:,540:1079,:)=t8

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


    BT0=new((/1080,1440/), float,th@_FillValue);bottome temp-pic
    BT1=new((/1080,1440/), float,th@_FillValue);bottome temp-first 5 years ave -4co2

    BTab=new((/1080,1440/), float,th@_FillValue);absolute-bottome temp rise
    BTre=new((/1080,1440/), float,th@_FillValue); relative-bottome temp rise (absolute-ave temprise at the depth)

    ta0=new((/34/), float,th@_FillValue); ave temp at diff depth - pic
    ta1=new((/34/), float,th@_FillValue); ave temp at diff depth - 4co2
;calculaiton
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

;assign attibutes
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
;open wks and define res & tres
    ;=========================================================
    ;  draw plots with explicit levels
    ;=========================================================
    tempre=new(5, graphic)
    wks1=gsn_open_wks("png","/mnt/e/pics/BTre-245-winter")
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

    ;plot5=gsn_csm_contour(wks1,depth,res)
    plot6=gsn_csm_contour(wks1,depth,res)
    plot7=gsn_csm_contour(wks1,depth,res)
    plot8=gsn_csm_contour(wks1,depth,res)
    plot9=gsn_csm_contour(wks1,depth,res)

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
;cnfillcolors and levels
    tres@cnFillColors=(/74,87,100,113,138,151,164,177,190,203,216,229,242,255/)
    tres@cnLevelSelectionMode 	= "ExplicitLevels"  ; manually set cont levels\
    tres@cnLevels              = (/-0.5,-0.2,-0.1,0,0.1,0.4,0.8,1.5,2,2.5,3,3.5/);(/-0.5,-0.2,-0.1,0,0.1,0.2,0.4,0.8,1.2,2,4,5/);(/-1,-0.2,-0.1,0,0.1,0.2,0.4,0.8,1.2,2,4,5/)
;define tres and other tres
    ;tres@cnLevelFlags        = (/"NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine"/)
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
    ;tres2@vpWidthF              =0.48
    tres2@mpMaxLatF             =  52             ; East coast 2
    tres2@mpMinLatF             = 25
    tres2@mpMaxLonF             =  -42
    tres2@mpMinLonF             =  -83
    /;
    tres2@mpMaxLatF             =  46             ; East coast original
    tres2@mpMinLatF             = 25
    tres2@mpMaxLonF             =  -55
    tres2@mpMinLonF             =  -85
    ;/
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

    ypts0 = (/78.0, 78.0, 50.0, 50.0, 78.0/)        ; Europe
    xpts0 = (/0.0, 54.0, 54.0, 0.0, 0.0/)
    ypts1 = (/52.0, 52.0, 24.0, 24.0, 52.0/)        ;East coast of america
    xpts1 = (/277.0, 318.0, 318.0, 277.0, 277.0/)
    ypts2 = (/42.0, 42.0, 2.0, 2.0, 42.0/)          ;china
    xpts2 = (/99.0, 130.0, 130.0, 99.0, 99.0/)
    ypts3 = (/-5.0, -5.0, -45.0, -45.0, -5.0/)      ;australia
    xpts3 = (/105.0, 160.0, 160.0, 105.0, 105.0/)

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

    lbar_h  = 0.07
    lbar_w  = 0.8
    lbar_x  = 0.1
    lbar_y  = 0.19
    nboxes = 13                            ; # of labelbar boxes
    ;clen   = 256                          ; # of colors in color map
    ;stride = ((clen-1) - 2) / nboxes    
;fillcolor and labels
    fill_colors =(/74,87,100,113,138,151,164,177,190,203,216,229,242,255/) ;(/94,100,107,113,146,160,172,184,196,208,220,232,244,255/) 
    ;labels    = "" + fspan(400,6000,400) + ""

    labels=(/"-0.5","-0.2","-0.1","0","0.1","0.4","0.8","1.5","2","2.5","3","3.5"/);(/"-0.5","-0.2","-0.1","0","0.1","0.2","0.4","0.8","1.2","2","4","5"/);(/-0.5,-0.1,-0.05,0,0.05,0.1,0.4,0.8,1.2,2,4,5/)
    ;labels=(/"400","1200","2000","2800","3600","4400","5200","6000",""/)
;define colorbar and draw
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
