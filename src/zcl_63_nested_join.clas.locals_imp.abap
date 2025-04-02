*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF st_connections_buffer,
        carrier_id      TYPE /dmo/carrier_id,
        connection_id   TYPE /dmo/connection_id,
        airport_from_id TYPE /dmo/airport_from_id,
        airport_to_id   TYPE /dmo/airport_to_id,
        departure_time  TYPE /dmo/flight_departure_time,
        arrival_time    TYPE /dmo/flight_departure_time,
        timzone_from    TYPE timezone,
        timzone_to      TYPE timezone,
       duration         TYPE i,
      END OF st_connections_buffer.

      DATA connections_buffer TYPE TABLE OF st_connections_buffer.
      DATA connection TYPE st_connections_buffer.

  DATA: carrier_id    TYPE /dmo/carrier_id,
        connection_id TYPE /dmo/connection_id,
        flight_date   TYPE /dmo/flight_date,
        seats_free    TYPE i,
        txt           TYPE string.


  DATA connections TYPE TABLE OF /dmo/connection.
  DATA ls_connections TYPE /dmo/connection.

* Methods
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id OPTIONAL
      RAISING
        cx_abap_invalid_value.

    METHODS get_average_free_seats
      RETURNING VALUE(seat) TYPE i.

    METHODS get_output
      RETURNING VALUE(r_result) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    IF i_carrier_id IS INITIAL. "OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    carrier_id = i_carrier_id.
*  connection_id = i_connection_id.
    connection_id = '0400'.
    flight_date = cl_abap_context_info=>get_system_date( ).
    me->carrier_id = i_carrier_id.
    me->connection_id = connection_id.

    SELECT *
           FROM /dmo/connection
           WHERE carrier_id    = @i_carrier_id
*           AND connection_id = @i_connection_id
           INTO TABLE @connections.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    SELECT
      FROM /dmo/connection AS c
      LEFT OUTER JOIN zta_03_p_flight AS f
        ON c~carrier_id = f~carrier_id
      LEFT OUTER JOIN zta_03_p_flight AS t
        ON c~carrier_id = t~carrier_id
    FIELDS c~carrier_id, c~connection_id,
           c~airport_from_id, c~airport_to_id, c~departure_time, c~arrival_time,
           f~timzone AS timzone_from,
           t~timzone AS timzone_to
      INTO TABLE @connections_buffer.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.


* Simple Example
 DATA(today) = cl_abap_context_info=>get_system_date( ).

 READ TABLE connections_buffer INTO connection INDEX 1.

 IF SY-SUBRC EQ 0.

  CONVERT DATE today
          TIME connection-departure_time
*          TIME ZONE airports[ airport_id = connection-airport_from_id ]-timzone
          TIME ZONE connection-timzone_from
          INTO UTCLONG DATA(departure_utclong).

  CONVERT DATE today
          TIME connection-arrival_time
*          TIME ZONE airports[ airport_id = connection-airport_to_id ]-timzone
          TIME ZONE connection-timzone_to
          INTO UTCLONG DATA(arrival_utclong).

      connection-duration = utclong_diff( high = arrival_utclong
                                          low  = departure_utclong
                                        ) / 60.

  ENDIF.

*      MODIFY connections_buffer FROM connection TRANSPORTING duration.

  ENDMETHOD.

  METHOD get_average_free_seats.

    seat = 5.
    seats_free = 10.

  ENDMETHOD.

  METHOD get_output.

*    APPEND |{ 'Carrier ID:'(001)            } { me->carrier_id              } | TO r_result.
*    APPEND |{ 'Connections Flights:'(002)   } { lines( connections       )  } | TO r_result.
*    APPEND |{ 'Airport From:'(004)          } { connections[ connection_id = '0011'   ]-airport_from_id   }| TO r_result.
*    APPEND |{ 'Average free seats:'(003)    } { get_average_free_seats(  )  } | TO r_result.
*
*    txt = 'Flight &carrid& &connid& on &date& from &from& to &to&'(005).
*    txt = replace( val = txt sub = '&carrid&' with = carrier_id ).
*    txt = replace( val = txt sub = '&connid&' with = connection_id ).
*    txt = replace( val = txt sub = '&date&'   with = |{ flight_date DATE = USER }| ).
*    txt = replace( val = txt sub = '&from&'   with = ls_connections-airport_from_id ).
*    txt = replace( val = txt sub = '&to&'     with = ls_connections-airport_to_id ).
*
*    APPEND txt TO r_result.
*
*    APPEND |{ 'Free Seats:'(009)     } { seats_free } | TO r_result.


  ENDMETHOD.

ENDCLASS.
