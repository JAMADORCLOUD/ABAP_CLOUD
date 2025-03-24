CLASS zcl_45_cargo_flight DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_45_cargo_flight IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  DATA(some_flight_data) = lcl_find_flights=>test_find_cargo_flight(  ).
  out->write( |Flight Date { some_flight_data-flight_date }.| ).

  ENDMETHOD.

ENDCLASS.
