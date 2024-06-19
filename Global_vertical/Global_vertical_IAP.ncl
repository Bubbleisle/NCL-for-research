;read in ts and th
f1=addfile("/mnt/f/IAP/IAP-1961-1980.nc","r")
f2=addfile("/mnt/f/IAP/IAP-2001-2020.nc","r")
area=asciiread("/mnt/e/CMIP6-data/area-file/IAPs.txt", 360, "float")
th=f1->temp(0,:,:,:)
ts=f2->temp(0,:,:,:)

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


thv=new((/41/),float,th@_FillValue)
tsv=new((/41/),float,th@_FillValue)
;计算总深度只需要把下面一个循环给注释掉，修改filename即可，同样1000m以浅的深度就需要计算下面的循环，注意filename是否修改

do m = 0,359,1
    do n = 0,719,1
        if .not.ismissing(th(m,n,32)) then
            th(m,n,0:40)=th@_FillValue
            ts(m,n,0:40)=ts@_FillValue
        end if 
    end do
end do
;/
do i = 0,40
    thv(i)=wgt_areaave(th(:,:,i), area, 1, 0)
    tsv(i)=wgt_areaave(ts(:,:,i), area, 1, 0)
end do 

filename = "/mnt/e/CMIP6-data/Vertical-IAP-1000m.txt"
slist = [/thv,tsv/]
write_table(filename, "w", slist, "%8.3f,%8.3f")