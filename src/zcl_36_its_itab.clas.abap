    CLASS zcl_36_its_itab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_36_its_itab IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA connection  TYPE REF TO lcl_connection.

    TRY.
        connection = NEW #( carrier_id = 'LH'
                            connection_id = '0400' ). "First Instance


      CATCH cx_abap_invalid_value.
        out->write( `Creating instance failed` ).
    ENDTRY.

    out->write( data = connection->get_output( )
                name = `Example Complex Internal Table` ).

  ENDMETHOD.

ENDCLASS.
