*&---------------------------------------------------------------------*
*& Report zot_16_asal_sayi
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_asal_sayi.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_sayi1 TYPE i LENGTH 5 OBLIGATORY,
              P_sayi2 TYPE i LENGTH 5 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  DATA sayac TYPE i.
  DATA(j) = 2.
  DATA(ii) = p_sayi1.

 if p_sayi1 < p_sayi2.
  WHILE ii < p_sayi2.

    sayac = 0.
    j = 2.
    WHILE j < ii.
      IF ii MOD j = 0.
        sayac = sayac + 1.
      ENDIF.
      j = j + 1.
    ENDWHILE.
    IF sayac = 0.
      WRITE: ii.
    ENDIF.
    ii = ii + 1.
  ENDWHILE.
  ELSE.
    cl_demo_output=>display( 'Birinci sayı ikinci sayıdan küçük olmalı' ).
 endif.
