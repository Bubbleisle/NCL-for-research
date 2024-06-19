f1=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")

t=f1->deptho


lat=f1->lat
lon=f1->lon
t!0="lat"
t!1="lon"
t&lat=lat
t&lon=lon

setvalues NhlGetWorkspaceObjectId()
"wsMaximumSize" : 500000000
end setvalues
;/
wks=gsn_open_wks("png","/mnt/e/pics/Depthmap-Barents")
gsn_define_colormap(wks,"cmocean_deep")

res                        = True
res@gsnDraw                = False                             ; don't draw yet
res@gsnFrame               = False                             ; don't advance yet
res@lbLabelBarOn           = False
res@cnFillOn               =True
res@cnLinesOn              = False
res@cnInfoLabelOn          = False
res@cnFillPalette          ="cmocean_deep"
res@mpMaxLatF              =  78             ; Europe
res@mpMinLatF              =  50
res@mpMaxLonF              =  54
res@mpMinLonF              =  0
res@vpKeepAspect           = True
res@vpWidthF               =0.32
res@vpHeightF              =0.16
res@vpXF                   = 0.06       ; Same X location as first plot
res@vpYF                   = 0.8        ; Lower on the page
res@cnLineLabelsOn         =False
res@gsnLeftString          =""
res@tiMainFontHeightF      =0.015
res@tiMainString           ="Seas Around Norway"
res@tmEqualizeXYSizes      = True
res@tmXBLabelFontHeightF   =0.01

plot1=gsn_csm_contour_map(wks, t, res)
res1=res
;res1@vpWidthF             =0.25
res1@vpHeightF             =0.16
res1@vpXF                  = 0.39       ; Same X location as first plot
res1@vpYF                  = 0.8        ; Lower on the page
res1@mpMaxLatF             =  -5             ; Australia
res1@mpMinLatF             = -45
res1@mpMaxLonF             =  160
res1@mpMinLonF             = 105
res1@tiMainString          ="Seas Around Australia"
plot2 = gsn_csm_contour_map_ce(wks,t,res1)
res2=res
;res2@vpWidthF             =0.26
res2@vpHeightF             =0.16
res2@vpXF                  = 0.68       ; Same X location as first plot
res2@vpYF                  = 0.8        ; Lower on the page
res2@mpMaxLatF             =  52             ; East coast
res2@mpMinLatF             = 25
res2@mpMaxLonF             =  -42
res2@mpMinLonF             =  -83
res2@tiMainString="Northwest Atlantic"
plot3 = gsn_csm_contour_map_ce(wks,t,res2)

res3=True
res3@lbLabelBarOn           = False
res3@gsnDraw                = False                             ; don't draw yet
res3@gsnFrame               = False                             ; don't advance yet
res3@cnFillOn               =True
res3@cnLinesOn              = False
res3@cnInfoLabelOn          = False
res3@cnFillPalette          ="cmocean_deep"
;res3@mpCenterLonF           =180
res3@vpKeepAspect           = True
res3@cnLineLabelsOn         =False
res3@gsnLeftString          =""
res3@tiMainFontHeightF      =0.015
res3@tmEqualizeXYSizes      = True
res3@tmXBLabelFontHeightF   =0.01
res3@vpXF                   =0.07
res3@vpYF                   =0.54
res3@vpWidthF              =0.6
res3@vpHeightF             =0.3
res3@tiMainString           ="Global"
plot4= gsn_csm_contour_map_ce(wks,t,res3)

res4=res
delete(res4@mpMaxLatF)
delete(res4@mpMaxLonF)
delete(res4@mpMinLatF)
delete(res4@mpMinLonF)
delete(res4@vpXF)
delete(res4@vpYF)
delete(res4@vpHeightF)
delete(res4@vpWidthF)
res4@vpXF                  =0.7
res4@vpYF                  =0.54
res4@vpHeightF             =0.3
res4@vpWidthF              =0.3
res4@mpMaxLatF             =  42             ; China
res4@mpMinLatF             =  2
res4@mpMaxLonF             =  130
res4@mpMinLonF             =  99
res4@tiMainString           ="Seas Around China"
plot5 =gsn_csm_contour_map_ce(wks,t,res4)

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
resp@gsLineThicknessF = 3.0                       ; thickness of lines
;resp@gsLineLabelString= "Europe"                    ; adds a line label string

dum0 = new(4,graphic)  
dum1 = new(4,graphic)  
dum2 = new(4,graphic)  
dum3 = new(4,graphic)  

do i = 0 , 3
    dum0(i)=gsn_add_polyline(wks,plot4,xpts0(i:i+1),ypts0(i:i+1),resp)          
    dum1(i)=gsn_add_polyline(wks,plot4,xpts1(i:i+1),ypts1(i:i+1),resp)       
    dum2(i)=gsn_add_polyline(wks,plot4,xpts2(i:i+1),ypts2(i:i+1),resp)       
    dum3(i)=gsn_add_polyline(wks,plot4,xpts3(i:i+1),ypts3(i:i+1),resp)      
end do 

lbar_h  = 0.07
lbar_w  = 0.8
lbar_x  = 0.1
lbar_y  = 0.19
nboxes = 17                            ; # of labelbar boxes
clen   = 256                          ; # of colors in color map
stride = ((clen-1) - 2) / nboxes    
fill_colors = ispan(2,clen-1,stride)
;labels    = "" + fspan(400,6000,400) + ""

labels=(/"400","800","1200","1600","2000","2400","2800","3200","3600","4000","4400","4800","5200","5600","6000","",""/)
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
;lbres@lbLabelJust          = "Center"
lbres@lbLabelFontHeightF   =0.01

lbid4 = gsn_create_labelbar_ndc(wks,nboxes,labels,lbar_x,lbar_y,lbres)
;gsn_panel(wks,temp,(/1,2/),pres)
;drawNDCGrid(wks)
draw(plot1)
draw(plot2)
draw(plot3)
draw(plot4)
draw(plot5)
draw(lbid4)
frame(wks)