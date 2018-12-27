******************************************************************************************
* BSS_02.s
******************************************************************************************
 include bss_01.s
 
scoordsx ds.w 100 xcoords
scoordsy ds.w 100 ycoords
sedglst ds.w 100 edge connections
snedges ds.w 20 number of edges in each polygon
npoly ds.w 1 number of polygons in this object
col_lst ds.w 20 colours

vcoordsx ds.w 100 viewframe xcoords
vcoordsy ds.w 100
vcoordsz ds.w 100
vncoords ds.w 1

