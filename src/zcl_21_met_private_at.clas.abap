CLASS zcl_21_met_private_at DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_21_met_private_at IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA connection  TYPE REF TO lcl_connection.
    DATA connections  TYPE TABLE OF REF TO lcl_connection.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.

    connection = NEW #(  ). "First Instance

    connection->set_attributes(
      EXPORTING
        i_carrier_id    = 'LH'
        i_connection_id = '0400'
    ).

*        connection->carrier_id    = 'LH'.
*        connection->connection_id = '0400'.

    APPEND connection TO connections.

    connection = NEW #(  ). "Second Instance

    connection->set_attributes(
      EXPORTING
        i_carrier_id    = 'AA'
        i_connection_id = '0017'
    ).

*        connection->carrier_id    = 'AA'.
*        connection->connection_id = '0017'.

     APPEND connection TO connections. "comment only First Value

    LOOP AT connections INTO connection.

      connection->get_attributes(
        IMPORTING
          e_carrier_id    = carrier_id
          e_connection_id = connection_id ).

      out->write( |Flight Connection { carrier_id } { connection_id }| ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
