*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

INTERFACE lif_partner.

    TYPES: BEGIN OF ts_attributes,
             name  TYPE string,
             value TYPE string,
           END OF ts_attributes,
* declare table - do not allow the same attribute to be used more than once
           tt_attributes TYPE SORTED TABLE OF ts_attributes WITH UNIQUE KEY name.

    METHODS: get_partner_attributes RETURNING VALUE(rt_Attributes) TYPE tt_attributes.

*  METHODS get_partner_attributes.

ENDINTERFACE.

CLASS lcl_travel_Agency DEFINITION.

  PUBLIC SECTION.

    INTERFACES lif_Partner.

    TYPES: BEGIN OF ts_partner,
             name  TYPE string,
             value TYPE string,
           END OF ts_partner,
           tt_partner TYPE SORTED TABLE OF ts_partner WITH UNIQUE KEY name.

  METHODS add_partner
   IMPORTING i_rental   TYPE REF TO lif_Partner
   RETURNING VALUE(rt_partner) TYPE tt_partner.

    TYPES: tt_partner_ref TYPE TABLE OF REF TO lif_partner.

    METHODS get_partners EXPORTING et_partners TYPE tt_partner_ref.

    DATA partners TYPE TABLE OF REF TO lif_partner.

*  METHODS get_partners
*   RETURNING VALUE(rt_partners) TYPE tt_partner.

    TYPES: BEGIN OF ts_attributes,
             name  TYPE string,
             value TYPE string,
           END OF ts_attributes,
* declare table - do not allow the same attribute to be used more than once
           tt_attributes TYPE SORTED TABLE OF ts_attributes WITH UNIQUE KEY name.

    METHODS: get_partner_attributes RETURNING VALUE(rt_Attributes) TYPE tt_attributes.

ENDCLASS.

CLASS lcl_travel_agency IMPLEMENTATION.

  METHOD add_partner.

  ENDMETHOD.

  METHOD get_partners.

   et_partners = partners.

  ENDMETHOD.

  METHOD lif_partner~get_partner_attributes.

    rt_attributes = VALUE #( ( name = 'MANUFACTURER' value = 'JESUS' )
    ( name = 'TYPE' value = 'B' ) ) .

  ENDMETHOD.

  METHOD get_partner_attributes.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_airline DEFINITION.

  PUBLIC SECTION.

    INTERFACES lif_Partner.

    TYPES: BEGIN OF ts_detail,
             name  TYPE string,
             value TYPE string,
           END OF ts_detail,
           tt_Details TYPE SORTED TABLE OF ts_detail WITH UNIQUE KEY name.

    METHODS get_details RETURNING VALUE(rt_details) TYPE tt_details.

ENDCLASS.

CLASS lcl_car_Rental DEFINITION.

  PUBLIC SECTION.

    INTERFACES lif_Partner.

    TYPES: BEGIN OF ts_info,
             name  TYPE c LENGTH 20,
             value TYPE c LENGTH 20,
           END OF ts_info,
           tt_Info TYPE SORTED TABLE OF ts_info WITH UNIQUE KEY name.

* Methods
    METHODS constructor
      IMPORTING
        iv_name    TYPE string
        iv_contact_person TYPE string
        iv_has_hgv TYPE string.

    METHODS get_information RETURNING VALUE(rt_details) TYPE tt_info.

ENDCLASS.

CLASS lcl_airline IMPLEMENTATION.

  METHOD get_details.

  ENDMETHOD.

  METHOD lif_partner~get_partner_attributes.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_car_rental IMPLEMENTATION.

METHOD constructor.

ENDMETHOD.

  METHOD get_information.

  ENDMETHOD.

  METHOD lif_partner~get_partner_attributes.

  ENDMETHOD.

ENDCLASS.
