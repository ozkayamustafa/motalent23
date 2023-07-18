*&---------------------------------------------------------------------*
*& Report zot_16_p_report
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_report.


INCLUDE zot_16_i_slc.

DATA:i_fieldcat TYPE slis_t_fieldcat_alv.
DATA:g_program TYPE sy-repid VALUE sy-repid.
DATA go_alv TYPE REF TO cl_salv_table.

TYPES : BEGIN OF gty_eban,  " Eban type
          banfn TYPE eban-banfn,
          bnfpo TYPE eban-bnfpo,
          bsart TYPE eban-bsart,
          matnr TYPE eban-matnr,
          menge TYPE eban-menge,
          meins TYPE eban-meins,
        END OF gty_eban.

DATA : gt_alv_eban TYPE TABLE OF gty_eban.

TYPES : BEGIN OF gty_ekpo,    " Ekpo type
          ebeln TYPE ekpo-ebeln,
          matkl TYPE ekpo-matkl,
          matnr TYPE ekpo-matnr,
          menge TYPE ekpo-menge,
          meins TYPE ekpo-meins,
        END OF gty_ekpo.

DATA : gt_alv_ekpo TYPE TABLE OF gty_ekpo.


START-OF-SELECTION.

  SELECT eb~banfn, eb~bnfpo, eb~bsart, eb~matnr, eb~menge, eb~meins
         FROM eban AS eb
         INNER JOIN ekpo
         ON eb~banfn = ekpo~banfn AND
            eb~bnfpo = ekpo~bnfpo
         WHERE eb~banfn IN @p_satno AND
               eb~bnfpo IN @p_doc
         INTO CORRESPONDING FIELDS OF TABLE @gt_alv_eban.

  SELECT ek~ebeln, ek~matkl, ek~matnr, ek~menge, ek~meins
         FROM ekpo AS ek
         INNER JOIN eban
         ON ek~banfn = eban~banfn AND
            ek~bnfpo = eban~bnfpo
         WHERE ek~ebeln IN @p_sasno AND
               ek~matkl IN @p_goods
         INTO CORRESPONDING FIELDS OF TABLE @gt_alv_ekpo.




END-OF-SELECTION.

 CASE abap_true.
    WHEN p_sat.

        cl_salv_table=>factory(
             IMPORTING
                r_salv_table = go_alv
              CHANGING
                  t_table    = gt_alv_eban
         ).

        DATA lo_display TYPE REF TO cl_salv_display_settings.

        lo_display = go_alv->get_display_settings( ).
        lo_display->set_list_header( 'SAT RAPOR' ).
        lo_display->set_striped_pattern( value = 'X' ).

        DATA lo_func TYPE REF TO cl_salv_functions.
        lo_func = go_alv->get_functions( ).
        lo_func->set_all( abap_true ).

        DATA: lo_header TYPE REF TO cl_salv_form_layout_grid,
             lo_h_label TYPE REF TO cl_salv_form_label,
             lo_h_flow TYPE REF TO cl_salv_form_layout_flow.

        CREATE OBJECT lo_header.
         lo_h_label = lo_header->create_label( row = 1 column = 1 ).
         lo_h_label->set_text( value = 'SAT RAPOR' ).
         lo_h_flow = lo_header->create_flow( row = 2 column = 1 ).
         lo_h_flow->create_text(
                text = sy-uname
          ).

        go_alv->set_top_of_list( lo_header ).
        go_alv->display( ).


*      CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*        EXPORTING
*          i_program_name     = g_program
*          i_internal_tabname = 'EBAN'
*          i_inclname         = g_program
*          i_bypassing_buffer = 'X'
*        CHANGING
*          ct_fieldcat        = i_fieldcat.
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*
*      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*        EXPORTING
*          i_callback_program = g_program
*          it_fieldcat        = i_fieldcat
*        TABLES
*          t_outtab           = gt_alv_eban.
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.


********************************************************************** EKPO ALV
    WHEN p_sas.
        cl_salv_table=>factory(
             IMPORTING
                r_salv_table = go_alv
              CHANGING
                  t_table    = gt_alv_ekpo
         ).

        DATA loo_display TYPE REF TO cl_salv_display_settings.

        lo_display = go_alv->get_display_settings( ).
        lo_display->set_list_header( 'SAS RAPOR' ).
        lo_display->set_striped_pattern( value = 'X' ).

        DATA loo_func TYPE REF TO cl_salv_functions.
        lo_func = go_alv->get_functions( ).
        lo_func->set_all( abap_true ).

        DATA: loo_header TYPE REF TO cl_salv_form_layout_grid,
             loo_h_label TYPE REF TO cl_salv_form_label,
             loo_h_flow TYPE REF TO cl_salv_form_layout_flow.

        CREATE OBJECT lo_header.
         lo_h_label = lo_header->create_label( row = 1 column = 1 ).
         lo_h_label->set_text( value = 'SAS RAPOR' ).
         lo_h_flow = lo_header->create_flow( row = 2 column = 1 ).
         lo_h_flow->create_text(
                text = sy-uname
          ).

        go_alv->set_top_of_list( lo_header ).
        go_alv->display( ).

  ENDCASE.
