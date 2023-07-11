*&---------------------------------------------------------------------*
*& Report zot_16_calculator
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_calculator.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_num1 TYPE p OBLIGATORY,
              p_num2 TYPE p OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_topla  RADIOBUTTON GROUP g1 DEFAULT 'X' USER-COMMAND g1,
              p_cikar  RADIOBUTTON GROUP g1,
              p_carpma RADIOBUTTON GROUP g1,
              p_bolme  RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION.
   cl_demo_output=>display(
    COND #(
          WHEN p_topla EQ 'X' THEN
            |Toplam: { p_num1 + p_num2 }|
          WHEN p_cikar EQ 'X' THEN
            |Çıkarma: { p_num1 - p_num2 }|
            WHEN p_carpma EQ 'X' THEN
            |Çarpma: { p_num1 * p_num2 }|
             WHEN p_bolme EQ 'X' THEN
             |Bölme: { p_num1 / p_num2 }|
          ELSE
             THROW cx_sy_zerodivide( ) ) ).
