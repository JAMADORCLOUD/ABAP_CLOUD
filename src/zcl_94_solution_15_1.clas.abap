CLASS zcl_94_solution_15_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_94_solution_15_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA flight  TYPE REF TO lcl_flight.
    DATA passenger_flight TYPE REF TO lcl_passenger_flight.
    DATA cargo_flight TYPE REF TO lcl_cargo_flight.

    TRY.
        flight = NEW #( i_carrier_id = 'SQ'
                        i_connection_id = '0012'
                        i_flight_date = cl_abap_context_info=>get_system_date( ) ).


      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    TRY.
        passenger_flight = NEW #( i_carrier_id = 'SQ'
                                  i_connection_id = '0012'
                                  i_flight_date = cl_abap_context_info=>get_system_date( ) ).


      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    TRY.
        cargo_flight = NEW #( i_carrier_id = 'SQ'
                                  i_connection_id = '0012'
                                  i_flight_date = cl_abap_context_info=>get_system_date( ) ).


      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    out->write( |Done| ).

  ENDMETHOD.

ENDCLASS.
