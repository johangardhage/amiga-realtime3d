*****************************************************************************************
*                                     bss_06.s                                          *
*****************************************************************************************
 include bss_05.s

* VARIABLES FOR ROTATING THE VIEW FRAME
iv       ds.w 3 view frame base vector components in world
jv       ds.w 3
kv       ds.w 3
vxangle  ds.w 1 rotation angles about these axes
vyangle  ds.w 1
vzangle  ds.w 1
vrot_matx ds.w 9 rotation matrix about an arbitrary axis
* VISIBILTY
viewflag ds.w 1
Vox      ds.w 1 object centre in view frame
Voy      ds.w 1
Voz      ds.w 1
 