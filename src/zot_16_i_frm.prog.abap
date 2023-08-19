*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv.

*  CREATE OBJECT go_container
*    EXPORTING
*      container_name              = 'GC_CONT'
*    EXCEPTIONS
*      cntl_error                  = 1                " CNTL_ERROR
*      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
*      create_error                = 3                " CREATE_ERROR
*      lifetime_error              = 4                " LIFETIME_ERROR
*      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
*      OTHERS                      = 6.
*  IF sy-subrc <> 0.
**   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.

  go_container = NEW cl_gui_custom_container( container_name = 'GC_CONT' ).

  IF go_alv IS INITIAL.


    CREATE OBJECT go_splitter
      EXPORTING
        parent            = go_container
        rows              = 2
        columns           = 1
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1                " Row
        column    = 1                " Column
      RECEIVING
        container = go_guicontainer.                " Yeni container veriyor

    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = go_guicontainer2.

    CALL METHOD go_splitter->set_row_height  " ROw yükseliğii ayarlıyor
      EXPORTING
        id     = 1                " Row ID
        height = 10.                 " Height


    CREATE OBJECT gv_docu
      EXPORTING
        style = 'ALV GRID'.



    CREATE OBJECT go_alv
      EXPORTING
        i_parent          = go_guicontainer2
      EXCEPTIONS
        error_cntl_create = 1                " Error when creating the control
        error_cntl_init   = 2                " Error While Initializing Control
        error_cntl_link   = 3                " Error While Linking Control
        error_dp_create   = 4                " Error While Creating DataProvider Control
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    SET HANDLER gv_handler->handler_top_of_page FOR go_alv.  " top_of_page assing etmek için
    SET HANDLER gv_handler->handler_hotspots_click FOR go_alv. " hotspot_click
    SET HANDLER gv_handler->handler_double_click FOR go_alv. " Double click
    SET HANDLER gv_handler->handler_data_changed FOR go_alv.  " datachanged
    SET HANDLER gv_handler->handler_onf4 FOR go_alv.
    SET HANDLER gv_handler->handler_button_click FOR go_alv.
    SET HANDLER gv_handler->handler_toolbar FOR go_alv.
    SET HANDLER gv_handler->handler_user_command FOR go_alv.

    PERFORM set_dropdown.
    PERFORM register_f4.

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
*       i_structure_name = 'SCARR'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_scarr
        it_fieldcatalog = gt_field.


    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


**********  ikinci alv bu splitter göstermek için ******
*     go_alv2 = new cl_gui_alv_grid( i_parent = go_guicontainer2 ).
*
*    CALL METHOD go_alv2->set_table_for_first_display(
*        EXPORTING
*          is_layout                     = gs_layout
*        CHANGING
*          it_outtab                     = gt_scarr
*          it_fieldcatalog               = gt_field
*           ).
*********************************************************************

    CALL METHOD go_alv->list_processing_events
      EXPORTING
        i_event_name = 'TOP_OF_PAGE'
        i_dyndoc_id  = gv_docu.


    CALL METHOD go_alv->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
    .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



  ELSE.
    CALL METHOD go_alv->refresh_table_display.

  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT * FROM scarr INTO CORRESPONDING FIELDS OF TABLE gt_scarr.

*    LOOP AT gt_scarr ASSIGNING FIELD-SYMBOL(<ls_data>).
*       CASE <ls_data>-currcode.
*          WHEN 'EUR'.
*              <ls_data>-line_color = 'C710'.
*              gs_cell-fname = 'URL'.
*              gs_cell-color-col = '4'.
*              gs_cell-color-int = '1'.
*              gs_cell-color-inv = '0'.
*              APPEND gs_cell TO <ls_data>-cell_color.
*      ENDCASE.
*      ENDLOOP.



********************* CELL STYLE ************************

  LOOP AT gt_scarr ASSIGNING FIELD-SYMBOL(<ls_data>).

    IF <ls_data>-currcode <> 'EUR'.
      gs_cellstyle-fieldname = 'URL'.
*        gs_cellstyle-style = cl_gui_alv_grid=>mc_style_disabled.
      gs_cellstyle-style = '00000006'.  " Yeşil rengi yaptı

      APPEND gs_cellstyle TO <ls_data>-cellstyle.
    ENDIF.

    <ls_data>-delete = '@11@'.

  ENDLOOP.




ENDFORM.

FORM sf_fieldcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZOT_16_S_SCARR'
    CHANGING
      ct_fieldcat            = gt_field
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT gt_field ASSIGNING FIELD-SYMBOL(<ls_field>).
    CASE <ls_field>-fieldname.
      WHEN 'CARRNAME'.
        <ls_field>-edit = abap_true.
        <ls_field>-f4availabl = abap_true.
      WHEN 'CARRID'.
        <ls_field>-hotspot = abap_true.
        <ls_field>-col_pos = 2.
      WHEN 'PRICE'.
        <ls_field>-edit = abap_true.
        <ls_field>-coltext = 'Fiyat'.
      WHEN 'ICONN'.
        <ls_field>-coltext = 'DURUM'.
        <ls_field>-col_pos = 1.
        <ls_field>-seltext = 'DURUM'.
      WHEN 'LOCATION'.
        <ls_field>-coltext = 'LOCATION'.
        <ls_field>-edit    = abap_true.
        <ls_field>-drdn_hndl = 2.
      WHEN 'URL'.
        <ls_field>-edit = abap_true.
      WHEN 'DELETE'.
        <ls_field>-coltext = 'SİL'.
        <ls_field>-col_pos = 0.
        <ls_field>-icon = abap_true.
        <ls_field>-style = cl_gui_alv_grid=>mc_style_button.

    ENDCASE.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form sf_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM sf_layout .
  CLEAR gs_layout.

*  gs_layout-cwidth_opt = abap_true.
*    gs_layout-info_fname = 'LINE_COLOR'.
*    gs_layout-ctab_fname = 'CELL_COLOR'.
*  gs_layout-stylefname = 'CELLSTYLE'.
*  gs_layout-zebra      = abap_true.

  gs_layout = VALUE #( cwidth_opt = abap_true
                       stylefname = 'CELLSTYLE' ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_sum
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_sum .

  DATA: lv_sum   TYPE int4,
        lv_lines TYPE int4,
        lv_avr   TYPE int4,
        ls_scarr TYPE gty_scarr.

  LOOP AT gt_scarr INTO ls_scarr.
    lv_sum = lv_sum + ls_scarr-price.
  ENDLOOP.

  DESCRIBE TABLE gt_scarr LINES lv_lines.

  lv_avr = lv_sum / lv_lines.


  LOOP AT gt_scarr ASSIGNING FIELD-SYMBOL(<ls_scarr>).
    IF lv_avr GT <ls_scarr>-price.
      <ls_scarr>-iconn = '@08@'.
    ELSEIF lv_avr LT <ls_scarr>-price.
      <ls_scarr>-iconn = '@0A@'.
    ELSE.
      <ls_scarr>-iconn = '@09@'.
    ENDIF.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_dropdown
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_dropdown .

  DATA: lt_drop TYPE lvc_t_drop,
        ls_drop TYPE lvc_s_drop.

  CLEAR ls_drop.
  ls_drop-handle = 2.
  ls_drop-value = 'Yurtiçi'.
  APPEND ls_drop TO lt_drop.

  CLEAR ls_drop.
  ls_drop-handle = 2.
  ls_drop-value = 'Yurtdışı'.
  APPEND ls_drop TO lt_drop.

  go_alv->set_drop_down_table(
    EXPORTING
      it_drop_down = lt_drop
  ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_f4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM register_f4 .

  DATA: lt_f4 TYPE lvc_t_f4,
        ls_f4 TYPE lvc_s_f4.

  ls_f4-fieldname = 'CARRNAME'.
  ls_f4-register = abap_true.
  APPEND ls_f4 TO lt_f4.

  CALL METHOD go_alv->register_f4_for_fields
    EXPORTING
      it_f4 = lt_f4.


ENDFORM.
