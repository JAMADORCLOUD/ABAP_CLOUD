CLASS zcl_88_solution_13_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_88_solution_13_3 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA flight  TYPE REF TO lcl_passenger_flight.

    TRY.
        flight = NEW #( i_carrier_id = 'SQ' ).
*                         i_connection_id = '0400' ). "First Instance
      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    flight->access_sorted( ).
    flight->access_hashed( ).
    out->write( |Done| ).

  ENDMETHOD.

ENDCLASS.
