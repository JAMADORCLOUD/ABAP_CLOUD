CLASS zcl_60_string_pro_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_60_string_pro_func IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA carrier  TYPE REF TO lcl_carrier.

    TRY.
        carrier = NEW #( i_carrier_id = 'SQ' ).
*                         i_connection_id = '0400' ). "First Instance

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    out->write( data = carrier->get_output( )
                name = `Example for text symbols` ).

  ENDMETHOD.

ENDCLASS.
