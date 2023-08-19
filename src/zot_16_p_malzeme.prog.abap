*&---------------------------------------------------------------------*
*& Report ZOT_16_P_MALZEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOT_16_P_MALZEME.

DATA gt_data TYPE TABLE OF ekpo.


DATA: gv_matnr TYPE bapimatdet-material,
      gs_detail TYPE bapimatdoa.

SELECT-OPTIONS s_matnr FOR gv_matnr NO INTERVALS.

SELECT * from ekpo INTO CORRESPONDING FIELDS OF TABLE @gt_data WHERE matnr IN @s_matnr.

gv_matnr = s_matnr-low.
 CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL'
      EXPORTING
        material              = gv_matnr
      IMPORTING
        material_general_data = gs_detail.


cl_demo_output=>display( gs_detail ).
