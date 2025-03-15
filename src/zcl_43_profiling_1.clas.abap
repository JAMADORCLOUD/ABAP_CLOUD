CLASS zcl_43_profiling_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_43_profiling_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(flights) = lcl_data=>get_flights(  ).

    SORT flights BY flight_date DESCENDING.

    out->write( name = 'List of all flights' data = flights ).

  ENDMETHOD.

ENDCLASS.
