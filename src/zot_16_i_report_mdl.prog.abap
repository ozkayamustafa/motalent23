*&---------------------------------------------------------------------*
*& Include zot_16_i_report_mdl
*&---------------------------------------------------------------------*
MODULE pai_0100 INPUT.
  CASE gv_okcode.
    WHEN 'BACK'.
      go_main->free( ).
      FREE go_main.
      CLEAR go_main.
      LEAVE TO SCREEN 0.
    WHEN 'BACKR'.
    WHEN 'RUN'.
  ENDCASE.

ENDMODULE.

MODULE pbo_0100 OUTPUT.

  SET PF-STATUS 'STANDARD'.
  SET TITLEBAR 'TITLE_100'.
  go_main->init_0100( ).
ENDMODULE.
