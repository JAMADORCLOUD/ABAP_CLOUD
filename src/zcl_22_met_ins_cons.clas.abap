CLASS zcl_22_met_ins_cons DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_22_met_ins_cons IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA connection  TYPE REF TO lcl_connection.
    DATA connections  TYPE TABLE OF REF TO lcl_connection.

*    DATA carrier_id    TYPE /dmo/carrier_id.
*    DATA connection_id TYPE /dmo/connection_id.

    TRY.
        connection = NEW #( carrier_id = 'LH'
                            connection_id = '0400' ). "First Instance

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Creating instance failed` ).
    ENDTRY.


    TRY.
        connection = NEW #( carrier_id = 'AA'
                            connection_id = '0017' ). "Second Instance

        APPEND connection TO connections.

      CATCH cx_abap_invalid_value.
        out->write( `Creating instance failed` ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
