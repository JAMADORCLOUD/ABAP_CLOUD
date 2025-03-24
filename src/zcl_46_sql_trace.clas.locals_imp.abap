*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_passenger_flight DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS: class_constructor.

    TYPES:
      BEGIN OF st_connections_buffer,
        carrier_id      TYPE /dmo/carrier_id,
        connection_id   TYPE /dmo/connection_id,
        airport_from_id TYPE /dmo/airport_from_id,
        airport_to_id   TYPE /dmo/airport_to_id,
        departure_time  TYPE /dmo/flight_departure_time,
        arrival_time    TYPE /dmo/flight_departure_time,
      END OF st_connections_buffer.

    CLASS-DATA connections_buffer TYPE TABLE OF st_connections_buffer.

    CLASS-METHODS connection_det
      IMPORTING i_carrier_id      TYPE /dmo/carrier_id
                i_connection_id   TYPE /dmo/connection_id OPTIONAL
      RETURNING VALUE(connection_details) TYPE st_connections_buffer.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

 METHOD class_constructor.

    SELECT
      FROM /dmo/connection
    FIELDS carrier_id, connection_id,
           airport_from_id, airport_to_id, departure_time, arrival_time
      INTO TABLE @connections_buffer.

  ENDMETHOD.

  METHOD connection_det.

*      SELECT SINGLE
*        FROM /dmo/connection
*      FIELDS airport_from_id, airport_to_id, departure_time, arrival_time
*       WHERE carrier_id    = @carrier_id
*         AND connection_id = @connection_id
*        INTO @connection_details .

    connection_details = CORRESPONDING #( connections_buffer[
                                                  carrier_id    = i_carrier_id
                                                  connection_id = i_connection_id ]
                                               ).

  ENDMETHOD.

ENDCLASS.
