FUNCTION zot_16_fm_web_service_city.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CITY_ID) TYPE  ZOT_16_E_CITY_ID
*"     VALUE(CITY_NAME) TYPE  ZOT_16_E_CITY_NAME
*"  EXPORTING
*"     VALUE(EV_SUCCES) TYPE  XFELD
*"     VALUE(EV_MESSAGE) TYPE  BAPI_MSG
*"----------------------------------------------------------------------

  DATA ls_city TYPE zot_16_t_city.

  ls_city-city_id = city_id.
  ls_city-city_name = city_name.
  ls_city-uname = sy-uname.
  ls_city-datum = sy-datum.
  ls_city-uzeit = sy-uzeit.

  SELECT COUNT(*) FROM zot_16_t_city
      WHERE city_id = ls_city-city_id.

  IF sy-subrc EQ 0.
    ev_succes = abap_false.
    ev_message = 'Kayıt databasede mevcut'.
  ELSE.
    INSERT zot_16_t_city FROM ls_city.
    IF sy-subrc EQ 0.
      COMMIT WORK.
      ev_succes = abap_true.
      ev_message = 'Kayıt Başarılı'.
    ELSE.
      ROLLBACK WORK.
      ev_succes = abap_false.
      ev_message = 'Kaydedilirken hata oluştu'.

    ENDIF.
  ENDIF.




ENDFUNCTION.
