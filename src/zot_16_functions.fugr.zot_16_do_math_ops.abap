FUNCTION zot_16_do_math_ops.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_NUMBER1) TYPE  I
*"     VALUE(IV_NUMBER2) TYPE  I
*"     VALUE(IV_LANG) TYPE  I
*"  EXPORTING
*"     REFERENCE(GV_RESULT) TYPE  I
*"----------------------------------------------------------------------
CASE iv_lang.
    WHEN 0.
    WHEN 1.
    WHEN 2.
    WHEN 3.
    WHEN OTHERS.
ENDCASE.

ENDFUNCTION.
