*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_passenger_flight DEFINITION.

  PUBLIC SECTION.

    TYPES tt_connections TYPE STANDARD TABLE OF /dmo/connection WITH NON-UNIQUE KEY carrier_id connection_id.

    CLASS-METHODS get_connections
      RETURNING VALUE(r_result) TYPE tt_connections.

    TYPES: BEGIN OF st_flights_buffer,
           carrier_id     TYPE zta_03_p_flight-carrier_id,
           connection_id  TYPE zta_03_p_flight-connection_id,
           flight_date    TYPE zta_03_p_flight-flight_date,
           plane_type_id  TYPE zta_03_p_flight-plane_type_id,
           seats_max      TYPE zta_03_p_flight-seats_max,
           seats_occupied TYPE zta_03_p_flight-seats_occupied,
           price          TYPE zta_03_p_flight-price,
           currency_code  TYPE zta_03_p_flight-currency_code,
           END OF st_flights_buffer.

    TYPES: tt_flights TYPE STANDARD TABLE OF st_flights_buffer WITH NON-UNIQUE KEY carrier_id connection_id.

    TYPES st_flights TYPE st_flights_buffer. "Correct
*    TYPES st_flights TYPE tt_flights.        "Not Correct

    CLASS-METHODS get_flights_by_carrier
      IMPORTING i_carrier_id TYPE /dmo/carrier_id
*      RETURNING VALUE(r_result) TYPE tt_flights.         "Table
      RETURNING VALUE(r_result) TYPE st_flights.         "Structure


      TYPES st_flights_2 TYPE st_flights_buffer. "Correct

    CLASS-METHODS flights_buffer
      IMPORTING i_carrier_id      TYPE /dmo/carrier_id
                i_connection_id   TYPE /dmo/connection_id OPTIONAL
                i_flight_date     TYPE /dmo/flight_date   OPTIONAL
      RETURNING VALUE(flight_raw) TYPE st_flights_2.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD get_connections.

    SELECT *
        FROM /dmo/connection
        INTO TABLE @r_result.

  ENDMETHOD.

  METHOD get_flights_by_carrier.

*    SELECT
*    FROM zta_03_p_flight
*    FIELDS carrier_id, connection_id, flight_date,
*           plane_type_id, seats_max, seats_occupied,
*           price, currency_code
*     WHERE carrier_id = @i_carrier_id
*      INTO TABLE @r_result.
**      INTO TABLE @DATA(flights_buffer).

    SELECT SINGLE
          FROM zta_03_p_flight
        FIELDS plane_type_id, seats_max, seats_occupied, price, currency_code
         WHERE carrier_id    = @i_carrier_id
          INTO CORRESPONDING FIELDS OF @r_result.

  ENDMETHOD.

  METHOD flights_buffer.

    SELECT SINGLE
          FROM zta_03_p_flight
        FIELDS plane_type_id, seats_max, seats_occupied, price, currency_code
         WHERE carrier_id    = @i_carrier_id
           AND connection_id = @i_connection_id
           AND flight_date   = @i_flight_date
          INTO CORRESPONDING FIELDS OF @flight_raw .

          IF flight_raw IS INITIAL.

          CLEAR flight_raw.

          ENDIF.

  ENDMETHOD.

ENDCLASS.
