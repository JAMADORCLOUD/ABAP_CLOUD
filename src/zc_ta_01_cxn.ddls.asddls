@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TA_01_CXN
  provider contract transactional_query
  as projection on ZR_TA_01_CXN
{
  key Uuid,
@Consumption.valueHelpDefinition: 
[ { entity:{ element: 'CarrierId' , 
             name: 'ZSH_01_CARRIER_VH'
} }]  
  Carrid,
  Connid,
  AirportFrom,
  CityFrom,
  CountryFrom,
  AirportTo,
  CityTo,
  CountryTo,
  Price,
  @Semantics.currencyCode: true
  CurrencyCode,  
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
