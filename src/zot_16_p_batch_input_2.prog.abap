*&---------------------------------------------------------------------*
*& Report ZOT_16_P_BATCH_INPUT_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_batch_input_2.

DATA: gt_bdcdata TYPE TABLE OF bdcdata,
      gs_bdcdata TYPE bdcdata.

DATA:   gt_messtab TYPE TABLE OF bdcmsgcoll.


SELECTION-SCREEN BEGIN OF BLOCK b1.
  PARAMETERS p_maktx TYPE char40.
SELECTION-SCREEN END OF BLOCK b1.



START-OF-SELECTION.


  PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RMMG1-MTART'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ENTR'.
  PERFORM bdc_field       USING 'RMMG1-MBRSH'
                                'C'.      "Dinamik alanım yani batch inputta verdiğim kısımların değerleri var
  PERFORM bdc_field       USING 'RMMG1-MTART'
                                'VKHM'.
  PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'MSICHTAUSW-DYTXT(01)'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=ENTR'.
  PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)'
                                'X'.
  PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'MAKT-MAKTX'
                                 p_maktx.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'MARA-MEINS'.
  PERFORM bdc_field       USING 'MARA-MEINS'
                                'PC'.
  PERFORM bdc_field       USING 'MARA-MTPOS_MARA'
                                 'NORM'.
  PERFORM bdc_field       USING 'MARA-BRGEW'
                                '5'.
  PERFORM bdc_field       USING 'MARA-GEWEI'
                                'KG'.
  PERFORM bdc_field       USING 'MARA-NTGEW'
                                 '3'.
  PERFORM bdc_dynpro      USING 'SAPLSPO1' '0300'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=YES'.
  CALL TRANSACTION 'MM01' WITH AUTHORITY-CHECK USING gt_bdcdata
                      MODE   'N'   "A, N veya E değerleri veriyoruz. A: tüm adımları göster, N: arka planda yap adımları  E: Hataları göster
*                       UPDATE CUPDATE   "A veya S var.  A: kaydetme   S: Kaydet olarak kullanılıyor.  Şimdilik kaplı kalıyor kullanılmayacak.
                      MESSAGES INTO gt_messtab.



*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR gs_bdcdata.
  gs_bdcdata-program  = program.
  gs_bdcdata-dynpro   = dynpro.
  gs_bdcdata-dynbegin = 'X'.
  APPEND gs_bdcdata TO gt_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.

  CLEAR gs_bdcdata.
  gs_bdcdata-fnam = fnam.
  gs_bdcdata-fval = fval.
  APPEND gs_bdcdata TO gt_bdcdata.

ENDFORM.
