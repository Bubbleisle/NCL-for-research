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


t1=f1->thetao
t2=f2->thetao
t3=f3->thetao(0,:,:,:)
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
/;
n=num(.not.ismissing(BTab))
s=num(ismissing(BTab))
m=num(.not.ismissing(BTre))
print(n)
print(m)
print(s)
exit
;=========================================================
;  把深度大于2000m的地方blank掉
;=========================================================

do m = 0,1079,1
    do n = 0,1439,1
        if .not.ismissing(th(25,m,n)) then
            BT0(m,n)=1e+30      
            BT1(m,n)=1e+30
            BTab(m,n)=1e+30      
            BTre(m,n)=1e+30
        end if 
    end do
end do

BT0@_FillValue=1e+30 
BT1@_FillValue=1e+30 
BTab@_FillValue=1e+30 
BTre@_FillValue=1e+30 
;/

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

;=========================================================
;  draw plots with explicit levels
;=========================================================

tempre=new(5, graphic)


wks1=gsn_open_wks("png","/mnt/e/pics/ssp585-BTre-0.1")

gsn_define_colormap(wks1,"BlWhRe")
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
res@cnLevels              = (/400,2000/)
res@cnLevelFlags        = (/"LineOnly","LineOnly"/)
res@cnLineColors=(/"red","blue"/)
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
tres@cnFillColors=(/30,36,42,48,61,65,69,73,77,81,85,89,93,97,102/);(/88,108,127,128,140,152,164,176,188,200,212,224,346,246,255/) ;(/50,56,62,63,64,72,80,87,93,100,107,114,120,127/) 
tres@cnLevelSelectionMode 	= "ExplicitLevels"  ; manually set cont levels\
tres@cnLevels              = (/-1,-0.2,-0.1,0,0.1,0.2,0.5,1,1.5,2,3,4,5,7/)
;tres@cnLevelFlags        = (/"NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine","NoLine"/)
tres@tmEqualizeXYSizes= True
tres@tmXBLabelFontHeightF=0.01 
tres@vpKeepAspect           = True
tres@cnLineLabelsOn         =False
tres@tiMainFontHeightF      =0.015
tres@tiMainString          ="Europe"
tres@vpXF                   = 0.05       ; Same X location as first plot
tres@vpYF                   = 0.8        ; Lower on the page
tres@vpWidthF               =0.32
tres@vpHeightF              =0.16
tres@mpMaxLatF              =  70             ; Europe
tres@mpMinLatF              =  45
tres@mpMaxLonF              =  30
tres@mpMinLonF              =  -15;/

tres0=tres
;tres0@lbLabelBarOn           = False
tres0@tiMainString          ="China"
tres0@vpXF                  =0.7
tres0@vpYF                  =0.54
tres0@vpWidthF              =0.3
tres0@vpHeightF             =0.3
tres0@mpMaxLatF            =  42             ; China
tres0@mpMinLatF             = 0
tres0@mpMaxLonF             =  130
tres0@mpMinLonF             =  98

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
tres1@tiMainString          ="Australia"
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

ypts0 = (/70.0, 70.0, 45.0, 45.0, 70.0/)        ; Europe
xpts0 = (/-15.0, 30.0, 30.0, -15.0, -15.0/)
ypts1 = (/52.0, 52.0, 24.0, 24.0, 52.0/)        ;East coast of america
xpts1 = (/277.0, 318.0, 318.0, 277.0, 277.0/)
ypts2 = (/42.0, 42.0, 0.0, 0.0, 42.0/)          ;china
xpts2 = (/98.0, 130.0, 130.0, 98.0, 130.0/)
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
nboxes = 15                            ; # of labelbar boxes
;clen   = 256                          ; # of colors in color map
;stride = ((clen-1) - 2) / nboxes    
fill_colors =(/30,36,42,48,61,65,69,73,77,81,85,89,93,97,102/);(/88,108,127,128,140,152,164,176,188,200,212,224,236,246,255/) 
;labels    = "" + fspan(400,6000,400) + ""

labels=(/"-1","-0.2","-0.1","0","0.1","0.2","0.5","1","1.5","2","3","4","5","7"/)
;labels=(/"400","1200","2000","2800","3600","4400","5200","6000",""/)
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