CLASS zcl_23_encapsulation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_23_encapsulation IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA connection  TYPE REF TO lcl_connection.
    DATA connections  TYPE TABLE OF REF TO lcl_connection.


    TRY.
        connection = NEW #( carrier_id = 'LH'
                            connection_id = '0400' ). "First Instance

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( 'Method call failed' ).
    ENDTRY.


    TRY.
        connection = NEW #( carrier_id = '  '
                            connection_id = '0000' ). "Second Instance

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Method call failed` ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
