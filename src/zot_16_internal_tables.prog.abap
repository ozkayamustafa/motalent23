*&---------------------------------------------------------------------*
*& Report zot_16_internal_tables
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_internal_tables.

DATA gt_material TYPE TABLE OF zot_00_t_materia.   "DAtabase tabloyu gt_material dan internal tablo oluşturdum.

SELECT * FROM zot_00_t_materia INTO TABLE gt_material. " VErileri Çekiyorum gt_materia atıyorum


DATA gt_material2 TYPE SORTED TABLE OF zot_00_t_materia WITH UNIQUE KEY matnr. "matkl 'C' olanları da buraya atmak için ikinci internal table UNIQUE istediği için bunla yaptım.


gt_material2 = VALUE #( BASE gt_material2 (                                "matkl 'C'  verileri atadım ikinci olan gt_material2 internal tabloma attım
                                        matnr = '000000000000000011'
                                         maktx ='Defter'
                                         matkl = 'C'
                                         menge = 5
                                         meins = 'ST')

                                         (
                                         matnr = '000000000000000012'
                                         maktx = 'Şişe'
                                         matkl = 'C'
                                         menge = 1
                                         meins = 'ST'
                                         )
                                        (
                                        matnr = '000000000000000013'
                                         maktx = 'Koltuk'
                                         matkl = 'C'
                                         menge = 3
                                         meins = 'ST'
                                         )
                                          (
                                         matnr = '000000000000000014'
                                         maktx = 'Bardak'
                                         matkl = 'C'
                                         menge = 4
                                         meins = 'ST'
                                         )
                                            (
                                         matnr = '000000000000000015'
                                         maktx = 'Ataç'
                                         matkl = 'C'
                                         menge = 7
                                         meins = 'ST'
                                         )
                                          ).




LOOP AT gt_material INTO DATA(ls_material).   " Burada işlem gt_materialdan gezip  read table da gt_material2 de mains kısmı ls_material-meins eşitse menge artırıyorum.
  READ TABLE gt_material2 INTO DATA(ls_material_read) WITH KEY meins = ls_material-meins.
  IF sy-subrc = 0.
    ls_material-menge += 10.
    MODIFY gt_material FROM ls_material.
  ENDIF.

ENDLOOP.

********************************************************************** Birleştirme

DATA gt_material3 TYPE TABLE OF zot_00_t_materia.  " Üçüncü internal tablomu oluşturdum iki tabloyu birleştirmek için


APPEND LINES OF gt_material TO gt_material3.   "APPEND LİNES OF satırları alır
APPEND LINES OF gt_material2 TO gt_material3.  " Burada da örnek gt_material satrıları gt_material3 atıyor.


********************************************************************** Collect işlemi
TYPES: BEGIN OF lty_collect,
         matkl TYPE zot_00_t_materia-matkl,
         menge TYPE zot_00_t_materia-menge,
       END OF lty_collect.

DATA gt_material_collect TYPE TABLE OF lty_collect. " Dördüncü gt_material  aynı matkl olanları  menge alanlarını burada toplayıp buraya atıcam.
DATA gs_material_collect TYPE lty_collect.

LOOP AT gt_material3 INTO DATA(ls_material4).
  CLEAR: gs_material_collect.
  gs_material_collect = VALUE #( menge = ls_material4-menge
                                 matkl = ls_material4-matkl ).
  COLLECT gs_material_collect INTO gt_material_collect.
ENDLOOP.


********************************************************************** Silme işlemi

DELETE gt_material3 WHERE menge LT 10. "gt_material3 te birleştirdiğim verileri burada 10 dan küçükse siliyorum



********************************************************************** Sıralama


SORT gt_material3 by menge ASCENDING.   " yukarda 10 düşük olanları silmiştim burada bizden 10 dan fazla olanları küçükten sırala demişti
cl_demo_output=>write( gt_material3 ). " burada da küçükten büyüye sıraladım.


Sort gt_material_collect by menge DESCENDING.  " collect yaptığımız verileri büyükten küçüğe sıraladım.
cl_demo_output=>write( gt_material_collect ).



cl_demo_output=>display( ).
