CLASS zcl_55_cal_flight_duration DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_55_cal_flight_duration IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(connection_details) = lcl_passenger_flight=>get_description( ).

    out->write( |Duration { connection_details-duration } minutes.| ).

  ENDMETHOD.

ENDCLASS.
