FUNCTION zot_16_fm_rfc_malzeme.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MATNR) TYPE  MARA-MATNR
*"  EXPORTING
*"     VALUE(EV_MATERIAL_INFO) TYPE  ZOT_16_S_MATERIAL_INFO
*"     VALUE(EV_MATERIAL_MARD) TYPE  ZOT_16_TT_MB_MARD
*"     VALUE(EV_MATERIAL_RESULT) TYPE  ZOT_16_S_MATERIAL_RESULT
*"----------------------------------------------------------------------
  DATA: lt_mb TYPE TABLE OF zot_16_s_material_info,
        ls_mb TYPE zot_16_t_mb.


  DATA lt_mard TYPE zot_16_tt_mb_mard.
  DATA(lv_mantr) = matnr.

  SELECT
      mara~matnr,
      makt~maktx,
      mara~mtart,
      mara~meins
      FROM mara
      INNER JOIN makt ON makt~matnr = mara~matnr
      INTO CORRESPONDING FIELDS OF TABLE @lt_mb
      WHERE mara~matnr = @lv_mantr
            AND makt~spras = @sy-langu.

  SELECT
      werks,
      lgort,
      labst
      FROM mard
      INTO CORRESPONDING FIELDS OF TABLE @lt_mard
      WHERE matnr = @lv_mantr
            AND labst > 0.


  IF lt_mb IS NOT INITIAL.
    READ TABLE lt_mb INTO DATA(ls_material) INDEX 1.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ls_material TO ev_material_info.
      ev_material_result-resultcode = '0'.
      ev_material_result-resulttype = 'OK'.
      ev_material_result-resultdescription = 'Kayıt Başarılı'.
    ELSE.
      ev_material_result-resultcode = '0'.
      ev_material_result-resulttype = 'OK'.
      ev_material_result-resultdescription = 'Kayıt Atarken Hata Oluştu'.
    ENDIF.
  ELSE.
    ev_material_result-resultcode = '1'.
    ev_material_result-resulttype = 'ERROR'.
    ev_material_result-resultdescription = 'Kayıt Boş'.
  ENDIF.

  IF lt_mard IS NOT INITIAL.
    ev_material_mard = lt_mard.
    IF sy-subrc EQ 0.
      ev_material_result-resultcode = '0'.
      ev_material_result-resulttype = 'OK'.
      ev_material_result-resultdescription = 'Kayıt Başarılı'.
    ENDIF.
  ELSE.
    ev_material_result-resultcode = '1'.
    ev_material_result-resulttype = 'ERROR'.
    ev_material_result-resultdescription = 'Kayıt Boş'.
  ENDIF.






ENDFUNCTION.
