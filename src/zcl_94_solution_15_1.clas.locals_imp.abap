*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_flight DEFINITION." CREATE PRIVATE.
*CLASS lcl_flight DEFINITION ABSTRACT.

  PUBLIC SECTION.

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

    METHODS constructor
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date.

   METHODS get_description REDEFINITION.

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

ENDCLASS.

CLASS lcl_cargo_flight DEFINITION
            INHERITING FROM lcl_flight.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date.

   METHODS get_description REDEFINITION.

   METHODS get_free_capacity
     RETURNING VALUE(capacity) TYPE i.

     DATA: maximum_load TYPE i,
           load_unit type c LENGTH 2.

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

ENDCLASS.
