@AbapCatalog.sqlViewName: 'ZOT_16_CDS_LOG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log Tablosunun CDS'
define view zot_16_ddl_log
  as select from zot_16_t_log
{

 i_date
  
}
    
//union select from zot_16_ddl_log  /* yeni bir tablo olması lazım */ 
//{
//   // i_date
//}
