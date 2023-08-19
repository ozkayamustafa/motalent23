*&---------------------------------------------------------------------*
*& Report ZOT_16_P_TS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_ts.

INCLUDE zot_16_ts_i_top.
INCLUDE zot_16_ts_i_sls.
INCLUDE zot_16_ts_i_cls.
INCLUDE zot_16_ts_pbo.
INCLUDE zot_16_ts_pai.

INITIALIZATION.
  go_main = lcl_main_controller=>get_instance( ).


START-OF-SELECTION.
  go_main->get_data( ).
  CALL SCREEN 0100.
