CLASS zcl_99_interface_use DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_99_interface_use IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA car_rental TYPE REF TO lcl_car_rental.
    DATA airline TYPE REF TO lcl_airline.
    DATA agency_tab TYPE TABLE OF REF TO lcl_travel_agency.
    DATA agency TYPE REF TO lcl_travel_agency.

    DATA partner_aux TYPE REF TO lif_partner.
*    DATA partners TYPE TABLE OF REF TO lif_partner.
    DATA partners TYPE lcl_travel_agency=>tt_partner_ref.

    agency = NEW #( ).

    car_rental = NEW #( iv_name = 'ABAP Autos' iv_contact_person = 'Mr Jones' iv_has_hgv = 'X' ).

    agency->add_partner( car_rental ).

*    airline = NEW #( iv_name = 'Fly Happy' iv_contact_person = 'Ms Meyer' iv_city = 'Frankfurt' ).
*    agency->add_partner( airline ).

*   partner_aux = agency. "3

*    agency->get_partners( IMPORTING et_partners = partners ).

    LOOP AT partners INTO DATA(partner).

*    LOOP AT agency_tab INTO DATA(partner). "1 "2
*   LOOP AT agency->get_partners( ) INTO DATA(partner). "3

      out->write( partner->get_partner_attributes( ) ). "1
*       out->write( partner->lif_partner~get_partner_attributes( ) ) "2.
*      out->write( partner_aux->get_partner_attributes( ) ). #3

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
