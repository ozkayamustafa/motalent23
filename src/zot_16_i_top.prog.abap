*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_TOP
*&---------------------------------------------------------------------*


TYPES: BEGIN OF gty_scarr,
         carrid    TYPE s_carr_id,
         carrname  TYPE s_carrname,
         currcode  TYPE s_currcode,
         url       TYPE s_carrurl,
         price     TYPE int4,
         iconn     TYPE icon_d,
         location  TYPE char20,
         cellstyle TYPE lvc_t_styl,
         delete    TYPE char10,
*         line_color TYPE char4,
*         cell_color TYPE lvc_t_scol,
       END OF gty_scarr.


DATA: gs_cellstyle TYPE lvc_s_styl.

DATA: go_alv       TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container.
*      go_alv2      TYPE REF TO cl_gui_alv_grid.


DATA: gt_scarr TYPE TABLE OF gty_scarr.


DATA: gt_field  TYPE lvc_t_fcat,
      gs_layout TYPE lvc_s_layo,
      gs_cell   TYPE lvc_s_scol.




DATA: go_splitter      TYPE REF TO cl_gui_splitter_container,
      go_guicontainer  TYPE REF TO cl_gui_container,
      go_guicontainer2 TYPE REF TO cl_gui_container.

*FIELD-SYMBOLS: <gs_data


DATA gv_docu TYPE REF TO cl_dd_document.

CLASS cl_event_handler DEFINITION DEFERRED.

DATA gv_handler TYPE REF TO cl_event_handler.
