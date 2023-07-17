*&---------------------------------------------------------------------*
*& Report zot_16_internal_table
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_internal_table.

*TYPES: BEGIN OF lty_material,
*            matr TYPE mstnr,
*
*       END OF lty_material.
*
*
*       DATA lt_malzeme TYPE TABLE OF lty_material.
*       DATA lt_newMateria TYPE TABLe OF lty_material.
*
*       move lt_malzeme TO lt_newmateria.
*       MOVE-CORRESPONDING lt_malzeme TO lt_newmateria. "Şeleyere Atar verileri.
*
*       READ TABLE lt_malzeme INTO  DATA(ls_mat)  INDEX 001.

DATA gt_material TYPE TABLE OF zot_00_t_materia.   "DAtabase tabloyu gt_material dan internal tablo oluşturdum.

SELECT * FROM zot_00_t_materia INTO TABLE gt_material. " VErileri Çekiyorum gt_materia atıyorum

  READ TABLE gt_material INTO DATA(ls_material_read) INDEX 7.

  cl_demo_output=>display( ls_material_read ).
