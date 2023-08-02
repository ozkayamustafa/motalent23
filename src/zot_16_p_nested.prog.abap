*&---------------------------------------------------------------------*
*& Report zot_16_p_nested
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_p_nested.




DATA(lt_ogr) = VALUE zot_16_tt_ogn_not( (  student_id = '1'
                                           student_name = 'Mustafa'
                                           student_birth = '20.01.1998'
                                           student_dep = 'Bilgisayar Mühendisi'
                                           student_nots = VALUE zot_16_s_sinif(
                                            classnumnot1 = VALUE zot_16_s_ders(
                                               dersadi1 = VALUE zot_16_s_not(
                                                    vize1 = '20'
                                                    vize2 = '50'
                                                    final = '35'
                                                    butun = '50'
                                                )
                                              )
                                             )

   ) ).

cl_demo_output=>display( lt_ogr ).
