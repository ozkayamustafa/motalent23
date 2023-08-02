*&---------------------------------------------------------------------*
*& Include zot_16_i_sip_kirilim_main
*&---------------------------------------------------------------------*
CLASS lcl_main_controller DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.

    CLASS-METHODS:
      "! Main controller get singleton object
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO lcl_main_controller.

    METHODS:
      get_data,
      display_data,
      display_grid,
      set_handlers,
      fill_main_fieldcat,
      handler_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column
          es_row_no.


    CLASS-DATA:
      gt_newtable TYPE REF TO data,
      gs_newline  TYPE REF TO data.

  PRIVATE SECTION.
    CLASS-DATA:
      mo_instance              TYPE REF TO lcl_main_controller,
      mo_main_custom_container TYPE REF TO cl_gui_custom_container,
      mo_main_grid             TYPE REF TO cl_gui_alv_grid,
      mt_alv_list              TYPE TABLE OF lty_kirilim.




ENDCLASS.

CLASS lcl_main_controller IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      mo_instance = NEW #( ).
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.



  METHOD get_data.


    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = it_fieldcat
      IMPORTING
        ep_table        = gt_newtable.

    ASSIGN gt_newtable->* TO <gt_dyntable>.
    CREATE DATA gs_newline LIKE LINE OF <gt_dyntable>.
    ASSIGN gs_newline->* TO <gs_dyntable>.

    SELECT

       vbak~auart,
       vbap~matnr,
       vbak~kunnr,
       vbap~matkl,
       vbap~charg,
       vbap~netwr,
       vbap~waerk
      FROM vbak INNER JOIN vbap
     ON vbak~vbeln = vbap~vbeln
     WHERE vbak~vbeln IN @s_vbeln
       AND vbak~kunnr IN @s_kunnr
       AND vbak~auart IN @s_auart
       AND vbak~audat IN @s_audat
       AND vbap~matnr IN @s_matnr
       AND vbap~werks IN @s_werks
       AND vbap~matkl IN @s_matkl
       AND vbap~charg IN @s_charg
     INTO TABLE @mt_alv_list.

    LOOP AT mt_alv_list INTO DATA(ls_data).
      MOVE-CORRESPONDING ls_data TO <gs_dyntable>.
      COLLECT <gs_dyntable> INTO <gt_dyntable>.
    ENDLOOP.


  ENDMETHOD.

  METHOD display_data.
*    IF <gt_dyntable> IS INITIAL.
*      MESSAGE 'Veri bulunamadı!' TYPE 'S' DISPLAY LIKE 'E'.
*    ELSE.
*      CALL SCREEN 0100.
*    ENDIF.
  ENDMETHOD.


  METHOD display_grid.
    me->fill_main_fieldcat( ).
    me->get_data( ).

    DATA: lv_title TYPE lvc_title,
          lv_lines TYPE num10.

    FIELD-SYMBOLS: <lt_data> TYPE STANDARD TABLE,
                   <ls_data> TYPE any.

    ASSIGN <gt_dyntable> TO <lt_data>.
*    ASSIGN gt_kirilim_collect TO <lt_data>.
    CHECK sy-subrc IS INITIAL.
*


    DATA(ls_vari) = VALUE disvariant( report = sy-repid
                                      username = sy-uname ).



    DESCRIBE TABLE <lt_data> LINES lv_lines.
    SHIFT lv_lines LEFT DELETING LEADING '0'.

    CONCATENATE 'Rapor' lv_lines 'Kayıt' INTO lv_title SEPARATED BY space.

    IF gv_counter = 2.
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
        EXPORTING
          i_callback_program      = sy-repid
          i_grid_title            = lv_title
          it_fieldcat_lvc         = it_fieldcat
          i_save                  = 'A'
          is_variant              = ls_vari
          i_callback_user_command = 'ORDER_DETAILS'
        TABLES
          t_outtab                = <lt_data>
        EXCEPTIONS
          program_error           = 1
          OTHERS                  = 2.
      IF sy-subrc IS NOT INITIAL.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      MESSAGE 'İki Seçim Yapmalısınız..' TYPE 'I'.
    ENDIF.

  ENDMETHOD.

  METHOD fill_main_fieldcat. " Columların ismini veriyoruz.



*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
**       I_BUFFER_ACTIVE        = 'X'
*        i_structure_name       = 'ZOT_16_S_BREAKDOWN'       "Like MKPF for example
**       I_CLIENT_NEVER_DISPLAY = 'X'
**       I_BYPASSING_BUFFER     = 'X'
**       I_INTERNAL_TABNAME     = '<GT_DYNTABLE>'      "Your Internal Table
*      CHANGING
*        ct_fieldcat            = it_fieldcat               "Your Fieldcatalogue
*      EXCEPTIONS
*        inconsistent_interface = 1
*        program_error          = 2
*        OTHERS                 = 3.
*
*
*
*    LOOP AT it_fieldcat ASSIGNING <fieldcatalog>.
*      CASE <fieldcatalog>-fieldname.
*        WHEN 'AUART'.
*          IF c_sipt <> 'X'.
*            <fieldcatalog>-no_out = 'X'.
*          ENDIF.
*        WHEN 'MATKL'.
*          IF c_matkl <> 'X'.
*            <fieldcatalog>-no_out = 'X'.
*          ENDIF.
*        WHEN 'MATNR'.
*          IF c_matnr <> 'X'.
*            <fieldcatalog>-no_out = 'X'.
*          ENDIF.
*        WHEN 'KUNNR'.
*          IF c_order <> 'X'.
*            <fieldcatalog>-no_out = 'X'.
*          ENDIF.
*        WHEN 'CHARG'.
*          IF c_party <> 'X'.
*            <fieldcatalog>-no_out = 'X'.
*          ENDIF.
*      ENDCASE.
*    ENDLOOP.

    IF c_sipt = 'X'.
      gv_counter += 1.
      is_fieldcat-fieldname = 'AUART'.
      is_fieldcat-datatype  = 'CHAR'.
      is_fieldcat-inttype   = 'C'.
      is_fieldcat-outputlen = 4.
      is_fieldcat-intlen    = 4.
      is_fieldcat-seltext   = is_fieldcat-reptext   =
      is_fieldcat-scrtext_s = is_fieldcat-scrtext_m =
      is_fieldcat-scrtext_l = 'Sipariş Türü'.
      APPEND is_fieldcat TO it_fieldcat.CLEAR is_fieldcat.


    ENDIF.
    IF c_matkl = 'X'.
      gv_counter += 1.

      is_fieldcat-fieldname = 'MATKL'.
      is_fieldcat-datatype  = 'CHAR'.
      is_fieldcat-inttype   = 'C'.
      is_fieldcat-outputlen = 9.
      is_fieldcat-intlen    = 9.
      is_fieldcat-seltext   = is_fieldcat-reptext   =
      is_fieldcat-scrtext_s = is_fieldcat-scrtext_m =
      is_fieldcat-scrtext_l = 'Mal Grubu'.
      APPEND is_fieldcat TO it_fieldcat.CLEAR is_fieldcat.

    ENDIF.
    IF c_matnr = 'X'.
      gv_counter += 1.
      is_fieldcat-fieldname = 'MATNR'.
      is_fieldcat-datatype  = 'CHAR'.
      is_fieldcat-inttype   = 'C'.
      is_fieldcat-outputlen = 40.
      is_fieldcat-intlen    = 40.
      is_fieldcat-seltext   =  is_fieldcat-reptext   =
      is_fieldcat-scrtext_s =  is_fieldcat-scrtext_m =
      is_fieldcat-scrtext_l = 'Malzeme'.
      APPEND  is_fieldcat TO it_fieldcat.CLEAR  is_fieldcat.



    ENDIF.
    IF c_order = 'X'.
      gv_counter += 1.

      is_fieldcat-fieldname = 'KUNNR'.
      is_fieldcat-datatype  = 'CHAR'.
      is_fieldcat-inttype   = 'C'.
      is_fieldcat-outputlen = 10.
      is_fieldcat-intlen    = 10.
      is_fieldcat-seltext   = is_fieldcat-reptext   =
      is_fieldcat-scrtext_s = is_fieldcat-scrtext_m =
      is_fieldcat-scrtext_l = 'Sipariş veren'.
      APPEND is_fieldcat TO it_fieldcat.CLEAR is_fieldcat.

    ENDIF.
    IF c_party = 'X'.
      gv_counter += 1.
      is_fieldcat-fieldname = 'CHARG'.
      is_fieldcat-datatype  = 'CHAR'.
      is_fieldcat-inttype   = 'C'.
      is_fieldcat-outputlen = 10.
      is_fieldcat-intlen    = 10.
      is_fieldcat-seltext   = is_fieldcat-reptext   =
      is_fieldcat-scrtext_s = is_fieldcat-scrtext_m =
      is_fieldcat-scrtext_l = 'Parti'.
      APPEND is_fieldcat TO it_fieldcat.CLEAR is_fieldcat.
    ENDIF.

     is_fieldcat-fieldname = 'NETWR'.
    is_fieldcat-datatype  = 'CURR'.
    is_fieldcat-outputlen = 15.
    is_fieldcat-decimals    = 2.
    is_fieldcat-seltext   = is_fieldcat-reptext   =
    is_fieldcat-scrtext_s = is_fieldcat-scrtext_m =
    is_fieldcat-scrtext_l = 'Değer'.
    APPEND is_fieldcat TO it_fieldcat.CLEAR is_fieldcat.

    is_fieldcat-fieldname = 'WAERK'.
    is_fieldcat-datatype  = 'CHAR'.
    is_fieldcat-inttype   = 'C'.
    is_fieldcat-outputlen = 5.
    is_fieldcat-intlen    = 5.
    is_fieldcat-seltext   = is_fieldcat-reptext   =
    is_fieldcat-scrtext_s = is_fieldcat-scrtext_m =
    is_fieldcat-scrtext_l = 'Para Birimi'.
    APPEND is_fieldcat TO it_fieldcat.CLEAR is_fieldcat.

  ENDMETHOD.


  METHOD handler_double_click.
    cl_demo_output=>display( 'Double Click' ).
  ENDMETHOD.

  METHOD set_handlers.
    SET HANDLER handler_double_click FOR mo_main_grid.
  ENDMETHOD.

ENDCLASS.


DATA:
  "! Main controller global object
  go_main TYPE REF TO lcl_main_controller.
