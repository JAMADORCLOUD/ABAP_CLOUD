CLASS zcl_92_solution_14_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_92_solution_14_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

* table /dmo/carrier Substitute by CDS zcds_01_airports

    DATA the_airport TYPE REF TO lcl_airport.

    CONSTANTS c_airport_id TYPE /dmo/airport_id VALUE 'FRA'.

    TRY.
        the_airport = NEW lcl_airport( i_airport_id = c_airport_id  ).
      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_airport` ).
      CATCH cx_abap_auth_check_exception.
        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_airport` ).
    ENDTRY.

    out->write( 'OK Example' ).

  ENDMETHOD.

ENDCLASS.
