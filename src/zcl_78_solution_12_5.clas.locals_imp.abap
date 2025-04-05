*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_passenger_flight DEFINITION.

  PUBLIC SECTION.

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

*    class-data connections_buffer type st_connections_buffer.
    CLASS-DATA connections_buffer TYPE HASHED TABLE OF st_connections_buffer WITH UNIQUE KEY carrier_id connection_id.

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

    METHODS get_average_free_seats
      RETURNING VALUE(seat) TYPE i.

    METHODS get_output
      RETURNING VALUE(r_result) TYPE string_table.

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


 SELECT
   FROM zpccargoflight
 FIELDS carrier_id, connection_id, flight_date,
        plane_type_id, maximum_load, actual_load, load_unit,
        airport_from_id, airport_to_id, departure_time, arrival_time
 WHERE carrier_id    = @i_carrier_id
 ORDER BY flight_date ASCENDING
  INTO CORRESPONDING FIELDS OF TABLE @flights_buffer_aux.


 SELECT FROM /dmo/flight
 FIELDS SUM( seats_max - seats_occupied ) AS sum,
        COUNT(*) AS count
  WHERE carrier_id = @i_carrier_id
   INTO @DATA(aggregates).

    seats_free = aggregates-sum / aggregates-count.

  ENDMETHOD.

  METHOD get_average_free_seats.

    seat = 5.
    seats_free = 10.

  ENDMETHOD.

  METHOD get_output.



  ENDMETHOD.

ENDCLASS.
