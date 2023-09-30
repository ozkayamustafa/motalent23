*&---------------------------------------------------------------------*
*& Report ZOT_16_P_MCHA_OOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_mcha_oop.

INCLUDE zot_16_i_mcha_oop_sel.


TABLES mcha.
DATA gt_mcha TYPE TABLE OF mcha.
DATA go_alv  TYPE REF TO zot_16_fi_malzeme.

INITIALIZATION.
  SELECT
    *
    FROM mcha
    INTO TABLE @gt_mcha.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_matnr.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield    = 'MATNR'
      value_org   = 'S'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'P_MATNR'
    TABLES
      value_tab   = gt_mcha
      return_tab  = gt_return.

  READ TABLE gt_return INTO gs_return INDEX 1.
  IF sy-subrc EQ 0.
    p_matnr = gs_return-fieldval.
  ENDIF.



START-OF-SELECTION.

CREATE OBJECT go_alv
  EXPORTING
    v_matnr = p_matnr                 " Material Number
  .

go_alv->display_alv( ).
