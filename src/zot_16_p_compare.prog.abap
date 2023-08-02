*&---------------------------------------------------------------------*
*& Report zot_16_p_compare
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_compare.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_data1 TYPE char6,
              p_data2 TYPE char6,
              p_data3 TYPE char6,
              p_data4 TYPE char6,
              p_data5 TYPE char6.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  DATA gt_term TYPE TABLE OF char6.
  DATA gt_last TYPE char6.
  DATA gt_same TYPE TABLE OF char6.
  DATA gt_diff TYPE TABLE OF char6.

  APPEND p_data1 TO gt_term.
  APPEND p_data2 TO gt_term.
  APPEND p_data3 TO gt_term.
  APPEND p_data4 TO gt_term.
  APPEND p_data5 TO gt_term.




*  gt_last = p_data1.
*  SORT gt_term DESCENDING.

*  LOOP AT gt_term INTO DATA(ls_term).
*      gt_last = gt_term[ sy-index + 1 ].
*      FIND gt_last IN ls_term.
*      if sy-subrc = 0.
*        APPEND ls_term TO gt_same.
*        else.
*           APPEND ls_term TO gt_diff.
*      ENDIF.
*
**    IF gt_last IS INITIAL.
**      gt_last = ls_term.
**    ELSE.
**      IF ls_term CS gt_last  AND ls_term CP gt_last.
**        APPEND ls_term TO gt_same.
**      ELSE.
**        APPEND ls_term TO gt_diff.
**      ENDIF.
**      gt_last = ls_term.
**    ENDIF.
*
*  ENDLOOP.

*  LOOP AT gt_term INTO DATA(ls_term).
*     gt_last = gt_term[ sy-index + 1 ].
*
*    IF gt_last IS INITIAL.
*      gt_last = ls_term.
*    ELSE.
*        LOOP AT gt_term INTO DATA(lv_check) WHERE TABLE_LINE BETWEEN ls_term AND gt_last.
*                    APPEND lv_check TO gt_same.
*        ENDLOOP.
*
*    ENDIF.
*
*  ENDLOOP.


  cl_demo_output=>write( gt_same ).
  cl_demo_output=>write( gt_diff ).
  cl_demo_output=>display(  ).
