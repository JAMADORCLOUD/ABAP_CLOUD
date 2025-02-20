    CLASS zcl_31_str_data_object DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_31_str_data_object IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA connection  TYPE REF TO lcl_connection.
*    DATA connections  TYPE TABLE OF REF TO lcl_connection.

    TRY.
        connection = NEW #( i_carrier_id = 'LH'
                            i_connection_id = '0400' ). "First Instance

*        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.

    out->write( data = connection->get_output( )
                name = `Basis SELECT CDS SQL Example` ).

  ENDMETHOD.

ENDCLASS.
