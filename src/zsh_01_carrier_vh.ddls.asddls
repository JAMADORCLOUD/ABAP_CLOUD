@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help Carrid'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSH_01_CARRIER_VH as 
select from /dmo/carrier {

  @UI.lineItem: 
  [{ position: 10, importance: #HIGH }]
  key carrier_id as CarrierId,    

  @UI.lineItem: 
  [{ position: 20, importance: #HIGH }]
  key name as Name      
    
}
