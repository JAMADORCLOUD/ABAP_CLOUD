@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Get Airports'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_01_AIRPORTS 
  as select from /dmo/airport
{
 key airport_id as AirportID,
     name       as Name,
     city       as City,
     country    as Country    
}
