*&---------------------------------------------------------------------*
*& Include          ZOT_16_TS_I_SLS
*&---------------------------------------------------------------------*


TABLES vbrk. "dan alınan bir tablo çalışma alanı olarak bildirir
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-100.
  SELECT-OPTIONS: s_no FOR vbrk-vbeln,
                  s_date FOR vbrk-fkdat,
                  s_type FOR vbrk-fkart,
                  s_pay FOR vbrk-kunrg.
SELECTION-SCREEN END OF BLOCK b1.
