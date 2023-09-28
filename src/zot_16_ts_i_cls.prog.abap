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
      get_reflesh.
    DATA
        gv_num TYPE i.

  PRIVATE SECTION.
    DATA:
      mt_list      TYPE TABLE OF zot_16_s_vbrp,
      mt_list_vbrp TYPE TABLE OF zot_16_s_vbrp.

    CLASS-DATA:
      "! Singleton object
      mo_instance           TYPE REF TO lcl_main_controller,

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
      set_edit_event,
      set_sas_create.

    METHODS handler_hostspot_click
      FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        e_row_id
        e_column_id
        es_row_no.

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

    METHODS handler_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING
        er_data_changed
        e_onf4_before
        e_onf4_after
        e_ucomm
        e_onf4.

    METHODS handler_button_click
      FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING
        es_row_no
        es_col_id.



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
        container = mo_main_container_two.


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
          it_outtab                     = me->mt_list
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
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      CALL METHOD mo_main_grid->refresh_table_display.
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

      <ls_data>-log_durum = '@96@'.
      lv_price = <ls_data>-netwr / <ls_data>-fkimg.
      <ls_data>-net_price = lv_price.

      IF <ls_data>-net_price < 100.
        gs_cellstyle-fieldname = 'NET_PRICE_EDIT'.
        gs_cellstyle-style = cl_gui_alv_grid=>mc_style_disabled.
        APPEND gs_cellstyle TO <ls_data>-cellstyle. CLEAR gs_cellstyle.
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

    LOOP AT ro_fcat ASSIGNING FIELD-SYMBOL(<lfs_fcat>).
      CASE <lfs_fcat>-fieldname.
        WHEN 'VBELN'.
          <lfs_fcat>-hotspot = abap_true.
          <lfs_fcat>-key = abap_true.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.


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
        WHEN 'LOG_DURUM' .
          <lfs_fcat>-coltext = 'Log Görüntüle'.
          <lfs_fcat>-style = cl_gui_alv_grid=>mc_style_button.
          <lfs_fcat>-icon  = abap_true.
        WHEN 'VBELN'.
          <lfs_fcat>-hotspot = abap_true.
          <lfs_fcat>-key = abap_true.
        WHEN 'EBELN'.
          <lfs_fcat>-hotspot = abap_true.
          <lfs_fcat>-coltext = 'EBELN'.

        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.


  ENDMETHOD.


  METHOD  fill_main_layo.
    rs_layo = VALUE lvc_s_layo( cwidth_opt = abap_true stylefname = 'CELLSTYLE' ).
  ENDMETHOD.

  METHOD get_reflesh.
*    CALL METHOD mo_main_grid->refresh_table_display.
    CALL METHOD mo_main_grid_2->refresh_table_display.

  ENDMETHOD.



**********************************************************************" EVENTS


  METHOD handler_double_click.
*    CLEAR me->mt_list_vbrp.
    IF me->mt_list_vbrp IS NOT INITIAL.
      LOOP AT me->mt_list_vbrp INTO DATA(ls_list_vbrp).
        DELETE me->mt_list_vbrp WHERE vbeln = ls_list_vbrp-vbeln.
      ENDLOOP.
    ENDIF.

    me->get_data( ).

    SELECT
      vbeln,
      posnr,
      net_price_edit FROM zot_16_t_log INTO TABLE @DATA(mt_list_vbrp_buffer).  " NEt güncel fiyatı çekiyorum

    READ TABLE me->mt_list ASSIGNING FIELD-SYMBOL(<ls_read>) INDEX es_row_no-row_id.

    IF sy-subrc EQ 0.

      LOOP AT me->mt_list ASSIGNING FIELD-SYMBOL(<ls_data>) WHERE vbeln = <ls_read>-vbeln.

        READ TABLE mt_list_vbrp_buffer INTO DATA(ls_vbrp_read) WITH KEY vbeln = <ls_data>-vbeln  " Tablodaykiyle aynı olanları alıyorum
                                                                         posnr = <ls_data>-posnr.
        IF sy-subrc EQ 0.
          <ls_data>-net_price_edit = ls_vbrp_read-net_price_edit.
          IF <ls_data>-net_price_edit <> 0.
            gs_cellstyle-fieldname = 'NET_PRICE_EDIT'.
            gs_cellstyle-style = '00000087'.
            APPEND gs_cellstyle TO <ls_data>-cellstyle. CLEAR gs_cellstyle.
          ENDIF.
        ENDIF.
        IF <ls_data>-vbeln IS NOT INITIAL.
          APPEND <ls_data> TO me->mt_list_vbrp.
        ENDIF.
        CLEAR <ls_data>.
      ENDLOOP.
    ENDIF.
    me->get_reflesh( ).

  ENDMETHOD.

  METHOD handler_toolbar.
    DATA: ls_btn_save TYPE stb_button.

    ls_btn_save-function = 'SAVE'.
    ls_btn_save-icon = '@2L@'.
    ls_btn_save-quickinfo = 'Kaydetme'.
    APPEND ls_btn_save TO e_object->mt_toolbar. CLEAR ls_btn_save.

    ls_btn_save-function = 'SAS'.
    ls_btn_save-icon = '@0Y@'.
    ls_btn_save-quickinfo = 'SAS Oluşturma'.
    ls_btn_save-text = 'SAS Oluşturma'.
    APPEND ls_btn_save TO e_object->mt_toolbar.CLEAR ls_btn_save.
  ENDMETHOD.
  METHOD handler_user_command.

    CASE e_ucomm.
      WHEN 'SAVE'.
        DATA: lt_log TYPE STANDARD TABLE OF zot_16_t_log,
              ls_log TYPE zot_16_t_log.


        CLEAR lt_log.
        DATA: lt_rows   TYPE lvc_t_row,
              lt_row_no TYPE lvc_t_roid.

        CALL METHOD mo_main_grid_2->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows
            et_row_no     = lt_row_no.


        LOOP AT lt_row_no INTO DATA(ls_row).
          READ TABLE me->mt_list_vbrp INTO DATA(ls_re) INDEX ls_row-row_id.
          IF sy-subrc EQ 0.
            ls_log-vbeln = ls_re-vbeln.
            ls_log-posnr = ls_re-posnr.
            ls_log-i_date = sy-datum.
            ls_log-i_hour = sy-uzeit.
            ls_log-net_price = ls_re-net_price.
            ls_log-net_price_edit = ls_re-net_price_edit.
            APPEND ls_log TO lt_log.

          ENDIF.
          CLEAR ls_log.
        ENDLOOP.

        MODIFY  zot_16_t_log FROM TABLE lt_log.
        COMMIT WORK AND WAIT.
        MESSAGE 'EKLENDİ' TYPE 'I'.


      WHEN 'SAS'.
        set_sas_create( ).

    ENDCASE.


  ENDMETHOD.


  METHOD handler_data_changed.

  ENDMETHOD.

  METHOD handler_button_click.

    DATA: lv_txt1 TYPE string,
          lv_txt2 TYPE string,
          lv_txt3 TYPE string,
          lv_txt4 TYPE string.

    READ TABLE me->mt_list_vbrp INTO DATA(ls_vbrp_read) INDEX es_row_no-row_id.
    IF sy-subrc EQ 0.

      DATA(lv_text3_buffer) = CONV string( ls_vbrp_read-net_price ).
      DATA(lv_text4_buffer) = CONV string( ls_vbrp_read-net_price_edit ).

      CONCATENATE 'Fatura bilgisi: ' ls_vbrp_read-vbeln INTO lv_txt1 SEPARATED BY space.
      CONCATENATE 'Kalem bilgisi: ' ls_vbrp_read-posnr INTO lv_txt2 SEPARATED BY space.
      CONCATENATE 'Net Fiyat bilgisi: ' lv_text3_buffer  INTO lv_txt3 SEPARATED BY space.
      CONCATENATE 'Net Fiyat Güncel  bilgisi: ' lv_text4_buffer INTO lv_txt4 SEPARATED BY space.


      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel = 'Fatura ve Kalem Bilgileri'
          txt1  = lv_txt1
          txt2  = lv_txt2
          txt3  = lv_txt3
          txt4  = lv_txt4.
    ENDIF.

  ENDMETHOD.

  METHOD handler_hostspot_click.
    IF e_column_id-fieldname eq 'VBELN'.
    READ TABLE mt_list INTO DATA(ls_bills_read) INDEX e_row_id-index.
    SET PARAMETER ID 'VBL' FIELD ls_bills_read-vbeln.
    CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    ELSEIF e_column_id-fieldname eq 'EBELN'.
    READ TABLE mt_list_vbrp INTO DATA(ls_item_read) INDEX e_row_id-index.
    SET PARAMETER ID 'EBL' FIELD ls_item_read-ebeln.
    CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
    ENDIF.

  ENDMETHOD.

  METHOD set_sas_create.

    DATA:
      lt_tab   TYPE esp1_message_tab_type,
      ls_tab   TYPE esp1_message_wa_type,
      lv_numup TYPE int4.  "Count yapılıyor


    DATA: lt_fields      TYPE TABLE OF sval,
          ls_fields      TYPE sval,
          lv_ret         TYPE string,
          lv_error       TYPE string,
          lv_warning     TYPE string,
          lv_count       TYPE int4 VALUE 0,
          ls_poheader    TYPE bapimepoheader,
          ls_poheaderx   TYPE  bapimepoheaderx,
          ls_poitem      TYPE bapimepoitem,
          lt_poitem      TYPE TABLE OF bapimepoitem,
          ls_poitemx     TYPE bapimepoitemx,
          lt_poitemx     TYPE TABLE OF bapimepoitemx,
          ls_poaccount   TYPE bapimepoaccount,
          lt_poaccount   TYPE TABLE OF bapimepoaccount,
          ls_poaccountx  TYPE bapimepoaccountx,
          lt_poaccountx  TYPE TABLE OF bapimepoaccountx,
          lt_bapi_return TYPE TABLE OF bapiret2,
          ls_ponumber    TYPE bapimepoheader-po_number,
          lv_return      TYPE bapiret2.

    DATA: lt_rows   TYPE lvc_t_row,
          lt_row_no TYPE lvc_t_roid.

    DATA: lt_kunag TYPE TABLE OF vbrk,
          lt_matkl TYPE TABLE OF vbrp.

    ls_fields-tabname = 'EKKO'.
    ls_fields-fieldname = 'EKORG'.
    ls_fields-field_obl = abap_true.
    APPEND ls_fields TO lt_fields.
    CLEAR ls_fields.

    ls_fields-tabname = 'EKKO'.
    ls_fields-fieldname = 'EKGRP'.
    ls_fields-field_obl = abap_true.
    APPEND ls_fields TO lt_fields.
    CLEAR ls_fields.

    ls_fields-tabname = 'VBRP'.
    ls_fields-fieldname = 'WERKS'.
    ls_fields-field_obl = abap_true.
    APPEND ls_fields TO lt_fields.
    CLEAR ls_fields.

    ls_fields-tabname = 'VBRP'.
    ls_fields-fieldname = 'LGORT'.
    ls_fields-field_obl = abap_true.
    APPEND ls_fields TO lt_fields.
    CLEAR ls_fields.

    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
*       no_value_check  = space            " Deactivates data type check
        popup_title  = 'SAS Oluştur'               " Text of title line
        start_column = '5'              " Start column of the dialog box
        start_row    = '5'              " Start line of the dialog box
      IMPORTING
        returncode   = lv_ret                " User response
      TABLES
        fields       = lt_fields                " Table fields, values and attributes
*         EXCEPTIONS
*       error_in_fields = 1                " FIELDS were transferred incorrectly
*       others       = 2
      .
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF lv_ret EQ ' '.

      READ TABLE lt_fields INTO DATA(ls_read_EKORG) WITH KEY fieldname = 'EKORG'.
      READ TABLE lt_fields INTO DATA(ls_read_EKGRP) WITH KEY fieldname = 'EKGRP'.
      READ TABLE lt_fields INTO DATA(ls_read_WERKS) WITH KEY fieldname = 'WERKS'.
      CALL METHOD mo_main_grid_2->get_selected_rows
        IMPORTING
          et_index_rows = lt_rows
          et_row_no     = lt_row_no.


      SELECT
          kunag,
          waerk
           FROM vbrk INTO CORRESPONDING FIELDS OF TABLE @lt_kunag.
      SELECT matkl FROM vbrp INTO CORRESPONDING FIELDS OF TABLE @lt_matkl.

      LOOP AT lt_row_no INTO DATA(ls_row).
        READ TABLE me->mt_list_vbrp INTO DATA(ls_read_row) INDEX ls_row-row_id.
        IF sy-subrc EQ 0.
          READ TABLE lt_kunag INTO DATA(ls_read_vbrk) WITH KEY vbeln = ls_read_row-vbeln.
          READ TABLE lt_matkl INTO DATA(ls_read_vbrp) WITH KEY vbeln = ls_read_row-vbeln.

          CLEAR ls_poheader.
          ls_poheader-comp_code = ls_read_vbrk-kunag.
          ls_poheader-doc_type = 'NB'.
          ls_poheader-purch_org = ls_read_ekorg-value.
          ls_poheader-pur_group = ls_read_ekgrp-value.
          ls_poheader-langu = sy-langu.

          CLEAR ls_poheaderx.
          ls_poheaderx-comp_code = 'X'.
          ls_poheaderx-doc_type = 'X'.
          ls_poheaderx-purch_org = 'X'.
          ls_poheaderx-pur_group = 'X'.
          ls_poheaderx-langu = 'X'.


          lv_count += 10.
          CLEAR ls_poitem.
          ls_poitem-po_item = '00010'.
          ls_poitem-plant   = ls_read_werks-value.
*          ls_poitem-stge_loc = ls_read_werks-value.
          ls_poitem-material = ls_read_row-matnr.
          ls_poitem-short_text = ls_read_row-arktx.
          ls_poitem-quantity = ls_read_row-fkimg.
          ls_poitem-po_unit = ls_read_row-vrkme.
          ls_poitem-matl_group = ls_read_vbrp-matkl.
          ls_poitem-info_upd = 'X'.
          ls_poitem-pckg_no  = '0000000001'.

          CLEAR ls_poitemx.
          ls_poitemx-po_item = '00010'.
          ls_poitemx-po_itemx = 'X'.
          ls_poitemx-plant = 'X'.
          ls_poitemx-info_upd = 'X'.
          ls_poitemx-pckg_no = 'X'.
          ls_poitemx-matl_group = 'X'.
*          ls_poitemx-stge_loc = 'X'.
          ls_poitemx-quantity = 'X'.
          ls_poitemx-short_text = 'X'.
          ls_poitemx-material = 'X'.
          ls_poitemx-po_unit = 'X'.


          CLEAR ls_poaccount.
          ls_poaccount-po_item = '00010'.
          ls_poaccount-serial_no = '01'.

          CLEAR ls_poaccountx.
          ls_poaccountx-po_item = '00010'.
          ls_poaccountx-po_itemx = 'X'.
          ls_poaccountx-serial_no = 'X'.



          APPEND ls_poitem TO lt_poitem.
          APPEND ls_poitemx TO lt_poitemx.
          APPEND ls_poaccount TO lt_poaccount.
          APPEND ls_poaccountx TO lt_poaccountx.
        ENDIF.

      ENDLOOP.



      CALL FUNCTION 'BAPI_PO_CREATE1'
        EXPORTING
          poheader         = ls_poheader
          poheaderx        = ls_poheaderx
        IMPORTING
          exppurchaseorder = ls_ponumber
        TABLES
          return           = lt_bapi_return
          poitem           = lt_poitem
          poitemx          = lt_poitemx
          poaccount        = lt_poaccount
          poaccountx       = lt_poaccountx.

*      LOOP AT lt_bapi_return TRANSPORTING NO FIELDS WHERE type CA 'EAX'.
*        EXIT.
*      ENDLOOP.
      LOOP AT lt_bapi_return INTO DATA(ls_bapi_return).
        lv_numup += 1.
        IF ls_bapi_return-type EQ 'E'.
          ls_tab-msgid  = ls_bapi_return-number.
          ls_tab-msgno  = ls_bapi_return-log_msg_no.
          ls_tab-msgty  = 'E'.
          ls_tab-msgv1  = ls_bapi_return-message.
          ls_tab-lineno = lv_numup.
          APPEND ls_tab TO lt_tab. CLEAR ls_tab.
        ELSEIF ls_bapi_return-type EQ 'W'.
          ls_tab-msgid  = ls_bapi_return-number.
          ls_tab-msgno  = ls_bapi_return-log_msg_no.
          ls_tab-msgty  = 'W'.
          ls_tab-msgv1  = ls_bapi_return-message.
          ls_tab-lineno = lv_numup.
          APPEND ls_tab TO lt_tab.CLEAR ls_tab.

        ENDIF.
      ENDLOOP.

      CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
        TABLES
          i_message_tab = lt_tab.                 " Additional Messages

      LOOP AT lt_row_no INTO DATA(ls_row_data).
        READ TABLE me->mt_list_vbrp ASSIGNING FIELD-SYMBOL(<lfs_list_data>) INDEX ls_row_data-row_id.
        IF sy-subrc EQ 0.
          <lfs_list_data>-ebeln = '1234567'.
        ENDIF.
      ENDLOOP.


      IF sy-subrc NE 0.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

      ELSE.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
          IMPORTING
            return = lv_return.

      ENDIF.


      me->get_reflesh( ).




    ENDIF.


  ENDMETHOD.



  METHOD set_handlers.
    SET HANDLER me->handler_double_click FOR mo_main_grid.
    SET HANDLER me->handler_toolbar FOR mo_main_grid_2.
    SET HANDLER me->handler_user_command FOR mo_main_grid_2.
    SET HANDLER me->handler_data_changed FOR mo_main_grid.
    SET HANDLER me->handler_button_click FOR mo_main_grid_2.
    SET HANDLER me->handler_hostspot_click FOR mo_main_grid.
    SET HANDLER me->handler_hostspot_click FOR mo_main_grid_2.
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
