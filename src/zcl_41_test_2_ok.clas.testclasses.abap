*"* use this source file for your ABAP unit test classes
CLASS ltcl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_success FOR TESTING RAISING cx_static_check.
    METHODS test_exception FOR TESTING.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD test_success.

* Preparation: Read an arbitrary carrier_id from DB
**********************************************************************
    SELECT SINGLE
    FROM /DMO/carrier
    FIELDS carrier_id
    INTO @DATA(carrier_id).

    IF sy-subrc <> 0.
      " No data in table /DMO/CARRIER stop testing

      cl_abap_unit_assert=>fail( 'Test requires at least one entry in DB table /DMO/CARRIER ' ).

    ENDIF.

* Do the test of method lcl_data=>get_carrier ( )
**********************************************************************

    TRY.
        DATA(carrier) = lcl_data=>get_carrier( carrier_id ).
      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( msg    = `Inapropriate exception`
*                                 level  = if_abap_unit_constant=>severity-medium
*                                 quit   = if_abap_unit_constant=>quit-test
                                   detail = `Method lcl_data=>get_carrier( ) raises an execption when it should not` ).
    ENDTRY.

  ENDMETHOD.

  METHOD test_exception.

*specify a carrier_id that (hopefully) does not exit in the DB
**********************************************************************
    CONSTANTS c_wrong_carrier_id TYPE /dmo/carrier_id VALUE 'XX'.

* Preparation: Make sure that carrier does not exist on DB
**********************************************************************
    SELECT SINGLE
    FROM /dmo/carrier
    FIELDS carrier_id
    WHERE carrier_id = 'XX'
    INTO @DATA(carrier_id).

    IF sy-subrc EQ 0.

      " Carrier exists in DB table /DMO/CARRIER, stop testing
      cl_abap_unit_assert=>fail( msg    = |Carrier { c_wrong_carrier_id } exist in  /DMO/CARRIER|
                                 level  = if_abap_unit_constant=>severity-high
                                 quit   = if_abap_unit_constant=>quit-test
                                 detail = 'If DB table /DMO/CARRIER contains an entry' && |with carrier_id = '{ c_wrong_carrier_id }'| && 'It is not possible to test the execption' ).

    ENDIF.

* Do the test of method lcl_data=>get_carrier( )
**********************************************************************

    TRY.

        DATA(carrier) = lcl_data=>get_carrier( carrier_id ).

        cl_abap_unit_assert=>fail( msg = 'No exception'
*                           level = if_abap_unit_constant=>severity-medium
*                           quit = if_abap_unit_constant=>quit-test
                                   detail = 'Method lcl_data=>get_carrier( ) does not raise an execption when it should do so' ).
      CATCH cx_abap_invalid_value.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
