*"* use this source file for your ABAP unit test classes
CLASS ltcl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

  CLASS-DATA the_carrier TYPE REF TO lcl_carrier.
  CLASS-DATA some_flight_data TYPE zta_01_cxn.

    METHODS:
      test_success FOR TESTING RAISING cx_static_check.
    METHODS test_find_cargo_flight FOR TESTING.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD test_success.

  ENDMETHOD.

  METHOD test_find_cargo_flight.

    SELECT SINGLE
      FROM zta_01_cxn
    FIELDS carrid, connid,
           airport_from, airport_to
      INTO @DATA(some_flight_data).
*      INTO CORRESPONDING FIELDS OF @some_flight_data.

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>fail( `No data in table ZTA_01_CXN` ).
    ENDIF.

    TRY.

        the_carrier = NEW lcl_carrier( i_carrier_id = some_flight_data-carrid ).

      CATCH cx_abap_invalid_value.

        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).

    ENDTRY.

    the_carrier->find_cargo_flight(
      EXPORTING
        i_airport_from_id = some_flight_data-airport_from
        i_airport_to_id   = some_flight_data-airport_to
      IMPORTING
        e_flight_name          = data(flight_name)
        e_days_later           = data(days_later)
    ).

*    cl_abap_unit_assert=>assert_bound(
*           act = flight_name
*           msg = `Method find_cargo_flight does not return a result`
*       ).
*
*    cl_abap_unit_assert=>assert_equals(
*            act = days_later
*            exp = 0
*            msg = `Method find_cargo_flight returns wrong result` ).

  ENDMETHOD.

ENDCLASS.
