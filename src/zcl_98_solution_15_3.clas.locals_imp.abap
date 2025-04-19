*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

INTERFACE lif_output.

  TYPES t_output  TYPE string.
  TYPES tt_output TYPE STANDARD TABLE OF t_output
                  WITH NON-UNIQUE DEFAULT KEY.
  METHODS get_output
    RETURNING
      VALUE(r_result) TYPE tt_output.

ENDINTERFACE.

CLASS lcl_passenger_flight DEFINITION.

  PUBLIC SECTION.

    INTERFACES lif_output.

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

*    DATA flights_buffer TYPE TABLE OF st_flights_buffer.
    CLASS-DATA: flights_buffer
           TYPE HASHED TABLE OF st_flights_buffer
*            TYPE SORTED TABLE OF st_flights_buffer
*            WITH NON-UNIQUE KEY carrier_id connection_id flight_date
            WITH UNIQUE KEY carrier_id connection_id flight_date
            WITH NON-UNIQUE SORTED KEY sk_carrier COMPONENTS carrier_id.

* Methods
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id OPTIONAL
      RAISING
        cx_abap_invalid_value.

*    METHODS get_output
*      RETURNING VALUE(rx_result) TYPE string_table
*      RAISING
*                cx_abap_invalid_value.

    METHODS get_description
      RETURNING
        VALUE(r_result) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD constructor.

    IF NOT line_exists(  flights_buffer[
                                 KEY sk_carrier
                          COMPONENTS carrier_id = i_carrier_id
                         ]
                      ).

*CLEAR flights_buffer.

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

    ENDIF.

  ENDMETHOD.

  METHOD get_description.

    DATA txt TYPE string.

    txt = 'Flight &carrid& &connid& on &date& from &from& to &to&'(005).
    txt = replace( val = txt sub = '&carrid&' with = 'AA' ).
    APPEND txt TO r_result.

  ENDMETHOD.

*  METHOD get_output.
*
*    DATA r_result TYPE TABLE OF REF TO lcl_passenger_flight.
*
*      r_result = VALUE #(
*                   FOR <fs_flight> IN flights_buffer
*                   USING KEY sk_carrier
**                   WHERE ( plane_type_id = '747-400' )
*                   WHERE ( carrier_id = 'SQ' )
*                   (
*                   NEW lcl_passenger_flight( i_carrier_id = <fs_flight>-carrier_id )
*                   )
*                 ).
*
*
*  ENDMETHOD.

  METHOD lif_output~get_output.

    r_result = get_description( ).

  ENDMETHOD.

ENDCLASS.
