@AbapCatalog.sqlViewName: 'ZTESLIMAT_VIEW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Teslimat cds'
define view ZOT_16_del_cds
  as select from lips
    inner join   ZOT_16_sip_cds as scds on  lips.vgbel = scds.vbeln
                                        and lips.matnr = scds.matnr
    inner join   likp                   on lips.vbeln = likp.vbeln
    inner join   kna1                   on likp.kunnr = kna1.kunnr
{
  key vgbel,
      scds.matnr,
      scds.total_kwmeng,
      scds.total_netwr,
      lfimg,

      concat(kna1.name1, kna1.ort01) as adres,

      case
          when lips.lfimg > 5 then 'BUYUK TESLIMAT'
          when lips.lfimg < 5 or lips.lfimg =  5 then 'KUCUK TESLIMAT'
          end                        as teslimat_tip,

      division(lips.lfimg , 5, 2)    as sonuc
      
      

}
