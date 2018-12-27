*****************************************************************************************
*                                        bss_07.s                                       *
*                                variables for chapter 10                               *
*****************************************************************************************
 include bss_06.s
* Observer's position in world.(mod 4096)
oposx ds.w 1
oposy ds.w 1
oposz ds.w 1
* Tile offset in 16*16 patch
Ty ds.w 1
Tz ds.w 1
* Tile lists
patch_lst ds.l   32 records of 16 tiles in patch
vis_lst   ds.l   32 records of visible tiles
* List variables
vis_cnt ds.w 1   number of visible tiles
srt_flg ds.w 1   set during depth sorting 
