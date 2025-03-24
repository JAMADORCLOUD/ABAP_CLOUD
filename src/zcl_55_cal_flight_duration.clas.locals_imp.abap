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
        duration        TYPE i,
      END OF st_connections_buffer.

    CLASS-DATA connections_buffer TYPE TABLE OF st_connections_buffer.

    TYPES:
      BEGIN OF st_connection_details,
        airport_from_id TYPE /dmo/airport_from_id,
        airport_to_id   TYPE /dmo/airport_to_id,
        departure_time  TYPE /dmo/flight_departure_time,
        arrival_time    TYPE /dmo/flight_departure_time,
        duration        TYPE i,
      END OF st_connection_details.

    CLASS-DATA connection_details TYPE TABLE OF st_connection_details.

    CLASS-METHODS: get_description
      RETURNING VALUE(connection_details) TYPE st_connection_details.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD class_constructor.

    SELECT
       FROM zta_03_p_flight
     FIELDS carrier_id, timzone
       INTO TABLE @DATA(airports).

    SELECT
      FROM /dmo/connection
    FIELDS carrier_id, connection_id,
           airport_from_id, airport_to_id, departure_time, arrival_time
      INTO TABLE @connections_buffer.

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT connections_buffer INTO DATA(connection).

      CONVERT DATE today
              TIME connection-departure_time
              TIME ZONE airports[ carrier_id = connection-carrier_id ]-timzone
              INTO UTCLONG DATA(departure_utclong).

      CONVERT DATE today
               TIME connection-arrival_time
               TIME ZONE airports[ carrier_id = connection-carrier_id ]-timzone
               INTO UTCLONG DATA(arrival_utclong).

* Error with no carrier_id is not found

      connection-duration = utclong_diff( high = arrival_utclong
                                          low  = departure_utclong
                                        ) / 60.

      MODIFY connections_buffer FROM connection TRANSPORTING duration.

    ENDLOOP.

    CLEAR today.

  ENDMETHOD.

  METHOD get_description.

    connection_details-duration = 5.

  ENDMETHOD.

ENDCLASS.
