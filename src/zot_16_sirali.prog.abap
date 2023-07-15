*&---------------------------------------------------------------------*
*& Report zot_16_sirali
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_sirali.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_fnum TYPE i LENGTH 3 OBLIGATORY DEFAULT 30,
              P_kNum TYPE i LENGTH 1 OBLIGATORY DEFAULT 3.

  PARAMETERS: p_sayi   TYPE i LENGTH 3 OBLIGATORY,
              P_kiril  TYPE i LENGTH 1 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

*BREAK-POINT.
WHILE sy-index  le p_sayi.
  WRITE sy-index.
  if sy-index   MOD p_kiril = 0 .
   new-line .
  endif.
ENDWHILE.



*DATA gv_sayac TYPE i .
*
*WHILE gv_sayac lt p_sayi.
*  gv_sayac += 1.
*  WRITE gv_sayac.
*  if gv_sayac MOD p_kiril = 0 .
*   new-line .
*  endif.
*ENDWHILE.


*  DATA(i) = 0.
*  DATA(a) = 0.
*  DO p_fnum TIMES.
*    a = a + 1.
*    IF i MOD p_knum = 0.
*      NEW-LINE.
*      WRITE: a.
*    ELSE.
*      WRITE: a.
*    ENDIF.
*    i = i + 1.
*  ENDDO.
