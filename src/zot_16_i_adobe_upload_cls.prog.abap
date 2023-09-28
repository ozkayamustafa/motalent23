*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_ADOBE_UPLOAD_CLS
*&---------------------------------------------------------------------*

CLASS lcl_main_adobe DEFINITION.

  PUBLIC SECTION.
    DATA: lv_bmp TYPE xstring,
          g_logo TYPE xstring.

    CLASS-METHODS:
      get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_main_adobe.


    METHODS:
      init0100,
      get_data,
      file_open_dialog,
      excel_alv,
      ticket_wrıte,
      select_logo.

  PRIVATE SECTION.

    CLASS-DATA:
      mo_instance         TYPE REF TO lcl_main_adobe,
      mt_data             TYPE STANDARD TABLE OF zot_16_s_deliver,
      mt_select_data      TYPE STANDARD TABLE OF zot_16_s_deliver,
      mo_main_alv         TYPE REF TO cl_gui_alv_grid,
      mo_custom_container TYPE REF TO cl_gui_custom_container,
      mt_file             TYPE filetable,
      mv_subrc            TYPE i,
      mt_e_itab	          TYPE STANDARD TABLE OF t_datatab,
      ms_excel_data       TYPE t_datatab,
      mt_row_no           TYPE lvc_t_roid.


    METHODS:
      fill_main_fcat
        RETURNING VALUE(ro_fcat) TYPE lvc_t_fcat,
      fill_main_layo
        RETURNING VALUE(ro_layo) TYPE lvc_s_layo.


    METHODS handler_toolbar
      FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        e_interactive
        e_object.

    METHODS handler_user_command
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        e_ucomm.


ENDCLASS.


CLASS lcl_main_adobe IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      mo_instance = NEW #( ).
    ENDIF.
    ro_instance =  mo_instance.
  ENDMETHOD.

  METHOD fill_main_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZOT_16_S_DELIVER'
      CHANGING
        ct_fieldcat            = ro_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
*      Implement suitable error handling here
    ENDIF.


  ENDMETHOD.

  METHOD init0100.
    mo_custom_container = NEW cl_gui_custom_container( container_name = 'CC_MAIN'  ).
    mo_main_alv = NEW cl_gui_alv_grid( i_parent = mo_custom_container ).

    DATA(lt_fcat) = me->fill_main_fcat( ).


    SET HANDLER me->handler_toolbar FOR mo_main_alv.
    SET HANDLER me->handler_user_command FOR mo_main_alv.

    IF r_deliv EQ 'X'.
      CALL METHOD mo_main_alv->set_table_for_first_display
        EXPORTING
*         is_variant                    =                  " Layout
*         i_save                        =                  " Save Layout
*         i_default                     = 'X'              " Default Display Variant
          is_layout                     = me->fill_main_layo( )               " Layout
        CHANGING
          it_outtab                     = mt_data                 " Output Table
          it_fieldcatalog               = lt_fcat                  " Field Catalog
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
      CALL METHOD mo_main_alv->set_table_for_first_display
        EXPORTING
          i_structure_name              = 'MS_EXCEL_DATA'
*         is_variant                    =                  " Layout
*         i_save                        =                  " Save Layout
*         i_default                     = 'X'              " Default Display Variant
          is_layout                     = me->fill_main_layo( )               " Layout
        CHANGING
          it_outtab                     = mt_e_itab                 " Output Table
*         it_fieldcatalog               = mt_fcat                  " Field Catalog
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

    ENDIF.




  ENDMETHOD.

  METHOD get_data.

    SELECT
          likp~kunnr,
          lips~vbeln,
          lips~posnr,
          lips~pstyv,
          lips~ernam,
          likp~wadat_ist,
          lips~matnr,
          lips~ntgew,
          lips~gewei
          FROM likp
          INNER JOIN lips ON likp~vbeln = lips~vbeln
          INTO CORRESPONDING FIELDS OF TABLE @mt_data
          WHERE lips~vbeln IN @s_vbeln
                AND lips~posnr IN @s_posnr
                AND lips~matnr IN @s_matnr
                AND likp~kunnr IN @s_kunrr.

  ENDMETHOD.

  METHOD  fill_main_layo.
    ro_layo = VALUE lvc_s_layo(
              cwidth_opt = abap_true
              sel_mode   = 'A'

     ).
  ENDMETHOD.


  METHOD file_open_dialog.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title = 'Open Excel'                 " Title Of File Open Dialog
      CHANGING
        file_table   = mt_file                 " Table Holding Selected Files
        rc           = mv_subrc.                " Return Code, Number of Files or -1 If Error Occurred

    IF mv_subrc EQ 1.
      READ TABLE mt_file INTO p_file INDEX 1.
    ENDIF.

  ENDMETHOD.


  METHOD excel_alv.

    DATA: it_raw        TYPE truxs_t_text_data.
    DATA lt_tablex      TYPE STANDARD TABLE OF  alsmex_tabline.

*    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
*      EXPORTING
**       i_field_seperator    =                  " Character Field Length 1
**       i_line_header        = 'X'                 " Excel ilk satırı almıyor 2.satırdan başlatıyor
*        i_tab_raw_data       = it_raw
*        i_filename           = p_file                 " Local file for upload/download
*        i_step               = 1                " Steps for progress indicator
*      TABLES
*        i_tab_converted_data = mt_e_itab.


*
    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = 2
        i_end_col               = 8
        i_end_row               = 1000
      TABLES
        intern                  = lt_tablex
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    DATA(currline) = 0.
    SORT lt_tablex BY row col.
    LOOP AT lt_tablex INTO DATA(ls_tablex).

      IF currline = 0.
        currline = ls_tablex-row.
      ENDIF.

      IF currline <> ls_tablex-row.
        currline = ls_tablex-row.
        APPEND ms_excel_data TO mt_e_itab.
      ENDIF.


      CASE ls_tablex-col.
        WHEN 1.
          ms_excel_data-col1 = ls_tablex-value.
        WHEN 2.
          ms_excel_data-col2 = ls_tablex-value.
        WHEN 3.
          ms_excel_data-col3 = ls_tablex-value.
        WHEN 4.
          ms_excel_data-col4 = ls_tablex-value.
        WHEN 5.
          ms_excel_data-col5 = ls_tablex-value.
        WHEN 6.
          ms_excel_data-col6 = ls_tablex-value.
        WHEN 7.
          ms_excel_data-col7 = ls_tablex-value.
        WHEN 8.
          ms_excel_data-col8 = ls_tablex-value.
      ENDCASE.

    ENDLOOP.


  ENDMETHOD.


  METHOD handler_toolbar.

    DATA: ls_toolbar TYPE stb_button.

    ls_toolbar-function = '&FORM'.
    ls_toolbar-icon     = '@0X@'.
    ls_toolbar-text     = 'Form Yazdır'.
    APPEND ls_toolbar TO e_object->mt_toolbar.CLEAR ls_toolbar.

    ls_toolbar-function = '&ETI'.
    ls_toolbar-icon     = '@0O@'.
    ls_toolbar-text     = 'Eiket Yazdır'.
    APPEND ls_toolbar TO e_object->mt_toolbar.CLEAR ls_toolbar.

    ls_toolbar-function = '&SAVE'.
    ls_toolbar-icon     = '@2L@'.
    ls_toolbar-text     = 'Kaydet'.
    IF r_deliv EQ 'X'.
      ls_toolbar-disabled = abap_true.
    ELSE.
      ls_toolbar-disabled = abap_false.
    ENDIF.
    APPEND ls_toolbar TO e_object->mt_toolbar.CLEAR ls_toolbar.


  ENDMETHOD.

  METHOD handler_user_command.

    DATA : l_fmname         TYPE funcname,
           l_params         TYPE sfpoutputparams,
           l_docparams      TYPE sfpdocparams,
           l_formoutput     TYPE fpformoutput,
           lv_spid          TYPE sfpjoboutput,
           e_interface_type TYPE fpinterfacetype.

    DATA: lt_form_outputs TYPE STANDARD TABLE OF fpformoutput.

    CASE e_ucomm.

      WHEN '&FORM'.


        .

        FREE mt_select_data.
        CALL METHOD mo_main_alv->get_selected_rows
          IMPORTING
*           et_index_rows =                  " Indexes of Selected Rows
            et_row_no = mt_row_no.                 " Numeric IDs of Selected Rows

        LOOP AT mt_row_no INTO DATA(ms_row_no).
          READ TABLE mt_data INTO DATA(ls_data) INDEX ms_row_no-row_id.
          IF sy-subrc EQ 0.
            APPEND ls_data TO mt_select_data.
          ENDIF.
          CLEAR ls_data.
        ENDLOOP.



        IF mt_select_data IS NOT INITIAL.

          CALL SCREEN 0101 STARTING AT 10 5
                      ENDING AT   45 12.

          IF g_logo IS NOT INITIAL.

            DATA: lt_group_data TYPE STANDARD TABLE OF zot_16_s_deliver.

            FREE lt_group_data.


            e_interface_type = 'X'.
            CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
              EXPORTING
                i_name           = 'ZOT_16_AF_DELIVERY'
              IMPORTING
                e_funcname       = l_fmname
                e_interface_type = e_interface_type.


            l_params-nodialog = 'X'.
            l_params-preview = abap_true.
            l_params-dest    = 'LP01'.


*            l_params-assemble = 'X'.
*            l_params-getpdf = 'X'.
*            l_params-bumode = 'M'.


            CALL FUNCTION 'FP_JOB_OPEN'
              CHANGING
                ie_outputparams = l_params
              EXCEPTIONS
                cancel          = 1
                usage_error     = 2
                system_error    = 3
                internal_error  = 4
                OTHERS          = 5.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.



            LOOP AT mt_select_data INTO DATA(ls_row_data)
              GROUP BY ls_row_data-kunnr.

              FREE lt_group_data.
              LOOP AT GROUP ls_row_data INTO DATA(ls_group).
                APPEND ls_group TO lt_group_data.
                CLEAR ls_group.
              ENDLOOP.


              l_docparams-langu = 'T'.

              CALL FUNCTION l_fmname
                EXPORTING
                  /1bcdwb/docparams  = l_docparams
                  gt_table           = lt_group_data
                  g_logo             = g_logo
                IMPORTING
                  /1bcdwb/formoutput = l_formoutput
                EXCEPTIONS
                  usage_error        = 1
                  system_error       = 2
                  internal_error     = 3
                  OTHERS             = 4.
              IF sy-subrc <> 0.
                MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.

            ENDLOOP.



            CALL FUNCTION 'FP_JOB_CLOSE'
              IMPORTING
                e_result       = lv_spid
              EXCEPTIONS
                usage_error    = 1
                system_error   = 2                " System Error
                internal_error = 3                " Internal Error
                OTHERS         = 4.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.

          ELSE.
            MESSAGE 'Lütfen Logo Seç..!!' TYPE 'I'.
          ENDIF.

        ELSE.
          MESSAGE 'Lütfen Satır Seçiniz..!!' TYPE 'I'.
        ENDIF.


      WHEN '&ETI'.
        me->ticket_write( ).


      WHEN OTHERS.
    ENDCASE.


  ENDMETHOD.


  METHOD ticket_wrıte.

    DATA: lt_rows      TYPE lvc_t_row,
          lv_count_tab TYPE int4.
    DATA : l_ftick        TYPE funcname,
           l_params_e     TYPE sfpoutputparams,
           l_docparams_e  TYPE sfpdocparams,
           l_formoutput_e TYPE fpformoutput.

    CALL METHOD mo_main_alv->get_selected_rows
      IMPORTING
        et_index_rows = lt_rows                 " Indexes of Selected Rows
*       et_row_no     =                  " Numeric IDs of Selected Rows
      .

    DESCRIBE TABLE lt_rows LINES lv_count_tab.
    IF lv_count_tab EQ 1.
      READ TABLE lt_rows INTO DATA(ls_row) INDEX 1.
      IF sy-subrc EQ 0.
        READ TABLE mt_data INTO DATA(ls_select_data) INDEX ls_row-index.
        IF sy-subrc EQ 0.

          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = 'ZOT_16_AF_TICKET'
            IMPORTING
              e_funcname = l_ftick.
*               E_INTERFACE_TYPE           =

*
*     *        l_params-getpdf = 'X'.
          l_params_e-nodialog = 'X'.
          l_params_e-preview = 'X'.
          l_params_e-dest    = 'LP01'.



          CALL FUNCTION 'FP_JOB_OPEN'
            CHANGING
              ie_outputparams = l_params_e
            EXCEPTIONS
              cancel          = 1
              usage_error     = 2
              system_error    = 3
              internal_error  = 4
              OTHERS          = 5.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.


          l_docparams_e-langu = 'T'.

          CALL FUNCTION l_ftick
            EXPORTING
              /1bcdwb/docparams  = l_docparams_e
              gs_data            = ls_select_data
            IMPORTING
              /1bcdwb/formoutput = l_formoutput_e
            EXCEPTIONS
              usage_error        = 1
              system_error       = 2
              internal_error     = 3
              OTHERS             = 4.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.

          CALL FUNCTION 'FP_JOB_CLOSE'
*            IMPORTING
*              e_result       = lv_spid
            EXCEPTIONS
              usage_error    = 1
              system_error   = 2                " System Error
              internal_error = 3                " Internal Error
              OTHERS         = 4.
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.


        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE 'Bir tane seçim yapınız lütfen..!' TYPE 'I'.
    ENDIF.






  ENDMETHOD.


  METHOD select_logo.
    IF r_logo_one EQ 'X'.
      CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
        EXPORTING
          p_object = 'GRAPHICS'                  " SAPscript Graphics Management: Application object
          p_name   = 'YERLI LOGO'                  " Name
          p_id     = 'BMAP'                 " SAPscript Graphics Management: ID
          p_btype  = 'BCOL'                  " SAPscript: Type of graphic
        RECEIVING
          p_bmp    = lv_bmp                " Graphic Data
*            EXCEPTIONS
*         not_found      = 1                " Graphic Not Found
*         internal_error = 2                " Internal error
*         others   = 3
        .
      IF sy-subrc <> 0.
*           MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*             WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      g_logo = lv_bmp.

    ELSE.

      CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
        EXPORTING
          p_object = 'GRAPHICS'                  " SAPscript Graphics Management: Application object
          p_name   = 'Z_COLOR_YERLI'                  " Name
          p_id     = 'BMAP'                 " SAPscript Graphics Management: ID
          p_btype  = 'BCOL'                  " SAPscript: Type of graphic
        RECEIVING
          p_bmp    = lv_bmp                " Graphic Data
*            EXCEPTIONS
*         not_found      = 1                " Graphic Not Found
*         internal_error = 2                " Internal error
*         others   = 3
        .
      IF sy-subrc <> 0.
*           MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*             WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      g_logo = lv_bmp.


    ENDIF.








  ENDMETHOD.


ENDCLASS.
