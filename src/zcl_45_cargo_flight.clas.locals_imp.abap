*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class lcl_find_flights definition.   "Add lcl and Ctrl + space

  public section.

    TYPES st_flights_data TYPE zta_03_p_flight. "Correct

    CLASS-METHODS test_find_cargo_flight
      RETURNING VALUE(r_result) TYPE st_flights_data.

  protected section.
  private section.

endclass.

class lcl_find_flights implementation.

  METHOD test_find_cargo_flight.

  SELECT SINGLE
    FROM zta_03_p_flight
   FIELDS carrier_id, connection_id, flight_date
     INTO @DATA(some_flight_data).

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( `No data in table ZTA_03_P_FLIGHT` ).

      ELSE.

      r_result = some_flight_data.

    ENDIF.

  ENDMETHOD.

endclass.
