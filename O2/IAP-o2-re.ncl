;read in ts and th
f1=addfile("/mnt/f/IAP-DO/IAP-1961-1980.nc","r")
f2=addfile("/mnt/f/IAP-DO/IAP-2001-2020.nc","r")

th=f1->oxygen(0,:,:,:)
ts=f2->oxygen(0,:,:,:)

if (any(isnan_ieee(th))) then
    if(.not.isatt(th,"_FillValue")) then
        th@_FillValue =999
    end if
    replace_ieeenan (th, th@_FillValue, 0)
end if

if (any(isnan_ieee(ts))) then
    if(.not.isatt(ts,"_FillValue")) then
        ts@_FillValue =999
    end if
    replace_ieeenan (ts, ts@_FillValue, 0)
end if
;read in  depth and area
fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
area=asciiread("/mnt/e/CMIP6-data/area-file/IAPs.txt", 180, "float")
lat=f1->lat
lon=f1->lon
lev=f1->depth_std
depth=fd->deptho

;calculate

BT0=new((/180,360/), float,th@_FillValue);bottome temp-pic
BT1=new((/180,360/), float,th@_FillValue);bottome temp-first 5 years ave -4co2

BTab=new((/180,360/), float,th@_FillValue);absolute-bottome temp rise
BTre=new((/180,360/), float,th@_FillValue); relative-bottome temp rise (absolute-ave temprise at the depth)

ta0=new((/119/), float,th@_FillValue); ave temp at diff depth - pic
ta1=new((/119/), float,th@_FillValue); ave temp at diff depth - 4co2

do i= 0,118,1
    ta0(i)=wgt_areaave(th(:,:,i), area, 1, 0)
    ta1(i)=wgt_areaave(ts(:,:,i), area, 1, 0)
end do

dta_1=ta1-ta0; ave temp rise at diff depth : pic-4co2
dta1=conform_dims(dimsizes(th), dta_1, 2); turn into 3d

do m = 0,179,1
    do n = 0,359,1
        if .not.ismissing(th(m,n,118)) then;in the deepest area
            BT0(m,n)=th(m,n,118)
            BT1(m,n)=ts(m,n,118)
            BTab(m,n)=BT1(m,n)-BT0(m,n)           
            BTre(m,n)=BTab(m,n)-dta1(m,n,118)         
        else if .not.ismissing(th(m,n,1)) then; in ocean area
            i=1
            do while(i.le.117 .and. .not.ismissing(th(m,n,i)))
                i=i+1
            end do
            BT0(m,n)=th(m,n,i-1)
            BT1(m,n)=ts(m,n,i-1)
            BTab(m,n)=BT1(m,n)-BT0(m,n)
            BTre(m,n)=BTab(m,n)-dta1(m,n,i-1)
        else 
            BT0(m,n)=th(m,n,0); in land area BT0 equals land value which is fill value
            BT1(m,n)=ts(m,n,0)
            BTab(m,n)=BT1(m,n)-BT0(m,n)           
            BTre(m,n)=BTab(m,n)-dta1(m,n,0)
        end if
        end if
    end do
end do


depth!0="lat"
depth!1="lon"
depth&lat=fd->lat
depth&lon=fd->lon
BTab!0="lat"
BTab!1="lon"
BTab&lat=lat
BTab&lon=lon
BTre!0="lat"
BTre!1="lon"
BTre&lat=lat
BTre&lon=lon

;draw the pics-test
/;
wks1 = gsn_open_wks("png","/mnt/e/testab")   
wks2 = gsn_open_wks("png","/mnt/e/testre")    ; send graphics to PNG file
gsn_define_colormap(wks1,"NCV_blu_red")
gsn_define_colormap(wks2,"NCV_blu_red")
res=True
res@cnFillOn             = True       ; turn on color fill
res@cnLineLabelsOn       = False      ; turns off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
res@cnLinesOn            = False

res@cnFillColors=(/88,108,127,128,140,152,164,176,188,200,212,224,235,246,255/) ;(/50,56,62,63,64,72,80,87,93,100,107,114,120,127/) 
res@cnLevelSelectionMode 	= "ExplicitLevels"  ; manually set cont levels\
res@cnLevels              = (/-0.4,-0.2,0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45/)

plot1 = gsn_csm_contour_map(wks1,BTab,res)     ; create plot
plot2 = gsn_csm_contour_map(wks2,BTre,res) 
exit
;/
;=========================================================
;  draw plots with explicit levels
;=========================================================
tempab=new(5, graphic)

wks0=gsn_open_wks("png","/mnt/e/pics/Bo2re-IAP")
gsn_define_colormap(wks0,"NCV_blu_red")
cmap = read_colormap_file("NCV_blu_red" )
;depth contour line
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

    ;plot0=gsn_csm_contour(wks0,depth,res)
    plot1=gsn_csm_contour(wks0,depth,res)
    plot2=gsn_csm_contour(wks0,depth,res)
    plot3=gsn_csm_contour(wks0,depth,res)
    plot4=gsn_csm_contour(wks0,depth,res)
;tres
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
;tres-level
tres@cnLevelSelectionMode = "ManualLevels"
tres@cnMaxLevelValF      =6
tres@cnMinLevelValF      =-6
tres@cnLevelSpacingF     =1
;tres-europe
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
;tres0-china
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
;tres3-global
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
;tres1-australia
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
;tres2-america
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
;draw
    tempab(0)=gsn_csm_contour_map(wks0,BTre,tres);europe
    tempab(1)=gsn_csm_contour_map(wks0,BTre,tres0);china
    tempab(2)=gsn_csm_contour_map(wks0,BTre,tres1);australia
    tempab(3)=gsn_csm_contour_map(wks0,BTre,tres2);east coast
    tempab(4)=gsn_csm_contour_map(wks0,BTre,tres3);global

    overlay(tempab(0),plot1)
    overlay(tempab(1),plot2)
    overlay(tempab(2),plot3)
    overlay(tempab(3),plot4)
;boxes
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

    dum0 = new(4,graphic)  
    dum1 = new(4,graphic)  
    dum2 = new(4,graphic)  
    dum3 = new(4,graphic)  

    do i = 0 , 3
        dum0(i)=gsn_add_polyline(wks0,tempab(4),xpts0(i:i+1),ypts0(i:i+1),resp)      
        dum1(i)=gsn_add_polyline(wks0,tempab(4),xpts1(i:i+1),ypts1(i:i+1),resp)      
        dum2(i)=gsn_add_polyline(wks0,tempab(4),xpts2(i:i+1),ypts2(i:i+1),resp)      
        dum3(i)=gsn_add_polyline(wks0,tempab(4),xpts3(i:i+1),ypts3(i:i+1),resp)      
    end do 

;colorbar
    lbar_h  = 0.07
    lbar_w  = 0.8
    lbar_x  = 0.1
    lbar_y  = 0.19
    ;clen   = 256                          ; # of colors in color map
    ;stride = ((clen-1) - 2) / nboxes    
    ;labels    = "" + fspan(400,6000,400) + ""
nboxes = 14                            ; # of labelbar boxes
fill_colors =cmap(25:225:15,:) 
labels=(/"-6","","-4","","-2","","0","","2","","4","","6"/);(/"-0.03","","-0.02","","-0.01","","0","","0.01","","0.02","","0.03"/);(/"-0.06","","-0.04","","-0.02","","0","","0.02","","0.04","","0.06"/)
;colorbar
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

    lbid4 = gsn_create_labelbar_ndc(wks0,nboxes,labels,lbar_x,lbar_y,lbres)

;drawNDCGrid(wks0)
draw(lbid4)
draw(tempab)
frame(wks0)
