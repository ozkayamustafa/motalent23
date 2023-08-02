*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_TOP
*&---------------------------------------------------------------------*


TYPES: BEGIN OF gty_scarr,
         carrid     TYPE s_carr_id,
         carrname   TYPE s_carrname,
         currcode   TYPE s_currcode,
         url        TYPE s_carrurl,
         line_color TYPE char4,
         cell_color TYPE lvc_t_scol,
       END OF gty_scarr.




DATA: go_alv       TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container.


DATA: gt_scarr TYPE TABLE OF gty_scarr.

DATA: gt_field  TYPE lvc_t_fcat,
      gs_layout TYPE lvc_s_layo,
      gs_cell    TYPE lvc_s_scol.


*FIELD-SYMBOLS: <gs_data
