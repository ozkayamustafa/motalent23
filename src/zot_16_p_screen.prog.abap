*&---------------------------------------------------------------------*
*& Report ZOT_16_P_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_screen.

DATA: gv_name    TYPE char20,
      gv_surname TYPE char30.

DATA:gv_woman TYPE char1,
     gv_man   TYPE char1.

DATA gv_cbox TYPE char1.

DATA gv_yas TYPE i. " list yapmak için


DATA: gv_id     TYPE vrm_id,
      gt_values TYPE vrm_values,
      gs_value  TYPE vrm_value.

DATA gv_date TYPE datum.

DATA gs_personels TYPE zot_16_t_perso.

START-OF-SELECTION.

  CALL SCREEN 0100.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.

  gv_id = 'GV_YAS'.

  DO 99 TIMES.
    gs_value-key = sy-index.
    gs_value-text = sy-index.

    APPEND gs_value TO gt_values.

  ENDDO.


  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_id
      values = gt_values.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'AGSAVE' .
        PERFORM save_data.

    WHEN 'AGCLEAR'.

      PERFORM clear_data.


  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form clear_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_data .
   CLEAR: gv_name,
              gv_surname,
              gv_date,
              gv_yas,
              gv_cbox,
              gv_man.
      gv_woman = abap_true.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .
  gs_personels-name = gv_name.
      gs_personels-surname = gv_surname.
      gs_personels-dates = gv_date.
      gs_personels-yas = gv_yas.
      IF gv_woman EQ abap_true.
        gs_personels-cinsiyet = 'K'.
      ELSE.
        gs_personels-cinsiyet = 'E'.
      ENDIF.
      gs_personels-cbox = gv_cbox.

      INSERT zot_16_t_perso FROM gs_personels.
      COMMIT WORK AND WAIT.
      MESSAGE 'BAŞARIYLA EKLENDI VERİLER.' TYPe 'I'.
      PERFORM clear_data.
ENDFORM.
