*****************************************************************************************
*                                System_01.s                                            *
*****************************************************************************************
init_vars
* Set up the view point
 move.w #100,oposx
 clr.w oposy
 clr.w oposz 
* and the clip frame
 move.w #50,clp_xmin
 move.w #270,clp_xmax
 move.w #30,clp_ymin
 move.w #170,clp_ymax
*1. iv
 lea    iv,a0 								align view frame axes
 move.w #$4000,(a0)+
 move.w #0,(a0)+
 move.w #0,(a0)
*2. jv
 lea   jv,a0                  with the world frame
 clr.w (a0)+
 move.w #$4000,(a0)+
 clr.w (a0)
*3.kv
 lea    kv,a0
 move.w #0,(a0)+
 clr.w (a0)+
 move.w #$4000,(a0)

flg_init 
 clr.w speed                  start at rest
 clr.w viewflag
* Move the view point to -300 on the view frame z axis
 lea   persmatx,a0
 move.w #300,d0
 move.w d0,(a0)
 move.w d0,10(a0)
 move.w d0,30(a0)
 rts
 
 
    