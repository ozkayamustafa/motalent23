*&---------------------------------------------------------------------*
*& Report ZOT_16_P_ADOBE_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_adobe_upload.

INCLUDE zot_16_i_adobe_upload_top.
INCLUDE zot_16_i_adobe_upload_sel.
INCLUDE zot_16_i_adobe_upload_cls.
INCLUDE zot_16_i_adobe_upload_mpl.

INITIALIZATION.
  go_main = lcl_main_adobe=>get_instance( ).

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF screen-group1 = 'SC2' AND r_deliv EQ 'X'.
      screen-active = '0'.
      MODIFY SCREEN.
      CONTINUE.
    ELSEIF screen-group1 = 'SC1' AND r_upload EQ 'X'.
      screen-active = '0'.
      MODIFY SCREEN.
      CONTINUE.
    ENDIF.
  ENDLOOP.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  IF r_upload EQ 'X'.
    go_main->file_open_dialog( ).
  ENDIF.

START-OF-SELECTION.
  go_main->get_data( ).

  IF r_upload EQ 'X'.
    IF p_file IS INITIAL.
      MESSAGE 'Dosya seçiniz lütfen..!!' TYPE 'I'.
      RETURN.
    ENDIF.
    go_main->excel_alv( ).
  ENDIF.


  CALL SCREEN 0100.
