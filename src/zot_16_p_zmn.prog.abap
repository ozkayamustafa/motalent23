*&---------------------------------------------------------------------*
*& Report zot_16_p_zmn
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_zmn.

DATA gs_zmn TYPE zot_16_t_zmn.
SELECT-OPTIONS: s_id FOR gs_zmn-zid.


START-OF-SELECTION.

  DATA: lv_date1     TYPE dats,
        lv_date2     TYPE dats,
        lv_time1     TYPE tims,
        lv_time2     TYPE tims,
        lv_days_diff TYPE i,
        lv_years     TYPE i,
        lv_months    TYPE i,
        lv_days      TYPE i,
        lv_seconds   TYPE i.

  SELECT b_date,
         b_hour,
         f_date,
         f_hour
       FROM zot_16_t_zmn WHERE zid IN @s_id INTO TABLE @DATA(lt_zmnn).


  LOOP AT lt_zmnn INTO DATA(ls_date).

    lv_date1 = ls_date-b_date.
    lv_date2 = ls_date-f_date.
    lv_time1 = ls_date-b_hour.
    lv_time2 = ls_date-f_hour.

    lv_days_diff = CONV int4( lv_date2 - lv_date1 ).

    lv_years = lv_days_diff DIV 365.
    lv_days_diff = lv_days_diff MOD 365.


    lv_months = lv_days_diff DIV 30.
    lv_days = lv_days_diff.
**********************************************************************  YIl, Ay ve Gün Hesaplama fonksiyonu
*    CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*      EXPORTING
*        i_date_from = lv_date1
*        i_date_to   = lv_date2
*      IMPORTING
*        e_days      = lv_days
*        e_months    = lv_months
*        e_years     = lv_years.
**********************************************************************  Saat, Dakika ve Saniye Hesaplama fonksiyonu
    CALL FUNCTION 'SWI_DURATION_DETERMINE'
      EXPORTING
        start_date = lv_date1
        end_date   = lv_date2
        start_time = lv_time1
        end_time   = lv_time2
      IMPORTING
        duration   = lv_seconds.



    DATA(lv_s) = lv_seconds.
    DATA(lv_minutes) = lv_s DIV 60.
    DATA(lv_hour) = lv_s DIV 3600.

    IF sy-index MOD 6 = 0.
      NEW-LINE.
    ENDIF.
*    lv_years  = lv_years  - 1.
*    lv_months  = lv_months - 1.
    IF lv_years NE 0.
      WRITE: |{ lv_years  } YIL|.
    ENDIF.
    IF lv_months NE 0.
      WRITE: |{ lv_months  } AY|.
    ENDIF.
    IF lv_days NE 0.
      WRITE: |{ lv_days } GÜN|.
    ENDIF.
    IF lv_hour NE 0.
      WRITE: |{ lv_hour } SAAT|.
    ENDIF.
    IF lv_minutes NE 0.
      WRITE: |{ lv_minutes } DAKİKA|.
    ENDIF.
    IF lv_s NE 0.
      WRITE: |{ lv_s } SANİYE|.
    ENDIF.
*     WRITE: | { lv_years } YIL, { lv_months } AY, { lv_days } GÜN |.

  ENDLOOP.
