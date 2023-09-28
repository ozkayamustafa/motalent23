*&---------------------------------------------------------------------*
*& Include          ZOT_16_P_BATCH_INPUT_OOP_INC
*&---------------------------------------------------------------------*

INTERFACE lcl_main_inc.

  METHODS:
    bdc_dynpro
      IMPORTING
        program TYPE bdc_prog
        dynpro  TYPE bdc_dynr,

    bdc_field
      IMPORTING
        fnam TYPE fnam_____4
        fval TYPE bdc_fval.

*CLASS-METHODS.....
ENDINTERFACE.
