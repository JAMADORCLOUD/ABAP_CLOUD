CLASS zcl_45_pass_flight DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_45_pass_flight IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.

  DATA(connections) = lcl_passenger_flight=>get_connections(  ).

  LOOP AT connections INTO DATA(connection).

    DATA(flights) = lcl_passenger_flight=>get_flights_by_carrier( connection-carrier_id ).

    out->write( |Seat Max { flights-seats_max }. Seat Occupied { flights-seats_occupied }.| ).

    DATA(flight_raw) = lcl_passenger_flight=>flights_buffer( i_carrier_id = flights-carrier_id
                                                             i_connection_id = flights-connection_id
                                                             i_flight_date = flights-flight_date ).

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
