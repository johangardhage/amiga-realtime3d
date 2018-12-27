*****************************************************************************************
*                                 Core_08.s                                             *
*                  Subroutines for euler_scn Chapter 12                                 *
*****************************************************************************************
 include core_07.s
* I've moved most of these subroutines to core_05.s; The switch that turns them on is   
* the EQU JOY4.

vtran_move
 lea iv,a0
 lea jv,a1
 lea kv,a2
 lea w_vmatx,a3
 move.w (a3)+,(a0)+
 move.w (a3)+,(a0)+
 move.w (a3)+,(a0)+
 move.w (a3)+,(a1)+
 move.w (a3)+,(a1)+
 move.w (a3)+,(a1)+
 move.w (a3)+,(a2)+
 move.w (a3)+,(a2)+
 move.w (a3),(a2)
 rts
 

