@AbapCatalog.sqlViewName: 'ZOT_16_VIEW_ASSO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Associations Kullanımı'
define view zot_16_ddl_associations
  as select from mara as mara
  association[0..*] to makt as _makt on mara.matnr = _makt.matnr
{
   mara.matnr,
   mara.bismt
   
 // _association_name // Make association public
}


//define view zot_16_ddl_associations
//  as select from    mara as mara
//    left outer join makt as makt on mara.matnr = makt.matnr
//{
//  mara.matnr
//
//  // _association_name // Make association public
//}
