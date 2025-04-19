CLASS zcl_96_solution_15_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_96_solution_15_2 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  DATA carrier TYPE REF TO lcl_carrier.

    TRY.
        carrier = NEW #( i_carrier_id = 'SQ'
                                  i_connection_id = '0012'
                                  i_flight_date = cl_abap_context_info=>get_system_date( ) ).

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    out->write( |Done| ).

  ENDMETHOD.

ENDCLASS.
