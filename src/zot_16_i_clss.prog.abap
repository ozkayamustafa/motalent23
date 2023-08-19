
CLASS cl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS handler_top_of_page
      FOR EVENT top_of_page OF cl_gui_alv_grid
      IMPORTING
        e_dyndoc_id
        table_index.
    METHODS handler_hotspots_click
      FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        e_row_id
        e_column_id.
    METHODS handler_double_click
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
        e_row
        e_column
        es_row_no.

    METHODS handler_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING
        er_data_changed
        e_onf4
        e_onf4_after
        e_onf4_before
        e_ucomm.

    METHODS handler_onf4
      FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING
        e_fieldname
        e_fieldvalue
        es_row_no
        er_event_data
        et_bad_cells
        e_display.

    METHODS handler_button_click
      FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING
        es_col_id
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



CLASS cl_event_handler IMPLEMENTATION.
  METHOD handler_top_of_page.

    DATA: lv_text_dyndoc  TYPE sdydo_text_element,
          lv_text_dyndoc2 TYPE sdydo_text_element.
    lv_text_dyndoc = 'TOP OF PAGE Kulanımı e_dyndoc_id ile Kullanımı'.
    lv_text_dyndoc2 = 'Bir alt satırı yazdık'.

*    CALL METHOD gv_docu->add_text
*      EXPORTING
*        text = lv_text.





    CALL METHOD e_dyndoc_id->add_text
      EXPORTING
        text = lv_text_dyndoc                " Single Text, Up To 255 Characters Long
*       text_table    =                  " Table With Single Texts
*       fix_lines     =                  " If 'X': TEXT_TABLE Display in Lines, Otherwise Continuous
*       sap_style     =                  " Recommended Styles
*       sap_color     =                  " Not Release 99
*       sap_fontsize  =                  " Recommended Font Sizes
*       sap_fontstyle =                  " Not Release 99
*       sap_emphasis  =                  " Text Highlighting
*       style_class   =                  " Not Release 99
*       a11y_tooltip  =                  " A11Y: Additional Explanation
*     CHANGING
*       document      =                  " x
      .

    CALL METHOD e_dyndoc_id->new_line.
    CALL METHOD e_dyndoc_id->add_text
      EXPORTING
        text = lv_text_dyndoc2.

    CALL METHOD e_dyndoc_id->display_document
      EXPORTING
*       reuse_control      =                  " HTML Control Reused
*       reuse_registration =                  " Event Registration Reused
*       container          =                  " Name of Container (New Container Object Generated)
        parent = go_guicontainer                " Contain Object Already Exists
*     EXCEPTIONS
*       html_display_error = 1                " Error Displaying the Document in the HTML Control
*       others = 2
      .
    IF sy-subrc <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


*    CALL METHOD gv_docu->display_document
*      EXPORTING
*        parent = go_guicontainer.

  ENDMETHOD.

  METHOD handler_hotspots_click.

    DATA: lv_mess TYPE char200,
          gs_read TYPE gty_scarr.

    READ TABLE gt_scarr INTO gs_read INDEX e_row_id-index.

    IF sy-subrc EQ 0.

      CASE e_column_id.
        WHEN 'CARRID'.
          CONCATENATE 'TIklanan' gs_read-carrid INTO lv_mess SEPARATED BY space.
          MESSAGE lv_mess TYPE 'I'.

      ENDCASE.


    ENDIF.


  ENDMETHOD.


  METHOD handler_double_click.

    DATA: lv_message TYPE char200,
          ls_data    TYPE gty_scarr.

    READ TABLE gt_scarr INTO ls_data INDEX e_row-index.

    IF sy-subrc EQ 0.
      CONCATENATE 'Tıklanan' e_column ', Değeri' ls_data-carrname  INTO lv_message SEPARATED BY space.
      MESSAGE lv_message TYPE 'I'.
    ENDIF.


  ENDMETHOD.



  METHOD handler_data_changed.
    DATA lv_mess TYPE char200.


    LOOP AT er_data_changed->mt_good_cells INTO DATA(ls_modi).

      CONCATENATE 'Değişen Data -> ' ls_modi-value INTO lv_mess SEPARATED BY space.

      MESSAGE lv_mess TYPE 'I'.
    ENDLOOP.


  ENDMETHOD.

  METHOD handler_onf4.
    TYPES: BEGIN OF lty_value,
             carrname TYPE s_carrname,
           END OF lty_value.


    DATA: lt_value TYPE TABLE OF lty_value,
          ls_value TYPE lty_value.

    CLEAR ls_value.
    ls_value-carrname = 'Uçuş 1'.
    APPEND ls_value TO lt_value.
    CLEAR ls_value.
    ls_value-carrname = 'Uçuş 2'.
    APPEND ls_value TO lt_value.
    CLEAR ls_value.
    ls_value-carrname = 'Uçuş 3'.
    APPEND ls_value TO lt_value.

    DATA: lt_return_tab TYPE TABLE OF ddshretval,   "  RETURN_TAB  için oluşturulan itab
          ls_return_tab TYPE ddshretval.



    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'CARRNAME'      " Hangi column referans alacaksa onun adını yazıyoruz
        window_title = 'Search Help '                " BAşlık kısmını verilir
        value_org    = 'S'
      TABLES
        value_tab    = lt_value   "ekranda gösterecek itab mız olacak
        return_tab   = lt_return_tab.    " itab döndürmesi için olacak


    READ TABLE lt_return_tab INTO ls_return_tab WITH KEY fieldname = 'F0001'.
    IF sy-subrc EQ 0.

      READ TABLE gt_scarr ASSIGNING FIELD-SYMBOL(<ls_read>) INDEX es_row_no-row_id.
      IF sy-subrc EQ 0.
        <ls_read>-carrname = ls_return_tab-fieldval.
        CALL METHOD go_alv->refresh_table_display.
      ENDIF.

    ENDIF.





  ENDMETHOD.



  METHOD handler_button_click.

    DATA mess TYPE char50.


    READ TABLE gt_scarr ASSIGNING FIELD-SYMBOL(<read>) INDEX es_row_no-row_id.

    CASE es_col_id-fieldname.
      WHEN 'DELETE'.
        DELETE gt_scarr WHERE carrid = <read>-carrid.
        CALL METHOD go_alv->refresh_table_display.
    ENDCASE.



  ENDMETHOD.

  METHOD handler_toolbar.

    DATA ls_toolbar TYPE stb_button.

    CLEAR ls_toolbar.
    ls_toolbar-function = 'DEL'.
    ls_toolbar-text = 'Sil'.
    ls_toolbar-icon = '@11@'.
    ls_toolbar-quickinfo = 'Silme İşlemi'.
    ls_toolbar-disabled = abap_false.
    APPEND ls_toolbar TO e_object->mt_toolbar.



  ENDMETHOD.

  METHOD handler_user_command.
    DATA lt_rows TYPE lvc_t_row.
    CASE e_ucomm.
      WHEN 'DEL'.
        CALL METHOD go_alv->get_selected_rows
          IMPORTING
            et_index_rows = lt_rows.

        LOOP AT lt_rows INTO DATA(ls_rows).
          DELETE gt_scarr INDEX ls_rows-index.
          CALL METHOD go_alv->refresh_table_display.
          CLEAR ls_rows.
        ENDLOOP.
    ENDCASE.


  ENDMETHOD.


ENDCLASS.
