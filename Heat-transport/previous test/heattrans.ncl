;read in files
    f1=addfile("/mnt/f/CMIP6-data/vo/AWI-hist-1985-2014-winter-remap.nc", "r")
    f2=addfile("/mnt/f/CMIP6-data/vo/AWI-ssp245-2071-2100-winter-remap.nc", "r")
    fd=addfile("/mnt/e/CMIP6-data/area-file/depth-GFDL-CM4-remap.nc","r")
    dxx=asciiread("/mnt/e/CMIP6-data/area-file/dx-1080.txt", 1080, "float")
    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
    voh=f1->vo(0,:,:,:)
    vos=f2->vo(0,:,:,:)
    lat=f1->lat    
    lon=f1->lon
    depth=f1->depth
    depth(0)=0
    lev=dble2flt(depth)
    f2=addfile("/mnt/f/CMIP6-data/so/AWI-ssp245-2071-2100-remap.nc","r")
    f3=addfile("/mnt/f/CMIP6-data/so/AWI-hist-1985-2014-remap.nc","r")
    f4=addfile("/mnt/e/CMIP6-data/ssp245/AWI-ssp245-2071-2100-remap-ave.nc","r");t;d
    f5=addfile("/mnt/e/CMIP6-data/historical/AWI-hist-1985-2014-remap-ave.nc","r");t;d
    ss=f2->so(0,:,:,:)
    sh=f3->so(0,:,:,:)
    tss=f4->thetao(0,:,:,:)
    thh=f5->thetao(0,:,:,:)
    dt=tss-thh
    dt!1="lat"
    dt!2="lon"
    dt&lat=lat
    dt&lon=lon
    delete(f2)
    delete(f3)
    delete(f4)
    delete(f5)

;calculate potential density(pd)with rho_mwjf
    pds=new((/46,1080,1440/),float, ss@_FillValue)
    pdh=new((/46,1080,1440/),float, ss@_FillValue)
    do i=0,45,1
        pds(i,:,:)=rho_mwjf(tss(i,:,:), ss(i,:,:), lev(i))
        pdh(i,:,:)=rho_mwjf(thh(i,:,:), sh(i,:,:), lev(i))
    end do

;data prep
    latx=35
    lons=119
    lone=127
    lone2=127.25
    depthlev=15; how many levels are there in the rigion
    n=new((/1/), integer, 0); the corresponding lat
    m=0
    x=lat(m)-latx
    do while(x.lt.0)
        m=m+1
        x=lat(m)-latx
    end do
    n=m
    dx=dxx(n);distance of thte box at the latitude
    cp=3890;海水比热容
    vh=voh(0:depthlev+1,{latx},{lons:lone2})
    print(vh(2,:))
    exit

    vs=vos(0:depthlev+1,{latx},{lons:lone2})
    dh=pdh(0:depthlev+1,{latx},{lons:lone2})
    ds=pds(0:depthlev+1,{latx},{lons:lone2})
    ts=tss(0:depthlev+1,{latx},{lons:lone2})
    th=thh(0:depthlev+1,{latx},{lons:lone2})
    lonnum1=dimsizes(vh)
    lonnum=lonnum1(1)-1;the size of the longitude dim,uesd in the loop
    levspace=new((/depthlev+1/), float, ts@_FillValue)
    do i = 0,depthlev,1
        levspace(i)=lev(i+1)-lev(i)
    end do
    dz=conform_dims((/depthlev+1,lonnum/), levspace, 0);distance of the box vertically(truned into the size of v)
/;

;bottom temp calculation
    BT0=new((/1080,1440/), float,th@_FillValue);bottome temp-pic
    BT1=new((/1080,1440/), float,th@_FillValue);bottome temp-first 5 years ave -4co2
    BTab=new((/1080,1440/), float,th@_FillValue);absolute-bottome temp rise
    BTre=new((/1080,1440/), float,th@_FillValue); relative-bottome temp rise (absolute-ave temprise at the depth)
    ta0=new((/46/), float,th@_FillValue); ave temp at diff depth - pic
    ta1=new((/46/), float,th@_FillValue); ave temp at diff depth - 4co2
    do i= 0,45,1
        ta0(i)=wgt_areaave(th(i,:,:), area, 1, 0)
        ta1(i)=wgt_areaave(ts(i,:,:), area, 1, 0)
    end do
    dta_1=ta1-ta0; ave temp rise at diff depth : pic-4co2
    dta1=conform_dims(dimsizes(th), dta_1, 0); turn into 3d

    do m = 0,1079,1
        do n = 0,1439,1
            if .not.ismissing(th(45,m,n)) then;in the deepest area
                BT0(m,n)=th(45,m,n)
                BT1(m,n)=ts(45,m,n)
                BTab(m,n)=BT1(m,n)-BT0(m,n)           
                BTre(m,n)=BTab(m,n)-dta1(45,m,n)         
            else if .not.ismissing(th(1,m,n)) then; in ocean area
                i=1
                do while(i.le.44 .and. .not.ismissing(th(i,m,n)))
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
    BTre!0="lat"
    BTre!1="lon"
    BTre&lat=lat
    BTre&lon=lon

;map
    wks2 = gsn_open_wks("png","/mnt/e/transmap-"+latx+" N")
    res1=True
    res1@gsnFrame              = False 
    res1@gsnDraw               = False 
    gsn_define_colormap(wks2,"NCV_blu_red")
    res1@cnFillOn             = True       ; turn on color fill
    res1@cnLineLabelsOn       = False      ; turns off contour line labels
    res1@cnInfoLabelOn        = False      ; turns off contour info label
    res1@mpMaxLatF             =  42             ; China
    res1@mpMinLatF             =  2
    res1@mpMaxLonF             =  130
    res1@mpMinLonF             =  99
    ;res1@cnLevelSelectionMode   ="ManualLevels"
    res1@cnFillColors=(/74,87,100,113,138,151,164,177,190,203,216,229,242,255/)
    res1@cnLevelSelectionMode 	= "ExplicitLevels"  ; manually set cont levels\
    res1@cnLevels              = (/-0.5,-0.2,-0.1,0,0.1,0.4,0.8,1.5,2,2.5,3,3.5/)
    res1@tiMainString              = "Slice at "+latx+" N" ; main title
    res1@gsnLeftString             = "Relative Bottom Temp rise"
    plot2=gsn_csm_contour_map(wks2, th(0,:,:), res1)
    resp                  = True                      ; polyline mods desired
    resp@gsLineColor      = "black"                     ; color of lines
    resp@gsLineThicknessF = 2.0                       ; thickness of lines
    ypts = (/latx, latx/)   
    xpts = (/lons, lone/)
    dum9=gsn_add_polyline(wks2, plot2,xpts(0:1),ypts(0:1),resp)
    draw(plot2)
    frame(wks2)

;/
;heat transport calculation

heats=new((/depthlev+1,lonnum/),float,vh@_FillValue)
heath=new((/depthlev+1,lonnum/),float,vh@_FillValue)
vcs=new((/depthlev+1,lonnum/),float,vh@_FillValue)
dcs=new((/depthlev+1,lonnum/),float,vh@_FillValue)
tcs=new((/depthlev+1,lonnum/),float,vh@_FillValue)
vch=new((/depthlev+1,lonnum/),float,vh@_FillValue)
dch=new((/depthlev+1,lonnum/),float,vh@_FillValue)
tch=new((/depthlev+1,lonnum/),float,vh@_FillValue)

do m=0,depthlev,1
    do n=0,lonnum-1,1
        vcs(m,n)=(vs(m,n)+vs(m+1,n)+vs(m,n+1)+vs(m+1,n+1))/4
        vch(m,n)=(vh(m,n)+vh(m+1,n)+vh(m,n+1)+vh(m+1,n+1))/4
        dcs(m,n)=(ds(m,n)+ds(m+1,n)+ds(m,n+1)+ds(m+1,n+1))/4
        dch(m,n)=(dh(m,n)+dh(m+1,n)+dh(m,n+1)+dh(m+1,n+1))/4
        tcs(m,n)=(ts(m,n)+ts(m+1,n)+ts(m,n+1)+ts(m+1,n+1))/4
        tch(m,n)=(th(m,n)+th(m+1,n)+th(m,n+1)+th(m+1,n+1))/4
        heats(m,n)=vcs(m,n)*dcs(m,n)*tcs(m,n)*dx*dz(m,n)
        heath(m,n)=vch(m,n)*dch(m,n)*tch(m,n)*dx*dz(m,n)
    end do
end do

heattrans=sum(heats)
heattranh=sum(heath)
print(heath(2,:))
print(heattranh)
print(heattrans)
exit

;slice
T=dt(0:depthlev,{latx},{lons:lone})
lon_t = f1->lon({lons:lone})
z_t   = f1->depth(0:depthlev)
wks1 = gsn_open_wks("png","/mnt/e/heattransslice-"+latx+" N")      ; send graphics to PNG file
res=True
cmap = read_colormap_file("MPL_YlOrRd" )
res@cnFillOn             = True       ; turn on color fill
res@cnLineLabelsOn       = False      ; turns off contour line labels
res@cnInfoLabelOn        = False      ; turns off contour info label
res@cnFillPalette        = cmap(:,:); set color map
res@lbOrientation        = "vertical" ; vertical label bar
/;
res@cnLevelSelectionMode = "ManualLevels"
res@cnLinesOn            =False
res@cnMaxLevelValF       = 2.9
res@cnMinLevelValF       = 1.8
res@cnLevelSpacingF      = 0.1
;/
res@sfXArray             = lon_t      ; uses lon_t as plot x-axis
res@sfYArray             = z_t        ; convert cm to m
;res@gsnYAxisIrregular2Linear = True   ; converts irreg depth to linear 
res@trYReverse               = True   ; reverses y-axis
res@tiMainString              = "Slice at "+latx+" N" ; main title
res@gsnLeftString               ="Heat transport in winter"
plot = gsn_csm_contour(wks1,T,res)     ; create plot



