*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_ADOBE_UPLOAD_SEL
*&---------------------------------------------------------------------*

TABLES: lips,likp.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_vbeln FOR lips-vbeln MODIF ID sc1,
                  s_posnr FOR lips-posnr MODIF ID sc1,
                  s_matnr FOR lips-matnr MODIF ID sc1,
                  s_kunrr FOR likp-kunnr MODIF ID sc1.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
  PARAMETERS p_file TYPE localfile  MODIF ID sc2.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-001.
  PARAMETERS: r_deliv  RADIOBUTTON GROUP rnd USER-COMMAND cmd DEFAULT 'X',
              r_upload RADIOBUTTON GROUP rnd.
SELECTION-SCREEN END OF BLOCK b3.
