CLASS zcl_15_global DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_15_global IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* Add New Local Class (Local Types)
* lcl -> Ctrl + Space.

    DATA connection TYPE REF TO lcl_connection.
*    DATA connection2 TYPE REF TO lcl_connection.

*    connection = NEW #( ). "Instance
*    connection->carrier_id = 'LH'.
*    connection->connection_id = '0400'.
*    connection2 = connection.

    DATA connections TYPE TABLE OF REF TO lcl_connection.

    connection = NEW #( ).  "Instance
    APPEND connection TO connections.
    connection = NEW #( ).  "Instance
    APPEND connection TO connections.

  ENDMETHOD.

ENDCLASS.
