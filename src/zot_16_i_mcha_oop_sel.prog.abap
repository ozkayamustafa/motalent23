*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_MCHA_OOP_SEL
*&---------------------------------------------------------------------*



DATA: gt_return TYPE TABLE OF ddshretval,
      gs_return TYPE ddshretval.

SELECTION-SCREEN BEGIN OF BLOCK b1.
  PARAMETERS p_matnr LIKE mcha-matnr OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.
