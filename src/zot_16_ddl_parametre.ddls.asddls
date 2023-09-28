@AbapCatalog.sqlViewName: 'ZOT_16_VIEW_PRMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Parametreli CDS'
define view ZOT_16_DDL_PARAMETRE
    with parameters p_meins: meins
as select from mara
{
    matnr,
    matkl,
    mtart
}

where meins = $parameters.p_meins
