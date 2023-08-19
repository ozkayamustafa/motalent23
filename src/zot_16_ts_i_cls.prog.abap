*&---------------------------------------------------------------------*
*& Include          ZOT_16_TS_I_CLS
*&---------------------------------------------------------------------*

CLASS lcl_main_controller DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS:
      "! Main controller get singleton object
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO lcl_main_controller.

    METHODS:
      init0100,
      get_data,
      get_reflesh,
      get_save.

  PRIVATE SECTION.
    CLASS-DATA:
      "! Singleton object
      mo_instance           TYPE REF TO lcl_main_controller,
      mt_list               TYPE TABLE OF zot_16_s_vbrp,
      mt_list_vbrp          TYPE TABLE OF zot_16_s_vbrp,
      mo_custom_container   TYPE REF TO cl_gui_custom_container,
      mo_main_grid          TYPE REF TO cl_gui_alv_grid,
      mo_main_grid_2        TYPE REF TO cl_gui_alv_grid,
      mo_main_splitter      TYPE REF TO cl_gui_splitter_container,
      mo_main_container_one TYPE REF TO cl_gui_container,
      mo_main_container_two TYPE REF TO cl_gui_container.

    METHODS:
      fiil_main_fieldcat RETURNING VALUE(ro_fcat) TYPE lvc_t_fcat,
      fiil_vrbp_fieldcat RETURNING VALUE(rt_fcat) TYPE lvc_t_fcat,
      fill_main_layo   RETURNING VALUE(rs_layo) TYPE lvc_s_layo,
      set_handlers,
      set_edit_event.


    METHODS handler_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
        e_row
        e_column
        es_row_no.

    METHODS handler_toolbar
      FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        e_object
        e_interactive.

    METHODS handler_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        e_ucomm.




ENDCLASS.


CLASS lcl_main_controller IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      mo_instance = NEW #( ).
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.



  METHOD init0100.

    mo_custom_container = NEW cl_gui_custom_container( container_name = 'GC_MAIN' ).
    mo_main_splitter = NEW cl_gui_splitter_container( rows = 2 columns = 1 parent = mo_custom_container ).
    CALL METHOD mo_main_splitter->get_container
      EXPORTING
        row       = 1                " Row
        column    = 1                 " Column
      RECEIVING
        container = mo_main_container_one.
    " Container
    CALL METHOD mo_main_splitter->get_container
      EXPORTING
        row       = 2                " Row
        column    = 1                 " Column
      RECEIVING
        container = mo_main_container_two.                 " Container

    IF mo_main_grid IS INITIAL.

      mo_main_grid = NEW cl_gui_alv_grid( i_parent = mo_main_container_one ).
      mo_main_grid_2 = NEW cl_gui_alv_grid( i_parent = mo_main_container_two ).

      me->set_handlers( ).
      me->set_edit_event( ).

      ASSIGN me->mt_list TO <gt_vbrk>.
*        ASSIGN me->mv_list TO <gt_vbrp>.
      DATA(lt_fieldcat) = me->fiil_main_fieldcat( ).
      DATA(lt_vrbp_fieldcat) = me->fiil_vrbp_fieldcat( ).

      CALL METHOD mo_main_grid->set_table_for_first_display  "Fatura bilgi
        EXPORTING
*         is_variant                    =
*         i_save                        =
*         i_default                     = 'X'
          is_layout                     = me->fill_main_layo( )
        CHANGING
          it_outtab                     = <gt_vbrk>
          it_fieldcatalog               = lt_fieldcat
*         it_sort                       =
*         it_filter                     =
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.



      CALL METHOD mo_main_grid_2->set_table_for_first_display " Kalem bilgi
        EXPORTING
*         is_variant                    =
*         i_save                        =
*         i_default                     = 'X'
          is_layout                     = me->fill_main_layo( )
        CHANGING
          it_outtab                     = me->mt_list_vbrp                " Output Table
          it_fieldcatalog               = lt_vrbp_fieldcat                 " Field Catalog
*         it_sort                       =                  " Sort Criteria
*         it_filter                     =                  " Filter Criteria
        EXCEPTIONS
          invalid_parameter_combination = 1                " Wrong Parameter
          program_error                 = 2                " Program Errors
          too_many_lines                = 3                " Too many Rows in Ready for Input Grid
          OTHERS                        = 4.
      IF sy-subrc <> 0.
*         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.


    ELSE.
      me->get_reflesh( ).
    ENDIF.

  ENDMETHOD.

  METHOD get_data.
    DATA lv_price TYPE netpr.


    SELECT
      vbrp~vbeln,
      vbrp~posnr,
      vbrp~fkimg,
      vbrp~vrkme,
      vbrp~meins,
      vbrp~waerk,
      vbrp~ntgew,
      vbrp~brgew,
      vbrp~netwr,
      vbrp~matnr,
      vbrp~arktx
       FROM vbrk INNER JOIN vbrp ON vbrk~vbeln = vbrp~vbeln
          WHERE vbrk~vbeln IN @s_no
                AND vbrk~fkdat IN @s_date
                AND vbrk~fkart IN @s_type
                AND vbrk~kunrg IN @s_pay INTO CORRESPONDING FIELDS OF TABLE @mt_list.



    LOOP AT mt_list ASSIGNING FIELD-SYMBOL(<ls_data>).

      lv_price = <ls_data>-netwr / <ls_data>-fkimg.
      <ls_data>-net_price = lv_price.
      IF <ls_data>-net_price < 100.
        gs_cellstyle-fieldname = 'NET_PRICE_EDIT'.
        gs_cellstyle-style = cl_gui_alv_grid=>mc_style_disabled.
        APPEND gs_cellstyle TO <ls_data>-cellstyle.
      ENDIF.



      CLEAR lv_price.
    ENDLOOP.



  ENDMETHOD.

  METHOD fiil_main_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZOT_16_S_VBRK'
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = ro_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD fiil_vrbp_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZOT_16_S_VBRP'
        i_bypassing_buffer     = abap_true
      CHANGING
        ct_fieldcat            = rt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    LOOP AT rt_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
      CASE <lfs_fcat>-fieldname.
        WHEN 'NET_PRICE'.
          <lfs_fcat>-coltext = 'Net Fiyat'.
        WHEN 'NET_PRICE_EDIT' .
          <lfs_fcat>-coltext = 'Net Fiyat Güncel'.
          <lfs_fcat>-edit = abap_true.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.


  ENDMETHOD.


  METHOD  fill_main_layo.
    rs_layo = VALUE lvc_s_layo( cwidth_opt = abap_true stylefname = 'CELLSTYLE' ).
  ENDMETHOD.

  METHOD get_reflesh.
    CALL METHOD mo_main_grid->refresh_table_display.
    CALL METHOD mo_main_grid_2->refresh_table_display.
  ENDMETHOD.


  METHOD get_save.



  ENDMETHOD.




**********************************************************************" EVENTS


  METHOD handler_double_click.
    DATA: mt_list_buffer  TYPE TABLE OF zot_16_s_vbrp.

    READ TABLE me->mt_list INTO DATA(ls_read) INDEX e_row-index.
    IF sy-subrc EQ 0.
      CLEAR me->mt_list_vbrp.
      LOOP AT me->mt_list INTO DATA(ls_data) WHERE vbeln = ls_read-vbeln.
        APPEND ls_data TO me->mt_list_vbrp.
        me->get_reflesh( ).
        CLEAR ls_data.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.

  METHOD handler_toolbar.
    DATA: lt_log TYPE TABLE OF zot_16_t_log,
          ls_log TYPE zot_16_t_log.

    FIELD-SYMBOLS <lfs_data> TYPE zot_16_t_log.




    DATA: lt_rows   TYPE lvc_t_row,
          lt_row_no TYPE lvc_t_roid.

    CALL METHOD mo_main_grid_2->get_selected_rows
      IMPORTING
        et_index_rows = lt_rows
        et_row_no     = lt_row_no.

    LOOP AT lt_row_no INTO DATA(ls_row).

      READ TABLE me->mt_list INTO DATA(ls_re) INDEX ls_row-row_id.
      IF sy-subrc EQ 0.
*        ls_log-vbeln = ls_re-vbeln.
*        ls_log-posnr = ls_re-posnr.
*        ls_log-i_date = sy-datum.
*        ls_log-i_hour = sy-uzeit.
*        ls_log-net_price = ls_re-net_price.
*        ls_log-net_price_edit = ls_re-net_price_edit.
*        APPEND ls_log TO lt_log.

        <lfs_data>-vbeln = ls_re-vbeln.
        <lfs_data>-posnr = ls_re-posnr.
        <lfs_data>-i_date = sy-datum.
        <lfs_data>-i_hour = sy-uzeit.
        <lfs_data>-net_price = ls_re-net_price.
        <lfs_data>-net_price_edit = ls_re-net_price_edit.
      ENDIF.
      CLEAR <lfs_data>.
    ENDLOOP.
*cl_demo_output=>display( lt_log ) .
*      INSERT zot_16_t_log FROM TABLE lt_log.
*    IF lt_log is NOT INITIAL.
*        MODIFY zot_16_t_log FROM TABLE lt_log.
*        MESSAGE 'EKLENDİ' TYPE 'I'.
*    ENDIF.
  ENDMETHOD.
  METHOD handler_user_command.
  ENDMETHOD.


  METHOD set_handlers.
    SET HANDLER me->handler_double_click FOR mo_main_grid.

  ENDMETHOD.

  METHOD set_edit_event.
    CALL METHOD mo_main_grid_2->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1                " Error
        OTHERS     = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
