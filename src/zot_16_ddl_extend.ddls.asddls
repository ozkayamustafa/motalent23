@AbapCatalog.sqlViewName: 'ZOT_16_V_EXTND'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extend Kullanımı için CDS'
define view ZOT_16_DDL_EXTEND as select from zot_16_t_ext1 as ex1
{
    ex1.pers_id
}
