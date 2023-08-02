*&---------------------------------------------------------------------*
*& Include zot_16_i_sip_kirilim_top
*&---------------------------------------------------------------------*



TYPES: BEGIN OF lty_kirilim,
         auart TYPE vbak-auart,
         matnr TYPE vbap-matnr,
         kunnr TYPE vbak-kunnr,
         matkl TYPE vbap-matkl,
         charg TYPE vbap-charg,
         netwr TYPE vbap-netwr,
         waerk TYPE vbap-waerk,
       END OF lty_kirilim.

DATA gt_kirilim TYPE TABLE OF lty_kirilim.
*DATA gt_kirilim_collect TYPE TABLE OF lty_kirilim.
*DATA gs_kirilim_collect TYPE lty_kirilim.

DATA(gv_counter) = 0.
DATA(gv_position) = 0.



DATA: it_fieldcat TYPE LVC_T_FCAT,
      is_fieldcat LIKE line OF it_fieldcat.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Dinamik

*DATA: gt_newtable TYPE REF TO data,
*      gs_newline  TYPE REF TO data.
*
FIELD-SYMBOLS:
             <gt_dyntable> TYPE STANDARD TABLE,
                 <gs_dyntable> TYPE any,
                 <fieldcatalog> TYPE lvc_s_fcat.  "Field catalog için üzerinde gezmek
