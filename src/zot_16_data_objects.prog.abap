*&---------------------------------------------------------------------*
*& Report zot_16_data_objects
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_data_objects.

*DATA: gv_ogrenci(10)   TYPE c,
*     gv_ogrenci_soyad TYPE char12,
*      gv_tarih         TYPE sy-datum.


*gv_ogrenci = 'Mustafa'.
*gv_ogrenci_soyad = 'Özkaya'.
*gv_tarih = sy-datum.

*cl_demo_output=>write( gv_ogrenci ).
*cl_demo_output=>write( gv_ogrenci_soyad ).
*cl_demo_output=>write( gv_tarih ).


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*DATA: gv_number1 TYPE i VALUE 10,
*      gv_number2 TYPE i VALUE 5,
*     gv_result  TYPE i.

*DATA(qv_toplam) = gv_number1 + gv_number2.

*CALL FUNCTION 'ZOT_16_DO_MATH_OPS'
*    EXPORTING
*    iv_number1 = gv_number1
*    iv_number2 = gv_number2
*    IMPORTING
*   gv_result = gv_result.


*cl_demo_output=>write( |Toplama: { gv_result }| ).



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_num1 TYPE i,
              p_num2 TYPE i.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_topla  RADIOBUTTON GROUP g1,
              p_cikar  RADIOBUTTON GROUP g1,
              p_carpma RADIOBUTTON GROUP g1,
              p_bolme  RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b2.


START-OF-SELECTION.








  cl_demo_output=>display( ).
