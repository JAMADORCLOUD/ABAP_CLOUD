*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

  DATA: carrier_id    TYPE /dmo/carrier_id,
        connection_id TYPE /dmo/connection_id,
        flight_date   TYPE /dmo/flight_date,
        seats_free    TYPE i,
        txt           TYPE string.

  DATA connections TYPE STANDARD TABLE OF /dmo/connection.
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

    IF sy-subrc EQ 0.

      READ TABLE connections INTO ls_connections INDEX 1.

      IF sy-subrc NE 0.
        CLEAR ls_connections.
      ENDIF.

    ELSE.

      RAISE EXCEPTION TYPE cx_abap_invalid_value.

    ENDIF.

  ENDMETHOD.

  METHOD get_average_free_seats.

    seat = 5.
    seats_free = 10.

  ENDMETHOD.

  METHOD get_output.

    APPEND |{ 'Carrier ID:'(001)            } { me->carrier_id              } | TO r_result.
    APPEND |{ 'Connections Flights:'(002)   } { lines( connections       )  } | TO r_result.
    APPEND |{ 'Airport From:'(004)          } { connections[ connection_id = '0011'   ]-airport_from_id   }| TO r_result.
    APPEND |{ 'Average free seats:'(003)    } { get_average_free_seats(  )  } | TO r_result.

    txt = 'Flight &carrid& &connid& on &date& from &from& to &to&'(005).
    txt = replace( val = txt sub = '&carrid&' with = carrier_id ).
    txt = replace( val = txt sub = '&connid&' with = connection_id ).
    txt = replace( val = txt sub = '&date&'   with = |{ flight_date DATE = USER }| ).
    txt = replace( val = txt sub = '&from&'   with = ls_connections-airport_from_id ).
    txt = replace( val = txt sub = '&to&'     with = ls_connections-airport_to_id ).

    APPEND txt TO r_result.

*    APPEND |{ 'Planetype:'(006)      } { planetype  } | TO r_result.
*    APPEND |{ 'Maximum Seats:'(007)  } { seats_max  } | TO r_result.
*    APPEND |{ 'Occupied Seats:'(008) } { seats_occ  } | TO r_result.
    APPEND |{ 'Free Seats:'(009)     } { seats_free } | TO r_result.
*    APPEND |{ 'Ticket Price:'(010)   } { price CURRENCY = currency } { currency } | TO r_result.

*    APPEND |{ 'Duration:'(011)       } { connection_details-duration } { 'minutes'(012) }| TO r_result.

  ENDMETHOD.

ENDCLASS.
