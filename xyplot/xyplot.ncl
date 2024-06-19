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
    ts=(t1+t2+t3+t4)/4
    th=(t5+t6+t7+t8)/4
    dt=ts-th
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
                BTab(m,n)=dt(33,m,n)        
                BTre(m,n)=BTab(m,n)-dta1(33,m,n)         
            else if .not.ismissing(th(1,m,n)) then; in ocean area
                i=1
                do while(i.le.32 .and. .not.ismissing(th(i,m,n)))
                    i=i+1
                end do
                BTab(m,n)=dt(i-1,m,n)
                BTre(m,n)=BTab(m,n)-dta1(i-1,m,n)
            else 
                BTab(m,n)=dt(0,m,n)           
                BTre(m,n)=BTab(m,n)-dta1(0,m,n)
            end if
            end if
        end do
    end do
    dst=dt(1,:,:)
    do m = 0,1079,1
        do n = 0,1439,1
            if .not.ismissing(th(1,m,n)) .and. ismissing(th(2,m,n)) then;in the deepest area
                BTab(m,n)=BTab@_FillValue        
                dst(m,n)=dst@_FillValue      
            else 
                BTab(m,n)=BTab(m,n)
                dst(m,n)=dst(m,n)           
            end if
        end do
    end do

    BTshallow=where(depth.le.200, BTab, BTab@_FillValue)
    dtshallow=where(depth.le.200, dst, dst@_FillValue)
    BTshallow!0="lat"
    BTshallow!1="lon"
    BTshallow&lat=lat
    BTshallow&lon=lon
    dtshallow!0="lat"
    dtshallow!1="lon"
    dtshallow&lat=lat
    dtshallow&lon=lon
dBT=new((/4,53040/), float, dst@_FillValue)
dST=new((/4,53040/), float, dst@_FillValue)
dBT(0,0:29999)=ndtooned(BTshallow({2:42},{99:130}))
dST(0,0:29999)=ndtooned(dtshallow({2:42},{99:130}))
dBT(1,:)=ndtooned(BTshallow({-5:-45},{105:160}))
dST(1,:)=ndtooned(dtshallow({-5:-45},{105:160}))
dBT(2,0:25433)=ndtooned(BTshallow({25:52},{277:316}))
dST(2,0:25433)=ndtooned(dtshallow({25:52},{277:316}))
dBT(3,0:36455)=ndtooned(BTshallow({50:78},{0:54}))
dST(3,0:36455)=ndtooned(dtshallow({50:78},{0:54}))


wks = gsn_open_wks("png","/mnt/e/xyplot")      ; send graphics to PNG file
plot=new(4,graphic)
res=True
res@gsnDraw         =False
res@gsnFrame        =False
res@tiMainString     = "dSST&dBT - Seas around China"          ; add title
res@xyMarkLineModes   = "Markers"                ; choose which have markers
res@xyMarkers         =  16                      ; choose type of marker  
res@xyMarkerColor     = "blue"                  ; Marker color
res@xyMarkerSizeF     = 0.01                     ; Marker size (default 0.01)
res@tmLabelAutoStride = True                     ; nice tick mark labels
res@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
res@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticks inward
res@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
res@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticks inward
res@xyMarkerOpacityF        = 0.1
res@trXMinF                 =0.0
res@trXMaxF                 =5.0
res@trYMinF                 =-1.0
res@trYMaxF                 =5.0
res1=res
delete(res1@xyMarkerColor)
res1@xyMarkerColor          ="red"
res1@tiMainString     = "dSST&dBT - Seas around Australia"  
res2=res
delete(res2@xyMarkerColor)
res2@xyMarkerColor          ="green"
res2@tiMainString     = "dSST&dBT - East coast of America"  
res3=res
delete(res3@xyMarkerColor)
res3@xyMarkerColor          ="purple"
res3@tiMainString     = "dSST&dBT - Seas around Norway"  

plot(0)= gsn_csm_xy (wks,dST(0,:),dBT(0,:),res)
plot(1)  = gsn_csm_xy (wks,dST(1,:),dBT(1,:),res1)
plot(2)  = gsn_csm_xy (wks,dST(2,:),dBT(2,:),res2)
plot(3) = gsn_csm_xy (wks,dST(3,:),dBT(3,:),res3)
resp = True
gsn_panel(wks,plot,(/2,2/),resp)
;draw(plot)
;frame(wks)