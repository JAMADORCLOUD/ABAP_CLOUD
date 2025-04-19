CLASS zcl_b_100_solution_15_4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_b_100_solution_15_4 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA days_later TYPE i.
    DATA days_later_aux TYPE i.

    DATA carrier TYPE REF TO lcl_carrier.
    DATA pass_flight TYPE REF TO lcl_passenger_flight.
    DATA cargo_flight TYPE REF TO lcl_CARGO_FLIGHT.

    TRY.
        carrier = NEW #( i_carrier_id = 'SQ'
                                  i_connection_id = '0012'
                                  i_flight_date = cl_abap_context_info=>get_system_date( ) ).

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.


    TRY.
        pass_flight = NEW #( i_carrier_id = 'SQ'
                                  i_connection_id = '0012'
                                  i_flight_date = cl_abap_context_info=>get_system_date( ) ).

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    days_later = 8.

    out->write( name = |Found a suitable passenger flight in { days_later } days:|
*               data = pass_flight->get_description( ) ).
*               data = pass_flight->lif_output~get_output( ) ).
                 data = pass_flight->get_output( ) ).

    TRY.
        cargo_flight = NEW #( i_carrier_id = 'SQ'
                                  i_connection_id = '0012'
                                  i_flight_date = cl_abap_context_info=>get_system_date( ) ).

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    days_later_aux = 10.

    out->write( name = |Found a suitable cargo flight in { days_later_aux } days:|
*              data = cargo_flight->get_description( ) ).
              data = cargo_flight->lif_output~get_output( ) ).
*                data = cargo_flight->get_output( ) ).



    out->write( |Done| ).

  ENDMETHOD.

ENDCLASS.
