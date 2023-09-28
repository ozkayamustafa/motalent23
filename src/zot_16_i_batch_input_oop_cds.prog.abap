*&---------------------------------------------------------------------*
*& Include          ZOT_16_I_BATCH_INPUT_OOP_CDS
*&---------------------------------------------------------------------*
CLASS lcl_main_batch_input DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS
      getInstance
        RETURNING VALUE(ro_instance) TYPE REF TO lcl_main_batch_input.

    INTERFACES lcl_main_inc.

    METHODS
      call_transation.

  PRIVATE SECTION.
    DATA: mt_bdcdata TYPE TABLE OF bdcdata,
          ms_bdcdata TYPE bdcdata,
          mt_messtab TYPE TABLE OF bdcmsgcoll.

    CLASS-DATA
       mo_main  TYPE REF TO lcl_main_batch_input.

ENDCLASS.


CLASS lcl_main_batch_input IMPLEMENTATION.

  METHOD getInstance.
    IF mo_main IS INITIAL.
      mo_main = NEW #( ).
    ENDIF.
    ro_instance = mo_main.
  ENDMETHOD.


  METHOD  lcl_main_inc~bdc_dynpro.


    ms_bdcdata-program  = program.
    ms_bdcdata-dynpro   = dynpro.
    ms_bdcdata-dynbegin = 'X'.
    APPEND ms_bdcdata TO mt_bdcdata.
    CLEAR ms_bdcdata.
  ENDMETHOD.

  METHOD  lcl_main_inc~bdc_field.


    ms_bdcdata-fnam = fnam.
    ms_bdcdata-fval = fval.
    APPEND ms_bdcdata TO mt_bdcdata.
    CLEAR ms_bdcdata.
  ENDMETHOD.



  METHOD call_transation.
    CALL TRANSACTION 'MM01' WITH AUTHORITY-CHECK USING mt_bdcdata
                    MODE   'N'   "A, N veya E değerleri veriyoruz. A: tüm adımları göster, N: arka planda yap adımları  E: Hataları göster
*                       UPDATE CUPDATE   "A veya S var.  A: kaydetme   S: Kaydet olarak kullanılıyor.  Şimdilik kaplı kalıyor kullanılmayacak.
                    MESSAGES INTO mt_messtab.

  ENDMETHOD.


ENDCLASS.



DATA go_main TYPE REF TO lcl_main_batch_input.
