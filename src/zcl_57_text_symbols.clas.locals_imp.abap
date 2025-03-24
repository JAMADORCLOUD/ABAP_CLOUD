*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.

  DATA carrier_id    TYPE /dmo/carrier_id.
  DATA connection_id TYPE /dmo/connection_id.

  DATA connections TYPE STANDARD TABLE OF /dmo/connection.

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

*    carrier_id = i_carrier_id.
*    connection_id = i_connection_id.
    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.

    SELECT *
           FROM /dmo/connection
           WHERE carrier_id    = @i_carrier_id
*           AND connection_id = @i_connection_id
           INTO TABLE @connections.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

  ENDMETHOD.

  METHOD get_average_free_seats.

    seat = 5.

  ENDMETHOD.

  METHOD get_output.

    APPEND |{ 'Carrier ID:'(001)            } { me->carrier_id              } | TO r_result.
    APPEND |{ 'Connections Flights:'(002)   } { lines( connections       )  } | TO r_result.
    APPEND |{ 'Airport From:'(004)          } { connections[ connection_id = '0011'   ]-airport_from_id   }| TO r_result.
    APPEND |{ 'Average free seats:'(003)    } { get_average_free_seats(  )  } | TO r_result.

  ENDMETHOD.

ENDCLASS.
