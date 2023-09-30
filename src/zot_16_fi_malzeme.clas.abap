CLASS zot_16_fi_malzeme DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA gv_matnr TYPE mcha-matnr.
    CONSTANTS gv_werks TYPE mcha-werks VALUE 1710 ##NO_TEXT.

    METHODS constructor
      IMPORTING
        VALUE(v_matnr) TYPE mcha-matnr .
    METHODS display_alv .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS fetch_data
      IMPORTING
        VALUE(matnr)     TYPE mcha-matnr
        VALUE(werks)     TYPE mcha-werks
      RETURNING
        VALUE(gt_return) TYPE zot_16_tt_mcha .
ENDCLASS.



CLASS ZOT_16_FI_MALZEME IMPLEMENTATION.


  METHOD constructor.
    gv_matnr = v_matnr.
  ENDMETHOD.


  METHOD display_alv.
    DATA mt_alv TYPE REF TO cl_salv_table.

    DATA(gt_data) = fetch_data( matnr = gv_matnr werks = gv_werks ).
    CALL METHOD cl_salv_table=>factory(
      IMPORTING
        r_salv_table = mt_alv                           " Basis Class Simple ALV Tables
      CHANGING
        t_table      = gt_data
    ).
*    CATCH cx_salv_msg. " ALV: General Error Class with Message


    mt_alv->display( ).

  ENDMETHOD.


  METHOD fetch_data.

    SELECT
      matnr,
      werks,
      charg
      FROM mcha
        INTO CORRESPONDING FIELDS OF TABLE @gt_return
      WHERE matnr = @matnr
        AND werks = @werks.
  ENDMETHOD.
ENDCLASS.
