*&---------------------------------------------------------------------*
*& Report ZOT_16_P_BATCH_INPUT_OOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_batch_input_oop.
INCLUDE zot_16_i_batch_input_oop_sel.
INCLUDE zot_16_p_batch_input_oop_inc.
INCLUDE zot_16_i_batch_input_oop_cds.


INITIALIZATION.
  go_main = lcl_main_batch_input=>getinstance( ).


START-OF-SELECTION.

  CALL METHOD go_main->lcl_main_inc~bdc_dynpro
    EXPORTING
      program = 'SAPLMGMM'
      dynpro  = '0060'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_CURSOR'
      fval = 'RMMG1-MTART'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_OKCODE'
      fval = '=ENTR'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'RMMG1-MBRSH'
      fval = 'C'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'RMMG1-MTART'
      fval = 'VKHM'.


  CALL METHOD go_main->lcl_main_inc~bdc_dynpro
    EXPORTING
      program = 'SAPLMGMM'
      dynpro  = '0070'.
  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_CURSOR'
      fval = 'MSICHTAUSW-DYTXT(01)'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_OKCODE'
      fval = '=ENTR'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MSICHTAUSW-KZSEL(01)'
      fval = 'X'.


  CALL METHOD go_main->lcl_main_inc~bdc_dynpro
    EXPORTING
      program = 'SAPLMGMM'
      dynpro  = '4004'.
  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_OKCODE'
      fval = '/00'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MAKT-MAKTX'
      fval = CONV bdc_fval( p_maktx ).

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_CURSOR'
      fval = 'MARA-MEINS'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MARA-MEINS'
      fval = 'PC'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MARA-MTPOS_MARA'
      fval = 'NORM'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MARA-BRGEW'
      fval = '5'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MARA-GEWEI'
      fval = 'KG'.

  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'MARA-NTGEW'
      fval = '3'.


  CALL METHOD go_main->lcl_main_inc~bdc_dynpro
    EXPORTING
      program = 'SAPLSPO1'
      dynpro  = '0300'.
  CALL METHOD go_main->lcl_main_inc~bdc_field
    EXPORTING
      fnam = 'BDC_OKCODE'
      fval = '=YES'.


  go_main->call_transation( ).
