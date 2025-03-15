*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_data DEFINITION FINAL.

  PUBLIC SECTION.

    TYPES tt_flight TYPE STANDARD TABLE OF /dmo/flight
                  WITH NON-UNIQUE KEY carrier_id connection_id.

    CLASS-METHODS get_flights RETURNING VALUE(r_result) TYPE tt_flight.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_data IMPLEMENTATION.

  METHOD get_flights.

    SELECT * FROM /dmo/flight INTO TABLE @r_result.

  ENDMETHOD.

ENDCLASS.
