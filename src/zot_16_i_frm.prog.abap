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

  CREATE OBJECT go_container
    EXPORTING
      container_name              = 'GC_CONT'
    EXCEPTIONS
      cntl_error                  = 1                " CNTL_ERROR
      cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
      create_error                = 3                " CREATE_ERROR
      lifetime_error              = 4                " LIFETIME_ERROR
      lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.
  IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent          = go_container                 " Parent Container
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



  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*      i_structure_name = 'SCARR'
      is_layout          = gs_layout
    CHANGING
      it_outtab        = gt_scarr
      it_fieldcatalog  = gt_field.


  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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

    gs_layout-cwidth_opt = abap_true.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-ctab_fname = 'CELL_COLOR'.
ENDFORM.
