*&---------------------------------------------------------------------*
*& Report ZOT_16_P_FLIGHT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZOT_16_P_FLIGHT.






  DATA : l_fmname     TYPE funcname,
         l_params     TYPE sfpoutputparams,
         l_docparams  TYPE sfpdocparams,
         l_formoutput TYPE fpformoutput.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZOT_16_AF_FLIGHT'
    IMPORTING
      e_funcname = l_fmname
*     E_INTERFACE_TYPE           =
    .


*  l_params-getpdf = 'X'.
  l_params-nodialog = 'X'.
  l_params-preview = 'X'.
  l_params-dest    = 'LP01'.


  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = l_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  l_docparams-langu = 'T'.

  CALL FUNCTION l_fmname
    EXPORTING
      /1bcdwb/docparams  = l_docparams
      br_barkod          = '123456789'
    IMPORTING
      /1bcdwb/formoutput = l_formoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
