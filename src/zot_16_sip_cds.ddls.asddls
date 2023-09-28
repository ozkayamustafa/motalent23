@AbapCatalog.sqlViewName: 'ZSIPARIS_VIEW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Sipariş CDS'
define view ZOT_16_sip_cds
  as select from vbap
{
  vbeln,
  matnr,
  sum(vbap.netwr)  as total_netwr,
  sum(vbap.kwmeng) as total_kwmeng


}

group by
  vbeln,
  matnr
