*&---------------------------------------------------------------------*
*& Report zot_16_p_spor
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_spor.

INCLUDE zot_16_i_sport_top.

DATA: gv_random LIKE qf00-ran_int.

DATA gt_term TYPE TABLE OF gty_teams.


DATA(gv_i) = 0.
DO 4 TIMES.
  gv_i += 1.

  READ TABLE gt_dbteams INTO DATA(ls_term) WITH KEY id = gv_i.
  IF sy-subrc = 0.
    APPEND ls_term TO gt_term.
    DELETE gt_dbteams WHERE id = gv_i.
  ENDIF.

ENDDO.



LOOP AT gt_term INTO DATA(ls_dbt).
  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = 4
      ran_int_min   = 1
    IMPORTING
      ran_int       = gv_random
    EXCEPTIONS
      invalid_input = 1
      OTHERS        = 2.


  READ TABLE gt_term INTO DATA(ls_read_bag) WITH KEY id = gv_random.
  IF sy-subrc = 0.

    IF lines( gt_groupa ) < 1.
      APPEND ls_dbt-gv_team TO gt_groupa.
      DELETE gt_dbteams WHERE gv_bag = ls_read_bag-gv_bag.

    ELSEIF lines( gt_groupb ) < 1.
      APPEND ls_dbt-gv_team TO gt_groupb.
      DELETE gt_dbteams WHERE gv_bag = ls_read_bag-gv_bag.

    ELSEIF lines( gt_groupc ) < 1.
      APPEND ls_dbt-gv_team TO gt_groupc.
      DELETE gt_dbteams WHERE gv_bag = ls_read_bag-gv_bag.

    ELSEIF lines( gt_groupd ) < 1.
      APPEND ls_dbt-gv_team TO gt_groupd.
      DELETE gt_dbteams WHERE gv_bag = ls_read_bag-gv_bag.

    ENDIF.

  ENDIF.


ENDLOOP.

DO lines(  gt_dbteams ) TIMES.
LOOP AT gt_dbteams INTO DATA(ls_dbteams).
  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = 16
      ran_int_min   = 5
    IMPORTING
      ran_int       = gv_random
    EXCEPTIONS
      invalid_input = 5.

  READ TABLE gt_dbteams INTO DATA(ls_read) WITH KEY id = gv_random.
  IF sy-subrc = 0.

    IF ls_read-gv_bag NE ls_dbteams-gv_bag.
      IF ls_read-gv_country NE ls_dbteams-gv_country.
        IF lines( gt_groupa ) < 4.
          APPEND ls_read-gv_team TO gt_groupa.
          DELETE gt_dbteams WHERE id = ls_read-id.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.

ENDLOOP.
ENDDO.

DO lines(  gt_dbteams ) TIMES.
LOOP AT gt_dbteams INTO DATA(ls_dbteamss).
  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = 16
      ran_int_min   = 5
    IMPORTING
      ran_int       = gv_random
    EXCEPTIONS
      invalid_input = 5
      OTHERS        = 2.
  READ TABLE gt_dbteams INTO DATA(ls_readd) WITH KEY id = gv_random.
  IF sy-subrc = 0.

    IF ls_readd-gv_bag NE ls_dbteamss-gv_bag.
      IF ls_readd-gv_country NE ls_dbteamss-gv_country.
        IF lines( gt_groupb ) < 4.
          APPEND ls_readd-gv_team TO gt_groupb.
          DELETE gt_dbteams WHERE id = ls_readd-id.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDLOOP.

ENDDO.




DO lines(  gt_dbteams ) TIMES.
  LOOP AT gt_dbteams INTO DATA(ls_dbteamss_c).
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 16
        ran_int_min   = 5
      IMPORTING
        ran_int       = gv_random
      EXCEPTIONS
        invalid_input = 5
        OTHERS        = 2.

    READ TABLE gt_dbteams TRANSPORTING NO FIELDS
                        INDEX gv_random.
    READ TABLE gt_dbteams INTO DATA(ls_readd_c) WITH KEY id = gv_random.
    IF sy-subrc = 0.

      IF ls_readd_c-gv_bag NE ls_dbteamss_c-gv_bag.
        IF ls_readd_c-gv_country NE ls_dbteamss_c-gv_country.
          IF lines( gt_groupc ) < 4.
            APPEND ls_readd_c-gv_team TO gt_groupc.
            DELETE gt_dbteams WHERE id = ls_readd_c-id.
          ENDIF.
        ENDIF.
      ENDIF.


    ENDIF.

  ENDLOOP.
ENDDO.


DATA gt_ref_groupd TYPE TABLE OF gty_teams.
move gt_dbteams to gt_ref_groupd.


LOOP AT gt_ref_groupd INTO DATA(ls_ref).
   APPEND ls_ref-gv_team TO gt_groupd.
   DELETE gt_dbteams WHERE id = ls_ref-id.
ENDLOOP.


*  LOOP AT gt_dbteams INTO DATA(ls_dbteamss_d).
*    CALL FUNCTION 'QF05_RANDOM_INTEGER'
*      EXPORTING
*        ran_int_max   = 16
*        ran_int_min   = 5
*      IMPORTING
*        ran_int       = gv_random
*      EXCEPTIONS
*        invalid_input = 5.
*
*    READ TABLE gt_dbteams INTO DATA(ls_readd_d) WITH KEY id = gv_random.
*    IF sy-subrc = 0.
*
*      IF ls_readd_d-gv_bag NE ls_dbteamss_d-gv_bag.
*        IF ls_readd_d-gv_country NE ls_dbteamss_d-gv_country.
*          IF lines( gt_groupc ) < 4.
*            APPEND ls_readd_d-gv_team TO gt_groupd.
*            DELETE gt_dbteams WHERE id = ls_readd_d-id.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*
*
*    ENDIF.
*
*  ENDLOOP.







cl_demo_output=>write( gt_groupa ).
cl_demo_output=>write( gt_groupb ).
cl_demo_output=>write( gt_groupc ).
cl_demo_output=>write( gt_groupd ).
cl_demo_output=>display( ).
