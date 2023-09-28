*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_ADOBE_UPLOAD_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF t_datatab,
         col1  TYPE datum,
         col2(30) TYPE c,
         col3(30) TYPE c,
         col4(30) TYPE c,
         col5(30) TYPE c,
         col6(30) TYPE c,
         col7(30) TYPE c,
         col8(30) TYPE c,
       END OF t_datatab.

DATA: r_logo_one TYPE c LENGTH 1,
      r_logo_two TYPE c LENGTH 1.

CLASS lcl_main_adobe DEFINITION DEFERRED.
DATA go_main TYPE REF TO lcl_main_adobe.
