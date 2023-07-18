*&---------------------------------------------------------------------*
*& Include zot_16_i_cls
*&---------------------------------------------------------------------*

  CLASS lcl_main_controller DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.

    CLASS-METHODS:
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO lcl_main_controller.

    METHODS:

      selscr_output,
      get_data,
      display_data,
      display_SALV,
      display_grid,
      init_0100,
      free.

  PRIVATE SECTION.
    CLASS-DATA:

      mo_instance              TYPE REF TO lcl_main_controller,

      mo_main_custom_container TYPE REF TO cl_gui_custom_container,
      mo_main_grid             TYPE REF TO cl_gui_alv_grid,
      mt_alv                   TYPE TABLE OF zot_16_s_eban,
      mt_alv_ekpo              TYPE TABLE OF zot_16_s_ekpo.

    METHODS:
      fill_main_fieldcat
        RETURNING
          VALUE(rt_fcat) TYPE lvc_t_fcat,
      fill_main_layout
        RETURNING
          VALUE(rs_layo) TYPE lvc_s_layo.

ENDCLASS.

CLASS lcl_main_controller IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      mo_instance = NEW #( ).
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD selscr_output.

*    LOOP AT SCREEN.
*      IF screen-name CS 'S_MATNR'.
*        screen-active = 0.
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.


  METHOD get_data.


    SELECT eb~banfn, eb~bnfpo, bsart, eb~matnr, eb~meins
       FROM eban AS eb
       INNER JOIN ekpo AS ek
       ON eb~banfn = ek~banfn AND
          eb~bnfpo = ek~bnfpo
       WHERE eb~banfn IN @p_satno AND
             eb~bnfpo IN @p_doc
       INTO TABLE @mt_alv.


  ENDMETHOD.

  METHOD display_data.
    IF me->mt_alv IS INITIAL.
      MESSAGE 'Veri bulunamadı!' TYPE 'S' DISPLAY LIKE 'E'.
    ELSE.
      CALL SCREEN 0100.
    ENDIF.
  ENDMETHOD.

  METHOD display_SALV.

    cl_salv_table=>factory(
      EXPORTING
        list_display = ''
      IMPORTING
        r_salv_table = go_alv
      CHANGING
        t_table      = me->mt_alv ).

    go_alv->set_screen_popup(
      start_column = 1
      end_column   = 150
      start_line   = 1
      end_line     = 20 ).

    go_alv->set_screen_status( pfstatus      = 'STANDARD'
                               report        = sy-repid
                               set_functions = go_alv->c_functions_all ).



    go_alv->display( ).
  ENDMETHOD.

  METHOD display_grid.



    DATA: lv_title TYPE lvc_title,
          lv_lines TYPE num10.

    FIELD-SYMBOLS: <lt_data> TYPE STANDARD TABLE,
                   <ls_data> TYPE any.

    ASSIGN me->mt_alv TO <lt_data>.
    CHECK sy-subrc IS INITIAL.
*
    DATA(ls_layo) = VALUE lvc_s_layo( zebra      = abap_true
                                      cwidth_opt = abap_true
                                      sel_mode   = 'A'
                                      excp_fname = 'COLOR'
                                      excp_led   = abap_true ).
    DATA(ls_vari) = VALUE disvariant( report = sy-repid
                                      username = sy-uname ).

    DATA(lt_fcat_main) = me->fill_main_fieldcat( ).

    DESCRIBE TABLE <lt_data> LINES lv_lines.
    SHIFT lv_lines LEFT DELETING LEADING '0'.

    CONCATENATE 'Rapor' lv_lines 'Kayıt' INTO lv_title SEPARATED BY space.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_callback_program = sy-repid
        i_grid_title       = lv_title
        is_layout_lvc      = ls_layo
        it_fieldcat_lvc    = lt_fcat_main
        i_save             = 'A'
        is_variant         = ls_vari
      TABLES
        t_outtab           = <lt_data>
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


  ENDMETHOD.

  METHOD init_0100.
    IF me->mo_main_custom_container IS INITIAL.
      me->mo_main_custom_container = NEW cl_gui_custom_container( container_name = 'CC_MAIN' ).
      me->mo_main_grid = NEW cl_gui_alv_grid( i_parent = me->mo_main_custom_container i_appl_events = abap_true ).

      FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.
      ASSIGN me->mt_alv TO <lt_data>.

      DATA(ls_vari) = VALUE disvariant( report = sy-repid
                                        username = sy-uname ).

*      me->set_handler_for_main( ).

      DATA(lt_fcat_main) = me->fill_main_fieldcat( ).

      me->mo_main_grid->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer            = abap_true
          is_variant                    = ls_vari
          i_save                        = 'A'
          is_layout                     = me->fill_main_layout( )
        CHANGING
          it_outtab                     = <lt_data>
          it_fieldcatalog               = lt_fcat_main
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4
      ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      me->mo_main_grid->refresh_table_display( is_stable = VALUE #( col = abap_true row = abap_true ) ).
    ENDIF.
  ENDMETHOD.

  METHOD fill_main_fieldcat.
    DATA: lv_fname  TYPE lvc_fname,
          lv_offset TYPE i.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZOT_16_S_EBAN'
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

*    LOOP AT rt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
*      CASE <ls_fcat>-fieldname.
*        WHEN 'COLOR'.
*          <ls_fcat>-hotspot = abap_true.
*        WHEN 'MATKL'.
*          <ls_fcat>-edit = abap_true.
*        WHEN 'MATNR'.
*          <ls_fcat>-scrtext_l =
*          <ls_fcat>-scrtext_M =
*          <ls_fcat>-scrtext_S =
*          <ls_fcat>-reptext = 'DENEMEEE'.
*
*          <ls_fcat>-hotspot = abap_true.
*      ENDCASE.
*    ENDLOOP.

  ENDMETHOD.

  METHOD fill_main_layout.
    rs_layo = VALUE lvc_s_layo( zebra = abap_true cwidth_opt = abap_true sel_mode = 'A' ).
  ENDMETHOD.


  METHOD free.
    IF me->mo_main_custom_container IS NOT INITIAL.
      me->mo_main_grid->free( ).
      me->mo_main_custom_container->free( ).
      CLEAR: me->mo_main_grid,
             me->mo_main_custom_container.
    ENDIF.
    FREE mo_instance.
    CLEAR mo_instance.
  ENDMETHOD.


ENDCLASS.


DATA:
  "! Main controller global object
  go_main TYPE REF TO lcl_main_controller.
