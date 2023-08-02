*&---------------------------------------------------------------------*
*& Include zot_16_i_sip_kirilim_sel
*&---------------------------------------------------------------------*

TABLES: vbak,vbap.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_vbeln FOR vbak-vbeln, "Sipariş No
                  s_kunnr FOR vbak-kunnr, " Sipariş Veren
                  s_auart FOR vbak-auart, "Sipariş Türü
                  s_audat FOR vbak-audat. "Belge Tarihi

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN ULINE.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

  SELECT-OPTIONS: s_matnr FOR vbap-matnr,
                   s_werks FOR vbap-werks,
                   s_pstyv FOR vbap-pstyv,
                   s_matkl FOR vbap-matkl,
                   s_charg FOR vbap-charg.


SELECTION-SCREEN END OF BLOCK b2.



SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  PARAMETERS: c_sipt  AS CHECKBOX,
              c_matnr AS CHECKBOX,
              c_order AS CHECKBOX,
              c_matkl AS CHECKBOX,
              c_party AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b3.
