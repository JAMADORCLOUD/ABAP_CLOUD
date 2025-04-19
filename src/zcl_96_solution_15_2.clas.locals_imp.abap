*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations "Add lcl Then Ctrl + Space Create a new implementation

CLASS lcl_flight DEFINITION." CREATE PRIVATE.
*CLASS lcl_flight DEFINITION ABSTRACT.

  PUBLIC SECTION.

    TYPES tab TYPE STANDARD TABLE OF REF TO lcl_flight WITH DEFAULT KEY.
    DATA: lo_flight TYPE REF TO lcl_flight.

    METHODS constructor
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date OPTIONAL.

    TYPES: BEGIN OF st_connection_details,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             departure_time  TYPE /dmo/flight_departure_time,
             arrival_time    TYPE /dmo/flight_departure_time,
             duration        TYPE i,
           END OF st_connection_details.

    DATA carrier_id    TYPE /dmo/carrier_id       READ-ONLY.
    DATA connection_id TYPE /dmo/connection_id    READ-ONLY.
    DATA flight_date   TYPE /dmo/flight_date      READ-ONLY.

    METHODS: get_connection_details
      RETURNING
        VALUE(r_result) TYPE st_connection_details.

    METHODS get_description
      RETURNING
        VALUE(r_result) TYPE string_table.


  PROTECTED SECTION.

    DATA planetype          TYPE /dmo/plane_type_id.
    DATA connection_details TYPE st_connection_details.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_flight IMPLEMENTATION.

  METHOD constructor.

    me->carrier_id = i_carrier_id.
    me->connection_id = i_connection_id.
    me->flight_date = i_flight_date.
    planetype = 'AERO'.

    get_connection_details( ).
    get_description( ).

  ENDMETHOD.

  METHOD get_connection_details.

    SELECT SINGLE
      FROM /dmo/connection
      FIELDS airport_from_id, airport_to_id, departure_time, arrival_time
      WHERE carrier_id    = @carrier_id
        AND connection_id = @connection_id
        INTO @connection_details.

  ENDMETHOD.

  METHOD get_description.

    DATA txt TYPE string.

    txt = 'Flight &carrid& &connid& on &date& from &from& to &to&'(005).
    txt = replace( val = txt sub = '&carrid&' with = carrier_id ).
    txt = replace( val = txt sub = '&connid&' with = connection_id ).
    txt = replace( val = txt sub = '&date&'   with = |{ flight_date DATE = USER }| ).
    txt = replace( val = txt sub = '&from&'   with = connection_details-airport_from_id ).
    txt = replace( val = txt sub = '&to&'     with = connection_details-airport_to_id ).

    APPEND txt TO r_result.
    APPEND |{ 'Planetype:'(006)      } { planetype  } | TO r_result.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_passenger_flight DEFINITION
            INHERITING FROM lcl_flight.

  PUBLIC SECTION.

    TYPES: BEGIN OF st_p_flight,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             flight_date   TYPE /dmo/flight_date,
             plane_type_id TYPE /dmo/plane_type_id,
           END OF st_p_flight,
* declare table - do not allow the same attribute to be used more than once
           tt_p_flight TYPE SORTED TABLE OF st_p_flight WITH UNIQUE KEY carrier_id connection_id flight_date.

    TYPES tt_flights TYPE STANDARD TABLE OF REF TO lcl_passenger_flight WITH DEFAULT KEY.

    METHODS constructor
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date.

    METHODS get_description REDEFINITION.

    METHODS get_free_seats
      RETURNING VALUE(free_seat) TYPE i.

    " Static Method
    CLASS-METHODS get_flights_by_carrier
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
      RETURNING
                VALUE(r_result) TYPE tt_p_flight.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_passenger_flight IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_carrier_id = i_carrier_id
                        i_connection_id = i_connection_id
                        i_flight_date = i_flight_date ).

    get_description( ).

  ENDMETHOD.

  METHOD get_description.

* Redefinition uses call of superclass implementation

    r_result = super->get_description( ).

  ENDMETHOD.

  METHOD get_free_seats.

    free_Seat = 3.

  ENDMETHOD.

  METHOD get_flights_by_carrier.

    SELECT
    FROM /dmo/flight
    FIELDS carrier_id, connection_id, flight_date, plane_type_id
     WHERE carrier_id = @i_carrier_id
      INTO TABLE @r_result.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_cargo_flight DEFINITION
            INHERITING FROM lcl_flight.

  PUBLIC SECTION.

    TYPES tt_flights TYPE STANDARD TABLE OF REF TO lcl_cargo_flight WITH DEFAULT KEY.

    TYPES: BEGIN OF st_c_flight,
             carrier_id    TYPE /dmo/carrier_id,
             connection_id TYPE /dmo/connection_id,
             flight_date   TYPE /dmo/flight_date,
             plane_type_id TYPE /dmo/plane_type_id,
           END OF st_c_flight,
* declare table - do not allow the same attribute to be used more than once
           tt_c_flight TYPE SORTED TABLE OF st_c_flight WITH UNIQUE KEY carrier_id connection_id flight_date.

    METHODS constructor
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date.

    METHODS get_description REDEFINITION.

    METHODS get_free_capacity
      RETURNING VALUE(capacity) TYPE i.

    " Static Method
    CLASS-METHODS: get_flights_by_carrier
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
      RETURNING
                VALUE(r_result) TYPE tt_c_flight.

    DATA: maximum_load TYPE i,
          load_unit    TYPE c LENGTH 2.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_cargo_flight IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_carrier_id = i_carrier_id
                        i_connection_id = i_connection_id
                        i_flight_date = i_flight_date ).

    get_description( ).

  ENDMETHOD.

  METHOD get_description.

* Redefinition uses call of superclass implementation

    r_result = super->get_description( ).

    maximum_load = 2.
    load_unit = 'MI'.

*    APPEND |Flight { carrier_id } { connection_id } on { flight_date DATE = USER } | &&
*           |from { connection_details-airport_from_id } to { connection_details-airport_to_id } |
*           TO r_result.
*    APPEND |Planetype:     { planetype } |                         TO r_result.

    APPEND |Maximum Load:  { maximum_load         } { load_unit }| TO r_result.
    APPEND |Free Capacity: { get_free_capacity( ) } { load_unit }| TO r_result.

  ENDMETHOD.

  METHOD get_free_capacity.

    Capacity = 5.

  ENDMETHOD.

  METHOD get_flights_by_carrier.

    SELECT
    FROM /dmo/flight
    FIELDS carrier_id, connection_id, flight_date, plane_type_id
     WHERE carrier_id = @i_carrier_id
      INTO TABLE @r_result.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_carrier DEFINITION
            INHERITING FROM lcl_flight.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date.

    METHODS find_passenger_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id OPTIONAL
        i_from_date       TYPE /dmo/flight_date OPTIONAL
        i_seats           TYPE i    OPTIONAL
      EXPORTING
        e_flight          TYPE REF TO lcl_flight
        e_days_later      TYPE i.

    METHODS find_cargo_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id OPTIONAL
        i_from_date       TYPE /dmo/flight_date OPTIONAL
        i_cargo           TYPE i OPTIONAL"/lrn/plane_actual_load
      EXPORTING
        e_flight          TYPE REF TO lcl_flight
        e_days_later      TYPE i.

    METHODS get_output
      RETURNING
        VALUE(r_result) TYPE string_table.

    METHODS get_average_free_seats
      RETURNING VALUE(r_result) TYPE i.

  PRIVATE SECTION.

    DATA passenger_flights TYPE lcl_passenger_flight=>tt_flights.
    DATA cargo_flights     TYPE lcl_cargo_flight=>tt_flights.
    DATA flights           TYPE lcl_flight=>tab.
*    DATA flights           TYPE TABLE OF REF TO lcl_passenger_flight.
    DATA gr_flights        TYPE REF TO lcl_passenger_flight.
    DATA pf_count TYPE i.
    DATA cf_count TYPE i.
    DATA name    TYPE c LENGTH 6 VALUE 'JESUS'.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_carrier_id = i_carrier_id
                        i_connection_id = i_connection_id
                        i_flight_date = i_flight_date ).

    find_passenger_flight( i_airport_from_id = 'FRA' ).
    find_cargo_flight( i_airport_from_id = 'HAM' ).
    get_output( ).

  ENDMETHOD.

  METHOD find_passenger_flight.


* flights = passenger_flights.

        gr_flights = NEW #( i_carrier_id = 'SQ'
                            i_connection_id = '0012'
                            i_flight_date = cl_abap_context_info=>get_system_date( ) ).

       APPEND gr_flights to flights.

*  LOOP AT passenger_flights INTO DATA(passflight).
*    APPEND passflight TO flights.
*  ENDLOOP.


*    flights = VALUE #( BASE flights
*                       FOR pflight IN passenger_flights
*                      ( pflight )
*              ).

*    DATA(passenger_flights) =
*          lcl_passenger_flight=>get_flights_by_carrier(
*                i_carrier_id = 'AA' ).

    pf_count = lines( passenger_flights ).

    LOOP AT me->flights INTO DATA(flight)

         WHERE table_line->flight_date >= i_from_date
          AND table_line IS INSTANCE OF lcl_passenger_flight.

      DATA(connection_details) = flight->get_connection_details(  ).

      IF connection_details-airport_from_id = i_airport_from_id
       AND connection_details-airport_to_id = i_airport_to_id
       AND CAST lcl_passenger_flight( flight )->get_free_seats( )
           >= i_seats.

        DATA(days_later) = flight->flight_date - i_from_date.

        IF days_later < e_days_later. "earlier than previous one?

          e_flight = flight.
          e_days_later = days_later.

        ENDIF.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD find_cargo_flight.


*  LOOP AT cargo_flights INTO DATA(cargoflight).
*    APPEND cargoflight TO flights.
*  ENDLOOP.

*    flights = VALUE #( BASE flights
*                       FOR cflight IN cargo_flights
*                      ( cflight )
*              ).

    DATA(cargo_flights) =
          lcl_cargo_flight=>get_flights_by_carrier(
                i_carrier_id = 'SQ'  ).

    cf_count = lines(  cargo_flights ).

*    LOOP AT me->cargo_flights INTO DATA(flight).
    LOOP AT me->flights INTO DATA(flight).

      IF connection_details-airport_from_id = i_airport_from_id
             AND connection_details-airport_to_id = i_airport_to_id
*       AND flight->get_free_capacity(  ) >= i_cargo.
             AND CAST lcl_cargo_flight( flight )->get_free_capacity(  )
             >= i_cargo.


      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_output.

    APPEND |{ 'Carrier Name:'(001)       } { me->name } | TO r_result.
    APPEND |{ 'Passenger Flights:'(002)  } { pf_count } | TO r_result.
    APPEND |{ 'Average free seats:'(003) } { get_average_free_seats(  ) } | TO r_result.
    APPEND |{ 'Cargo Flights:'(004)      } { cf_count } | TO r_result.

  ENDMETHOD.

  METHOD get_average_free_seats.

*    r_result = 25.

* Table Reductions
**********************************************************************
*    r_result = REDUCE #(
*                 INIT i = 0
*                  FOR <flight> IN passenger_flights
*                 NEXT i += <flight>->get_free_seats( )
*                       ) / lines( passenger_flights ) .
    r_result =
      REDUCE #(
        INIT i = 0
         FOR <flight> IN flights
       WHERE ( table_line IS INSTANCE OF lcl_passenger_flight )
        NEXT i += CAST lcl_passenger_flight( <flight> )->get_free_seats( )
      ) / pf_count .


  ENDMETHOD.

ENDCLASS.
