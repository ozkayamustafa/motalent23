*&---------------------------------------------------------------------*
*& Include          ZOT_16_TS_I_TOP
*&---------------------------------------------------------------------*

TABLES: vbrp.

*TYPES: BEGIN OF gty_tables,
*         vbeln  TYPE vbrk-vbeln,
*         bukrs  TYPE vbrk-bukrs,
*         fkdat  TYPE vbrk-fkdat,
*         fkart  TYPE  vbrk-fkart,
*         kunrg  TYPE  vbrk-kunrg,
*         fktyp  TYPE   vbrk-fktyp,
*         vkorg  TYPE   vbrk-vkorg,
*         vtweg  TYPE   vbrk-vtweg,
*         netwr  TYPE    vbrk-netwr,
*         waerk  TYPE   vbrk-waerk,
*         posnr  TYPE  vbrp-posnr,
*         fkimg  TYPE vbrp-fkimg,
*         vrkme  TYPE vbrp-vrkme,
*         meins  TYPE  vbrp-meins,
*         ntgew   TYPE  vbrp-ntgew,
*         brgew  TYPE vbrp-brgew,
*         matnr  TYPE  vbrp-matnr,
*         arktx  TYPE  vbrp-arktx,
*         net_price TYPE netpr,
*         net_price_edit TYPE netpr,
*  cellstyle TYPE lvc_t_styl,
*       END OF gty_tables.


 CLASS lcl_main_controller DEFINITION DEFERRED.
 DATA:
  "! Main controller global object
  go_main TYPE REF TO lcl_main_controller.


DATA: gs_cellstyle TYPE lvc_s_styl.

FIELD-SYMBOLS <gt_vbrk> TYPE STANDARD TABLE.
*FIELD-SYMBOLS <gt_vbrp> TYPE STANDARD TABLE.
