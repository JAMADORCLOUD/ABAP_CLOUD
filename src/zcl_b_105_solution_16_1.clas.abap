CLASS zcl_b_105_solution_16_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_b_105_solution_16_1 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    DATA carrier TYPE REF TO lcl_carrier.
    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'AA'.

*  DATA(carrier) = NEW lcl_carrier(  i_carrier_id = c_carrier_id ).

    TRY.

        DATA(carrier) = lcl_carrier=>get_instance(  i_carrier_id = c_carrier_id ).

*      CATCH cx_abap_invalid_value.
*        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).
*      CATCH cx_abap_auth_check_exception.
*        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).
      CATCH cx_abap_invalid_value INTO DATA(exc_inv).

        out->write( | Carrier { c_carrier_id } does not exist | ).
        out->write( exc_inv->get_text( ) ).


      CATCH cx_abap_auth_check_exception INTO DATA(exc_auth).

        out->write( | No authorization to display carrier { c_carrier_id } | ).
        out->write( exc_auth->get_text( ) ).

      CATCH cx_root INTO DATA(exc_root).

*     cl_abap_unit_assert=>fail( exc_root->get_text( ) ).
        out->write( exc_root->get_text( ) ).

    ENDTRY.

*    TRY.
*
*        DATA(carrier2) = lcl_carrier=>get_instance(  i_carrier_id = c_carrier_id ).
*
*      CATCH cx_abap_invalid_value.
*
*        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).
*
*      CATCH cx_abap_auth_check_exception.
*
*        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).
*
*    ENDTRY.

  ENDMETHOD.

ENDCLASS.
