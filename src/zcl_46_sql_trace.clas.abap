CLASS zcl_46_sql_trace DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_46_sql_trace IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(connection_details) = lcl_passenger_flight=>connection_det( i_carrier_id = 'AA'
                                                                     i_connection_id = '0322' ).

  out->write( |Arrival Time { connection_details-arrival_time }.| ).

  ENDMETHOD.

ENDCLASS.
