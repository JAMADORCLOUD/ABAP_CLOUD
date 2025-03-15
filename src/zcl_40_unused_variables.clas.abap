CLASS zcl_40_unused_variables DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_40_unused_variables IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*Pseudo
  DATA carrier_list TYPE TABLE OF /dmo/carrier.             "#EC NEEDED

*Pragma
  DATA text3 TYPE string   ##needed .

  SELECT FROM /dmo/connection
    FIELDS *
    INTO TABLE @DATA(connections).

*    connection_list = connection_list.

  out->write( connections ).

  ENDMETHOD.

ENDCLASS.
