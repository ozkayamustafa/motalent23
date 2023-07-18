*&---------------------------------------------------------------------*
*& Include zot_16_i_slc
*&---------------------------------------------------------------------*

TABLES: eban , ekpo.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: p_satno FOR eban-banfn,
              p_doc   FOR  eban-bsart.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  SELECT-OPTIONS: p_sasno FOR ekpo-ebeln,
                  p_goods FOR ekpo-matkl.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_sat  RADIOBUTTON GROUP gr1 DEFAULT 'X',
              p_sas  RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK b3.
