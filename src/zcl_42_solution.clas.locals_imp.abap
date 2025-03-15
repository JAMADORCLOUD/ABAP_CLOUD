*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING i_carrier_id TYPE /dmo/carrier_id
      RAISING   cx_abap_invalid_value.

  METHODS find_cargo_flight IMPORTING
                            i_airport_from_id TYPE /dmo/airport_from_id
                            i_airport_to_id   TYPE /dmo/airport_to_id
                            EXPORTING
                            e_flight_name      TYPE /dmo/carrier_name
                            e_days_later       TYPE /dmo/flight_date.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: carrier_data TYPE /dmo/carrier.

ENDCLASS.

CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    SELECT SINGLE *
        FROM /dmo/carrier
        WHERE carrier_id = @i_carrier_id
        INTO @me->carrier_data.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

  ENDMETHOD.

  METHOD find_cargo_flight.

    e_flight_name = me->carrier_data-name. "Comment for action example
    e_days_later = 3.

  ENDMETHOD.

ENDCLASS.
