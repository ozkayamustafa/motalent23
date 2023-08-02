*&---------------------------------------------------------------------*
*& Report zot_16_p_sip_kirilim
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_sip_kirilim.

INCLUDE zot_16_i_sip_kirilim_top.
INCLUDE zot_16_i_sip_kirilim_sel.
INCLUDE zot_16_i_sip_kirilim_main.


INITIALIZATION.
  go_main = lcl_main_controller=>get_instance( ).


AT SELECTION-SCREEN.



START-OF-SELECTION.


*go_main->set_handlers( ).
go_main->display_grid( ).
