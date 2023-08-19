*&---------------------------------------------------------------------*
*& Report ZOT_16_P_OOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_oop.


PARAMETERS: a1 TYPE int4,
            a2 TYPE int4.

DATA gv_sum TYPE int4.
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS
      sum_numbers.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD sum_numbers.
    gv_sum = a1 + a2.
    cl_demo_output=>display( gv_sum ).
  ENDMETHOD.
ENDCLASS.
DATA: go_main TYPE REF TO lcl_main.



INITIALIZATION.
go_main = NEW lcl_main( ).

START-OF-SELECTION.
go_main->sum_numbers( ).
