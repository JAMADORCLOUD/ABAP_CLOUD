*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_passenger_flight DEFINITION.

  PUBLIC SECTION.

    DATA key_carrier_id TYPE /dmo/carrier_id VALUE 'SQ'.

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

*    CLASS-DATA connections_buffer TYPE TABLE OF st_connections_buffer.
    CLASS-DATA connections_buffer
          TYPE HASHED TABLE OF st_connections_buffer
          WITH UNIQUE KEY carrier_id connection_id.

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

*    CLASS-DATA flights_buffer TYPE TABLE OF st_flights_buffer.
    CLASS-DATA: flights_buffer
          TYPE SORTED TABLE OF st_flights_buffer
          WITH NON-UNIQUE KEY carrier_id connection_id flight_date.

* Methods
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id OPTIONAL
      RAISING
        cx_abap_invalid_value.

    METHODS access_sorted.
    METHODS access_hashed.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD constructor.

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    TRY.
        DATA(timezone) = cl_abap_context_info=>get_user_time_zone(  ).
      CATCH cx_abap_context_info_error.
*         out->write( | cx_abap_context_info_error  | ).
    ENDTRY.

    SELECT
        FROM /dmo/connection AS c
        LEFT OUTER JOIN /dmo/airport AS f
            ON c~carrier_id = f~airport_id
        LEFT OUTER JOIN /dmo/airport AS t
            ON c~airport_to_id = t~airport_id
    FIELDS
        carrier_id,
        connection_id,
        airport_from_id,
        airport_to_id,
        departure_time,
        arrival_time,
        div(
            tstmp_seconds_between(
                tstmp1 = dats_tims_to_tstmp(
                    date = @today,
                    time = c~departure_time,
                    tzone = @timezone
                    ),
                tstmp2 = dats_tims_to_tstmp(
                    date = @today,
                    time = c~arrival_time,
                    tzone = @timezone
                    )
               ), 60
           ) AS duration
    INTO TABLE @connections_buffer.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

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
      INTO TABLE @flights_buffer.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

  ENDMETHOD.

  METHOD access_hashed.
    DATA(result) = connections_buffer[ carrier_Id = me->key_carrier_id ].
  ENDMETHOD.

  METHOD access_sorted.
    DATA(result) = flights_buffer[ carrier_Id = me->key_carrier_id ].
  ENDMETHOD.

ENDCLASS.
