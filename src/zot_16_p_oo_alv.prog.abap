*&---------------------------------------------------------------------*
*& Report ZOT_16_P_OO_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOT_16_P_OO_ALV.

INCLUDE zot_16_i_top. " Değişkenlerimizin olacağı yer
INCLUDE zot_16_i_clss.
INCLUDE zot_16_i_pbo. " Screen açılmadan önceki yapılan işlem
INCLUDE zot_16_i_pai. " Butonların vs yakalandığı yer
INCLUDE zot_16_i_frm. " Geri kalan form yapısını oluşturacağımız yer

INITIALIZATION.
CREATE OBJECT gv_handler.

START-OF-SELECTION.

 PERFORM get_data.
 PERFORM sf_fieldcat.
 PERFORM sf_layout.

CALL SCREEN 0100.
