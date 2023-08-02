*&---------------------------------------------------------------------*
*& Report zot_16_open_sql
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zot_16_open_sql.

type-pools : slis. "ALV programlama için kullanılan veri türlerini içerir

PARAMETERS : p_tab type dd02l-tabname. "  dd02l-tabname -> Tablo Adı bilgilerini depolayan
data : ref_tabletype  type REF TO cl_abap_tabledescr,
       ref_rowtype TYPE REF TO cl_abap_structdescr.

field-symbols  : <lt_table>  type   standard TABLE ,
       <fwa> type any,
       <field> type abap_compdescr.

data : lt_fcat type lvc_t_fcat,
       ls_fcat type lvc_s_fcat,
       lt_fldcat type SLIS_T_FIELDCAT_ALV,
       ls_fldcat like line of lt_fldcat.

data : ref_data type REF TO data,
        ref_wa type ref to  data.

ref_rowtype ?= cl_abap_typedescr=>DESCRIBE_BY_name( p_name = p_tab ).

TRY.
CALL METHOD cl_abap_tabledescr=>create
  EXPORTING
    p_line_type  = ref_rowtype
  receiving
    p_result     = ref_tabletype.

 CATCH cx_sy_table_creation .
 write : / 'Object Not Found'.
ENDTRY.

*creating object.
create data ref_data type handle ref_tabletype.
create data ref_wa type handle ref_rowtype.

*value assignment.
ASSIGN ref_data->* to <lt_table>.
assign ref_wa->* to <fwa>.

loop at ref_rowtype->components ASSIGNING <field>.

  ls_fcat-fieldname = <field>-name.
  ls_fcat-ref_table = p_tab.
  append ls_fcat to lt_fcat.

  if lt_fldcat[] is  INITIAL.
    ls_fldcat-fieldname = 'CHECKBOX'.
    ls_fldcat-checkbox = 'X'.
    ls_fldcat-edit = 'X'.
    ls_fldcat-seltext_m = 'Checkbox'.
    append ls_fldcat to lt_fldcat.
  endif.
  clear ls_fldcat.

  ls_fldcat-fieldname = <field>-name.
  ls_fldcat-ref_tabname = p_tab.
  append ls_fldcat to lt_fldcat.

endloop.

loop at lt_fldcat into ls_fldcat.

  if sy-tabix = 1.
    ls_fldcat-checkbox = 'X'.
    ls_fldcat-edit = 'X'.

modify lt_fldcat FROM ls_fldcat
    TRANSPORTING checkbox edit.
endif.
endloop.

CALL METHOD cl_alv_table_create=>create_dynamic_table
  EXPORTING
    it_fieldcatalog           = lt_fcat[]
  IMPORTING
    ep_table                  = ref_data.

assign ref_data->* to <lt_table>.

select * FROM (p_tab) into table <lt_table>.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   IT_FIELDCAT                   =     lt_fldcat[]
  TABLES
    t_outtab                          =    <lt_table>.
