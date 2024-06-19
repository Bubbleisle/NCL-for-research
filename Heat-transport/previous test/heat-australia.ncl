; notice:
    /;
        step1: check latitude & longitude for the rigion; set the parau&parav equal to 1
        step2: check map wks & output file name; draw the map to double check the coordinates; calculate the volume transport; calculate the parau&parav to maintain conservation of volume
        step3: change the parameters; semicolon the map-draw part of the code, don't draw the map; calculate the volume transport and the heat transport
    ;/
parau=1;define parameter for u to maintain conservation of volume
parav=1;define parameter for v to maintain conservation of volume
;read in files
    f1=addfile("/mnt/f/CMIP6-data/vo/AWI-hist-1985-2014-remap-34l.nc", "r")
    f2=addfile("/mnt/f/CMIP6-data/vo/GFDL-CM4-hist-1985-2014-remap-34l.nc", "r")
    f3=addfile("/mnt/f/CMIP6-data/vo/MPI-hist-1985-2014-remap-34l.nc", "r")
    f4=addfile("/mnt/f/CMIP6-data/vo/AWI-ssp245-2071-2100-remap-34l.nc", "r")
    f5=addfile("/mnt/f/CMIP6-data/vo/GFDL-CM4-ssp245-2071-2100-remap-34l.nc", "r")
    f6=addfile("/mnt/f/CMIP6-data/vo/MPI-ssp245-2071-2100-remap-34l.nc", "r")
    dxx=asciiread("/mnt/e/CMIP6-data/area-file/dx-1080.txt", 1080, "float")
    area=asciiread("/mnt/e/CMIP6-data/area-file/Interpolated1440x1080.txt", 1080, "float")
    v1=f1->vo(0,:,:,:)
    v2=f2->vo(0,:,:,:)
    v3=f3->vo(0,:,:,:)
    v4=f4->vo(0,:,:,:)
    v5=f5->vo(0,:,:,:)
    v6=f6->vo(0,:,:,:)
    lat=f1->lat
    lon=f1->lon
    depth=f1->depth
    depth(0)=0
    lev=dble2flt(depth)
    voh=(v1+v2+v3)/3*parav
    vos=(v4+v5+v6)/3*parav
    voh!1="lat"
    voh!2="lon"
    voh&lat=lat
    voh&lon=lon
    vos!1="lat"
    vos!2="lon"
    vos&lat=lat
    vos&lon=lon
    delete(f1)
    delete(f2)
    delete(f3)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(v1)
    delete(v2)
    delete(v3)
    delete(v4)
    delete(v5)
    delete(v6)

    f1=addfile("/mnt/f/CMIP6-data/uo/AWI-hist-1985-2014-remap-34l.nc", "r")
    f2=addfile("/mnt/f/CMIP6-data/uo/GFDL-CM4-hist-1985-2014-remap-34l.nc", "r")
    f3=addfile("/mnt/f/CMIP6-data/uo/MPI-hist-1985-2014-remap-34l.nc", "r")
    f4=addfile("/mnt/f/CMIP6-data/uo/AWI-ssp245-2071-2100-remap-34l.nc", "r")
    f5=addfile("/mnt/f/CMIP6-data/uo/GFDL-CM4-ssp245-2071-2100-remap-34l.nc", "r")
    f6=addfile("/mnt/f/CMIP6-data/uo/MPI-ssp245-2071-2100-remap-34l.nc", "r")
    u1=f1->uo(0,:,:,:)
    u2=f2->uo(0,:,:,:)
    u3=f3->uo(0,:,:,:)
    u4=f4->uo(0,:,:,:)
    u5=f5->uo(0,:,:,:)
    u6=f6->uo(0,:,:,:)
    uoh=(u1+u2+u3)/3*parau
    uos=(u4+u5+u6)/3*parau
    uoh!1="lat"
    uoh!2="lon"
    uoh&lat=lat
    uoh&lon=lon
    uos!1="lat"
    uos!2="lon"
    uos&lat=lat
    uos&lon=lon
    delete(f1)
    delete(f2)
    delete(f3)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(u1)
    delete(u2)
    delete(u3)
    delete(u4)
    delete(u5)
    delete(u6)

    f1=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-ssp245-2071-2100-remap-34l-ave.nc","r");t;d
    f2=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-ssp245-2071-2100-remap-34l-ave.nc","r")
    f4=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-ssp245-2071-2100-remap-34l-ave.nc","r");t
    f5=addfile("/mnt/e/CMIP6-data/Rigionalmap/AWI-hist-1985-2014-remap-34l-ave.nc","r");t;d
    f6=addfile("/mnt/e/CMIP6-data/Rigionalmap/GFDL-CM4-hist-1985-2014-remap-34l-ave.nc","r")
    f8=addfile("/mnt/e/CMIP6-data/Rigionalmap/MPI-HR-hist-1985-2014-remap-34l-ave.nc","r");t
    t1=f1->thetao(0,:,:,:)
    t2=f2->thetao(:,:,:)
    t4=f4->thetao(0,:,:,:)
    t5=f5->thetao(0,:,:,:)
    t6=f6->thetao(:,:,:)
    t8=f8->thetao(0,:,:,:)
    tss=(t1+t2+t4)/4
    thh=(t5+t6+t8)/4
    tss!1="lat"
    tss!2="lon"
    tss&lat=lat
    tss&lon=lon
    thh!1="lat"
    thh!2="lon"
    thh&lat=lat
    thh&lon=lon
    dt=tss-thh
    dt!1="lat"
    dt!2="lon"
    dt&lat=lat
    dt&lon=lon
    delete(t1)
    delete(t2)
    delete(t4)
    delete(t5)
    delete(t6)
    delete(t8)
    delete(f1)
    delete(f2)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(f8)
;data prep
    lats=-18
    late=-8
    late1=late+0.1
    lons=125;box1左
    lone1=142;box1右
    lone3=lone1+0.25
    depthlev=32;32; how many levels are there in the rigion
;calculate the dx dz cp and lonnum latnum 
    n=new((/1/), integer, 0); the corresponding lat
    m=0
    q=0
    x=lat(m)-lats
    y=lat(q)-late
    do while(x.lt.0)
        m=m+1
        x=lat(m)-lats
    end do
    do while(y.lt.0)
        q=q+1
        y=lat(q)-late
    end do
    dxs=dxx(m);distance of the south side of the box at the latitude of lats
    dxe=dxx(q);distance of the north side of the box at the latitude of late
    dy=18533.1276041;distance of the box at every longitude(equally divined)
    cp=3890;海水比热容
    veg=voh(0:depthlev+1,{lats:late1},{lons:lone3})
    dimnum=dimsizes(veg)
    delete(veg)
    lonnum=dimnum(2)-1;the size of the longitude dim,uesd in the loop
    latnum=dimnum(1)-1;the size of the latitude dim,uesd in the loop
    levspace=new((/depthlev+1/), float, tss@_FillValue)
    do i = 0,depthlev,1
        levspace(i)=lev(i+1)-lev(i)
    end do
    dzlon=conform_dims((/depthlev+1,lonnum/), levspace, 0);distance of the box vertically(truned into the size of v)
    dzlat=conform_dims((/depthlev+1,latnum/), levspace, 0);distance of the box vertically(truned into the size of v)
;map  

    wks2 = gsn_open_wks("png","/mnt/e/transmap-australia-2")
    res1=True
    res1@gsnFrame              = False 
    res1@gsnDraw               = False 
    gsn_define_colormap(wks2,"MPL_YlOrRd")
    res1@cnFillOn             = True       ; turn on color fill
    res1@cnLineLabelsOn       = False      ; turns off contour line labels
    res1@cnInfoLabelOn        = False      ; turns off contour info label
    res1@mpMaxLatF             =  -5             ; Australia
    res1@mpMinLatF             = -45
    res1@mpMaxLonF             =  160
    res1@mpMinLonF             = 105
    res1@cnLevelSelectionMode = "ManualLevels"
    res1@cnMaxLevelValF       = 4
    res1@cnMinLevelValF       = 0.5
    res1@cnLevelSpacingF      = 0.5
    res1@tiMainString              = "SST rise in seas around Australia" ; main title
    res1@gsnLeftString             = ""
    res1@gsnRightString             ="Celsius"
    res1@gsnStringFontHeightF      =14
    plot2=gsn_csm_contour_map(wks2, dt(1,:,:), res1)
    xpts1 = (/lons, lons, lone1, lone1, lons/)      ;australia
    ypts1 = (/lats, late, late, lats, lats/)
    resp                  = True                      ; polyline mods desired
    resp@gsLineColor      = "black"                     ; color of lines
    resp@gsLineThicknessF = 2.0                       ; thickness of lines
    dum0 = new(4,graphic)  
    dum1 = new(4,graphic)  
    do i = 0 , 3
        dum0(i)=gsn_add_polyline(wks2,plot2,xpts1(i:i+1),ypts1(i:i+1),resp)        
    end do 
    draw(plot2)
    frame(wks2)
exit

;/
;read in salinity file ----ss&sh
    f1=addfile("/mnt/f/CMIP6-data/so/AWI-ssp245-2071-2100-remap-34l.nc","r")
    f2=addfile("/mnt/f/CMIP6-data/so/GFDL-CM4-ssp245-2071-2100-remap-34l.nc","r")
    f4=addfile("/mnt/f/CMIP6-data/so/MPI-ssp245-2071-2100-remap-34l-2.nc","r")
    f5=addfile("/mnt/f/CMIP6-data/so/AWI-hist-1985-2014-remap-34l.nc","r")
    f6=addfile("/mnt/f/CMIP6-data/so/GFDL-CM4-hist-1985-2014-remap-34l.nc","r")
    f8=addfile("/mnt/f/CMIP6-data/so/MPI-hist-1985-2014-remap-34l-2.nc","r")
    s1=f1->so(0,:,:,:)
    s2=f2->so(0,:,:,:)
    s4=f4->so(0,:,:,:)
    s5=f5->so(0,:,:,:)
    s6=f6->so(0,:,:,:)
    s8=f8->so(0,:,:,:)
    ss=(s1+s2+s4)/4
    sh=(s5+s6+s8)/4
    delete(s1)
    delete(s2)
    delete(s4)
    delete(s5)
    delete(s6)
    delete(s8)
    delete(f1)
    delete(f2)
    delete(f4)
    delete(f5)
    delete(f6)
    delete(f8)
;calculate potential density(pd)with rho_mwjf
    delete(area@_FillValue)
    area@_FillValue=1e+30

    pds=new((/34,1080,1440/),float, ss@_FillValue)
    pdh=new((/34,1080,1440/),float, ss@_FillValue)

    do i=0,33,1
        pds(i,:,:)=rho_mwjf(tss(i,:,:), ss(i,:,:), lev(i))
        pdh(i,:,:)=rho_mwjf(thh(i,:,:), sh(i,:,:), lev(i))
    end do
    pds!1="lat"
    pds!2="lon"
    pds&lat=lat
    pds&lon=lon
    pdh!1="lat"
    pdh!2="lon"
    pdh&lat=lat
    pdh&lon=lon
;data prep 2
    vh1=voh(0:depthlev+1,{lats},{lons:lone3});横边下
    vs1=vos(0:depthlev+1,{lats},{lons:lone3})
    vh2=voh(0:depthlev+1,{late},{lons:lone3});横边上
    vs2=vos(0:depthlev+1,{late},{lons:lone3})
    uh3=uoh(0:depthlev+1,{lats:late1},{lons});竖边左
    us3=uos(0:depthlev+1,{lats:late1},{lons})
    uh4=uoh(0:depthlev+1,{lats:late1},{lone1});竖边右
    us4=uos(0:depthlev+1,{lats:late1},{lone1})
    
    dh1=pdh(0:depthlev+1,{lats},{lons:lone3});横边下
    ds1=pds(0:depthlev+1,{lats},{lons:lone3})
    dh2=pdh(0:depthlev+1,{late},{lons:lone3});横边上
    ds2=pds(0:depthlev+1,{late},{lons:lone3})
    dh3=pdh(0:depthlev+1,{lats:late1},{lons});竖边左
    ds3=pds(0:depthlev+1,{lats:late1},{lons})
    dh4=pdh(0:depthlev+1,{lats:late1},{lone1});竖边右
    ds4=pds(0:depthlev+1,{lats:late1},{lone1})
    
    th1=thh(0:depthlev+1,{lats},{lons:lone3});横边下
    ts1=tss(0:depthlev+1,{lats},{lons:lone3})
    th2=thh(0:depthlev+1,{late},{lons:lone3});横边上
    ts2=tss(0:depthlev+1,{late},{lons:lone3})
    th3=thh(0:depthlev+1,{lats:late1},{lons});竖边左
    ts3=tss(0:depthlev+1,{lats:late1},{lons})
    th4=thh(0:depthlev+1,{lats:late1},{lone1});竖边右
    ts4=tss(0:depthlev+1,{lats:late1},{lone1})
;new data arrays define
    heatshlon=new((/4,depthlev+1,lonnum/),float,voh@_FillValue);0:s bottom, 1:s top, 2:h bottom, 3:h top
    heatshlat=new((/4,depthlev+1,latnum/),float,voh@_FillValue);0:s left, 1:s right, 2:h left, 3:h right
    colshlon=new((/4,depthlev+1,lonnum/),float,voh@_FillValue);0:s bottom, 1:s top, 2:h bottom, 3:h top
    colshlat=new((/4,depthlev+1,latnum/),float,voh@_FillValue);0:s left, 1:s right, 2:h left, 3:h right
    vcshlon=new((/4,depthlev+1,lonnum/),float,voh@_FillValue);0:s bottom, 1:s top, 2:h bottom, 3:h top
    ucshlat=new((/4,depthlev+1,latnum/),float,voh@_FillValue);0:s left, 1:s right, 2:h left, 3:h right
    dcshlon=new((/4,depthlev+1,lonnum/),float,voh@_FillValue);0:s bottom, 1:s top, 2:h bottom, 3:h top
    dcshlat=new((/4,depthlev+1,latnum/),float,voh@_FillValue);0:s left, 1:s right, 2:h left, 3:h right
    tcshlon=new((/4,depthlev+1,lonnum/),float,voh@_FillValue);0:s bottom, 1:s top, 2:h bottom, 3:h top
    tcshlat=new((/4,depthlev+1,latnum/),float,voh@_FillValue);0:s left, 1:s right, 2:h left, 3:h right
    
;calculate volume transport
    do m=0,depthlev,1
        do n=0,lonnum-1,1
            vcshlon(0,m,n)=(vs1(m,n)+vs1(m+1,n)+vs1(m,n+1)+vs1(m+1,n+1))/4
            vcshlon(1,m,n)=(vs2(m,n)+vs2(m+1,n)+vs2(m,n+1)+vs2(m+1,n+1))/4
            vcshlon(2,m,n)=(vh1(m,n)+vh1(m+1,n)+vh1(m,n+1)+vh1(m+1,n+1))/4
            vcshlon(3,m,n)=(vh2(m,n)+vh2(m+1,n)+vh2(m,n+1)+vh2(m+1,n+1))/4
            dcshlon(0,m,n)=(ds1(m,n)+ds1(m+1,n)+ds1(m,n+1)+ds1(m+1,n+1))/4
            dcshlon(1,m,n)=(ds2(m,n)+ds2(m+1,n)+ds2(m,n+1)+ds2(m+1,n+1))/4
            dcshlon(2,m,n)=(dh1(m,n)+dh1(m+1,n)+dh1(m,n+1)+dh1(m+1,n+1))/4
            dcshlon(3,m,n)=(dh2(m,n)+dh2(m+1,n)+dh2(m,n+1)+dh2(m+1,n+1))/4
            tcshlon(0,m,n)=(ts1(m,n)+ts1(m+1,n)+ts1(m,n+1)+ts1(m+1,n+1))/4
            tcshlon(1,m,n)=(ts2(m,n)+ts2(m+1,n)+ts2(m,n+1)+ts2(m+1,n+1))/4
            tcshlon(2,m,n)=(th1(m,n)+th1(m+1,n)+th1(m,n+1)+th1(m+1,n+1))/4
            tcshlon(3,m,n)=(th2(m,n)+th2(m+1,n)+th2(m,n+1)+th2(m+1,n+1))/4
            colshlon(0,m,n)=vcshlon(0,m,n)*dxs*dzlon(m,n); volume transported through the bottom line,ssp245
            colshlon(1,m,n)=vcshlon(1,m,n)*dxe*dzlon(m,n); volume transported through the top line,ssp245
            colshlon(2,m,n)=vcshlon(2,m,n)*dxs*dzlon(m,n); volume transported through the bottom line,historical
            colshlon(3,m,n)=vcshlon(3,m,n)*dxe*dzlon(m,n); volume transported through the top line,hitorical
            heatshlon(0,m,n)=vcshlon(0,m,n)*dcshlon(0,m,n)*tcshlon(0,m,n)*dxs*dzlon(m,n)
            heatshlon(1,m,n)=vcshlon(1,m,n)*dcshlon(1,m,n)*tcshlon(1,m,n)*dxe*dzlon(m,n)
            heatshlon(2,m,n)=vcshlon(2,m,n)*dcshlon(2,m,n)*tcshlon(2,m,n)*dxs*dzlon(m,n)
            heatshlon(3,m,n)=vcshlon(3,m,n)*dcshlon(3,m,n)*tcshlon(3,m,n)*dxe*dzlon(m,n)
        end do
    end do

    do m=0,depthlev,1
        do n=0,latnum-1,1
            ucshlat(0,m,n)=(us3(m,n)+us3(m+1,n)+us3(m,n+1)+us3(m+1,n+1))/4
            ucshlat(1,m,n)=(us4(m,n)+us4(m+1,n)+us4(m,n+1)+us4(m+1,n+1))/4
            ucshlat(2,m,n)=(uh3(m,n)+uh3(m+1,n)+uh3(m,n+1)+uh3(m+1,n+1))/4
            ucshlat(3,m,n)=(uh4(m,n)+uh4(m+1,n)+uh4(m,n+1)+uh4(m+1,n+1))/4
            dcshlat(0,m,n)=(ds3(m,n)+ds3(m+1,n)+ds3(m,n+1)+ds3(m+1,n+1))/4
            dcshlat(1,m,n)=(ds4(m,n)+ds4(m+1,n)+ds4(m,n+1)+ds4(m+1,n+1))/4
            dcshlat(2,m,n)=(dh3(m,n)+dh3(m+1,n)+dh3(m,n+1)+dh3(m+1,n+1))/4
            dcshlat(3,m,n)=(dh4(m,n)+dh4(m+1,n)+dh4(m,n+1)+dh4(m+1,n+1))/4
            tcshlat(0,m,n)=(ts3(m,n)+ts3(m+1,n)+ts3(m,n+1)+ts3(m+1,n+1))/4
            tcshlat(1,m,n)=(ts4(m,n)+ts4(m+1,n)+ts4(m,n+1)+ts4(m+1,n+1))/4
            tcshlat(2,m,n)=(th3(m,n)+th3(m+1,n)+th3(m,n+1)+th3(m+1,n+1))/4
            tcshlat(3,m,n)=(th4(m,n)+th4(m+1,n)+th4(m,n+1)+th4(m+1,n+1))/4
            colshlat(0,m,n)=ucshlat(0,m,n)*dy*dzlat(m,n); volume transported through the left line,ssp245
            colshlat(1,m,n)=ucshlat(1,m,n)*dy*dzlat(m,n); volume transported through the right line,ssp245
            colshlat(2,m,n)=ucshlat(2,m,n)*dy*dzlat(m,n); volume transported through the left line,historical
            colshlat(3,m,n)=ucshlat(3,m,n)*dy*dzlat(m,n); volume transported through the right line,hitorical
            heatshlat(0,m,n)=ucshlat(0,m,n)*dcshlat(0,m,n)*tcshlat(0,m,n)*dy*dzlat(m,n)
            heatshlat(1,m,n)=ucshlat(1,m,n)*dcshlat(1,m,n)*tcshlat(1,m,n)*dy*dzlat(m,n)
            heatshlat(2,m,n)=ucshlat(2,m,n)*dcshlat(2,m,n)*tcshlat(2,m,n)*dy*dzlat(m,n)
            heatshlat(3,m,n)=ucshlat(3,m,n)*dcshlat(3,m,n)*tcshlat(3,m,n)*dy*dzlat(m,n)
        end do
    end do

    coltrans=new(5,float,0)
    coltranh=new(5,float,0)
    coltrans(0)=sum(colshlat(0,:,:));dim_sum_n(colshlat, (/1,2/)0)
    coltrans(1)=sum(colshlon(0,:,:))
    coltrans(2)=sum(colshlat(1,:,:))
    coltrans(3)=sum(colshlon(1,:,:))
    coltrans(4)=sum(colshlat(0,:,:))+sum(colshlon(0,:,:))-sum(colshlat(1,:,:))-sum(colshlon(1,:,:))
    coltranh(0)=sum(colshlat(2,:,:))
    coltranh(1)=sum(colshlon(2,:,:))
    coltranh(2)=sum(colshlat(3,:,:))
    coltranh(3)=sum(colshlon(3,:,:))
    coltranh(4)=sum(colshlat(2,:,:))+sum(colshlon(2,:,:))-sum(colshlat(3,:,:))-sum(colshlon(3,:,:))
    
    heatrans=new(5,float,0)
    heatranh=new(5,float,0)
    heatrans(0)=sum(heatshlat(0,:,:));dim_sum_n(heatshlat, (/1,2/)0)
    heatrans(1)=sum(heatshlon(0,:,:))
    heatrans(2)=sum(heatshlat(1,:,:))
    heatrans(3)=sum(heatshlon(1,:,:))
    heatrans(4)=sum(heatshlat(0,:,:))+sum(heatshlon(0,:,:))-sum(heatshlat(1,:,:))-sum(heatshlon(1,:,:))
    heatranh(0)=sum(heatshlat(2,:,:))
    heatranh(1)=sum(heatshlon(2,:,:))
    heatranh(2)=sum(heatshlat(3,:,:))
    heatranh(3)=sum(heatshlon(3,:,:))
    heatranh(4)=sum(heatshlat(2,:,:))+sum(heatshlon(2,:,:))-sum(heatshlat(3,:,:))-sum(heatshlon(3,:,:))

;file output
    filename = "/mnt/e/CMIP6-data/transport-australia.txt"
    nalist= [/"volume-hist","volume-ssp245","heat-hist","heat-ssp245"/]
    slist = [/coltranh(0),coltrans(0),heatranh(0),heatrans(0)/]
    hlist = [/coltranh(1),coltrans(1),heatranh(1),heatrans(1)/]
    mlist = [/coltranh(2),coltrans(2),heatranh(2),heatrans(2)/]
    nlist = [/coltranh(3),coltrans(3),heatranh(3),heatrans(3)/]
    plist = [/coltranh(4),coltrans(4),heatranh(4),heatrans(4)/]
    write_table(filename, "w", nalist, "%s,%s,%s,%s")
    write_table(filename, "a", slist, "%10.2f,%10.2f,%10.2f,%10.2f")
    write_table(filename, "a", hlist, "%10.2f,%10.2f,%10.2f,%10.2f")
    write_table(filename, "a", mlist, "%10.2f,%10.2f,%10.2f,%10.2f")
    write_table(filename, "a", nlist, "%10.2f,%10.2f,%10.2f,%10.2f")
    write_table(filename, "a", plist, "%10.2f,%10.2f,%10.2f,%10.2f")
    ;print(coltrans)
    ;print(coltranh)
    ;print(heatrans)
    ;print(heatranh)
    exit



