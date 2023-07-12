*&---------------------------------------------------------------------*
*& Report zot_16_abap_dictionary
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_abap_dictionary.

DATA: ls_personel   TYPE zot_16_s_personel,
      lt_personel   TYPE TABLE OF zot_16_s_personel.



lt_personel = VALUE #( (

id = 01
ad = 'Mustafa'
yas = 25
departman = 'ABAP'
unvan = 'One Talent'
ekip = VALUE zot_16_tt_ekip( (
  id = 2
  ad_ = 'Mustafa'

) )
) ).
