*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_passenger_flight DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF st_flights_buffer,
             carrier_id     TYPE /dmo/flight-carrier_id,
             connection_id  TYPE /dmo/flight-connection_id,
             flight_date    TYPE /dmo/flight-flight_date,
             plane_type_id  TYPE /dmo/flight-plane_type_id,
             seats_max      TYPE /dmo/flight-seats_max,
             seats_occupied TYPE /dmo/flight-seats_occupied,
             seats_free     TYPE i,
             price          TYPE /dmo/flight-price,
             currency_code  TYPE /dmo/flight-currency_code,
           END OF st_flights_buffer.

    DATA flights_buffer TYPE TABLE OF st_flights_buffer.
    DATA flight_raw     TYPE st_flights_buffer.
    DATA flights_buffer_aux TYPE TABLE OF zpccargoflight.

    DATA: seats_free    TYPE i,
          name          TYPE /dmo/carrier_name,
          currency_code TYPE /dmo/currency_code.

* Methods
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id OPTIONAL
      RAISING
        cx_abap_invalid_value.

    METHODS get_free_seats
      RETURNING VALUE(seat) TYPE i.

    METHODS get_output
      RETURNING VALUE(rx_result) TYPE string_table
      RAISING
                cx_abap_invalid_value.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD constructor.

    SELECT
      FROM /dmo/flight
    FIELDS carrier_id, connection_id, flight_date,
           plane_type_id, seats_max, seats_occupied,
           seats_max - seats_occupied AS seats_free,
           currency_conversion(
             amount             = price,
             source_currency    = currency_code,
             target_currency    = 'EUR',
             exchange_rate_date = flight_date,
             on_error           = @sql_currency_conversion=>c_on_error-set_to_null
                             ) AS price,
         'EUR' AS currency_code
     WHERE carrier_id = @i_carrier_id
     ORDER BY flight_date ASCENDING
      INTO TABLE @flights_buffer.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    IF NOT line_exists(  flights_buffer[ carrier_id = i_carrier_id ] ).

      SELECT
        FROM /dmo/flight
      FIELDS carrier_id, connection_id, flight_date,
             plane_type_id, seats_max, seats_occupied,
             seats_max - seats_occupied AS seats_free,
             currency_conversion(
               amount             = price,
               source_currency    = currency_code,
               target_currency    = 'EUR',
               exchange_rate_date = flight_date,
               on_error           = @sql_currency_conversion=>c_on_error-set_to_null
                               ) AS price,
           'EUR' AS currency_code
       WHERE carrier_id = @i_carrier_id
       ORDER BY flight_date ASCENDING
       APPENDING TABLE @flights_buffer.

    ENDIF.

    SORT flights_buffer BY carrier_id connection_id flight_date.

*  DELETE ADJACENT DUPLICATES FROM flights_buffer
*        COMPARING carrier_id connection_id flight_date.

**DATA(r_result) = NEW lcl_passenger_flight( i_carrier_id = 'SQ' ).
**DATA r_result  TYPE REF TO lcl_passenger_flight.
*DATA r_result TYPE TABLE OF REF TO lcl_passenger_flight.

*  r_result = VALUE #(
*               FOR ls_flight IN flights_buffer
*               WHERE ( carrier_id = i_carrier_id )
*               (
*               NEW lcl_passenger_flight( i_carrier_id = ls_flight-carrier_id )
*               )
*             ).

  ENDMETHOD.

  METHOD get_free_seats.

    seat = 35.
    seats_free = 10.

  ENDMETHOD.

  METHOD get_output.

    DATA r_result TYPE TABLE OF REF TO lcl_passenger_flight.

*    DATA rr_result TYPE p LENGTH 16 DECIMALS 2.
*    DATA passenger_flights TYPE TABLE OF /dmo/flight.
*
*    SELECT FROM /dmo/flight FIELDS * INTO TABLE @passenger_flights.
*
*    rr_result = REDUCE #( INIT i = 0 FOR flight IN passenger_flights
*                          NEXT i += get_free_seats( ) ) / lines( passenger_flights ).

  r_result = VALUE #(
               FOR ls_flight IN flights_buffer
               WHERE ( carrier_id = 'SQ' )
               (
               NEW lcl_passenger_flight( i_carrier_id = ls_flight-carrier_id )
               )
             ).

  ENDMETHOD.

ENDCLASS.
