*****************************************************************************************
*                                       data_07.s                                       *
*                            Control matrices for rotation                              *
*****************************************************************************************
 include data_06.s
* +ve rotation about the view frame x axis (LEFT) by 5 degrees.
rot_x_pos dc.w 16384,0,0,0,16322,1428,0,-1428,16322

*-ve rotation about the xv axis (RIGHT)
rot_x_neg dc.w 16384,0,0,0,16322,-1428,0,1428,16322

*+ve rotation about the yv axis (UP)
rot_y_pos dc.w 16322,0,-1428,0,16384,0,1428,0,16322

*-ve rotation about the yv axis (DOWN)
rot_y_neg dc.w 16322,0,1428,0,16384,0,-1428,0,16322

*+ve rotation about the zv axis (ROLL RIGHT)
rot_z_pos dc.w 16322,1428,0,-1428,16322,0,0,0,16384

*+ve rotation about the zv axis (ROLL LEFT)
rot_z_neg dc.w 16322,-1428,0,1428,16322,0,0,0,16384

*****************************************************************************************
*                                       data_08.s                                       *
* The world map for chapter 10. Each byte gives the attribute of a size 256*256 tile in *
* a 16*16 tile world. The attributes' composition is thus:-                             *
* High Nibble : Background colour (1-7)                                                 *
* Low  Nibble : Primitive type (0-5)                                                    *
*****************************************************************************************
map_base
 dc.b $62,$62,$62,$50,$41,$35,$35,$35
 dc.b $35,$35,$35,$43,$45,$54,$54,$64
 dc.b $62,$62,$62,$55,$42,$33,$35,$35
 dc.b $35,$35,$32,$44,$45,$54,$54,$64 
 dc.b $52,$52,$52,$52,$44,$35,$34,$35 
 dc.b $35,$30,$35,$41,$44,$54,$54,$64 
 dc.b $45,$41,$42,$42,$42,$35,$22,$23 
 dc.b $23,$20,$25,$25,$44,$44,$40,$65 
 dc.b $33,$35,$30,$32,$32,$22,$25,$25 
 dc.b $25,$23,$24,$24,$35,$32,$35,$31 
 dc.b $35,$32,$35,$35,$32,$22,$11,$11 
 dc.b $10,$10,$24,$24,$33,$35,$32,$34 
 dc.b $20,$25,$25,$25,$20,$21,$13,$13 
 dc.b $13,$13,$20,$25,$25,$25,$20,$25 
 dc.b $24,$25,$25,$25,$21,$21,$13,$13 
 dc.b $13,$13,$20,$20,$25,$25,$20,$25
 dc.b $20,$25,$25,$25,$22,$22,$13,$13
 dc.b $13,$13,$14,$24,$25,$25,$22,$23 
 dc.b $25,$23,$25,$25,$23,$22,$13,$13 
 dc.b $13,$13,$14,$23,$25,$25,$25,$25 
 dc.b $31,$35,$30,$35,$31,$21,$22,$22 
 dc.b $20,$20,$20,$35,$35,$34,$20,$33 
 dc.b $45,$40,$40,$40,$41,$41,$22,$22 
 dc.b $22,$25,$30,$40,$40,$42,$45,$41 
 dc.b $40,$40,$41,$41,$44,$45,$30,$35 
 dc.b $35,$35,$32,$45,$40,$50,$55,$55 
 dc.b $61,$61,$61,$51,$53,$45,$35,$32 
 dc.b $35,$35,$31,$45,$40,$50,$60,$60 
 dc.b $61,$61,$61,$52,$55,$44,$33,$35 
 dc.b $33,$35,$30,$45,$40,$50,$60,$60 
 dc.b $61,$61,$61,$55,$51,$45,$30,$35 
 dc.b $32,$35,$35,$41,$45,$50,$60,$60
 
 
 
 
 
 
 
 
 
