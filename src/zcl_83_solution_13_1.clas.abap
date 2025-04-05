CLASS zcl_83_solution_13_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_83_solution_13_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    DATA rr_result TYPE i.
    DATA rr_result TYPE p LENGTH 16 DECIMALS 2.
    DATA flight  TYPE REF TO lcl_passenger_flight.
    DATA passenger_flights TYPE TABLE OF /dmo/flight.

    TRY.
        flight = NEW #( i_carrier_id = 'SQ' ).
*                         i_connection_id = '0400' ). "First Instance

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    SELECT FROM /dmo/flight FIELDS * INTO TABLE @passenger_flights.

*    DATA(rr_result) =       REDUCE #(
    rr_result = REDUCE #( INIT i = 0 FOR ls_flight IN passenger_flights
                          NEXT i += flight->get_free_seats( ) ) / lines( passenger_flights ).
*                          NEXT i = i + flight->get_free_seats( ) ) / lines( passenger_flights ).

* 4O CANTIDAD DE REGISTROS ENCONTRADOS EN TABLA
* 5 EL VALOR SEAT * 40 VUELTAS = i = 200
* RESULTADO = 200/40 = 5 Average

    TRY.
        out->write( data = flight->get_output( ) name = `Example for text symbols` ).

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
