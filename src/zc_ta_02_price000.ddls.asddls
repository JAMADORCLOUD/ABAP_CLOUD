@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TA_02_PRICE000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TA_02_PRICE000
{
  key Uuid,
  Carrid,
  Price,
  @Semantics.currencyCode: true
  CurrencyCode,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
