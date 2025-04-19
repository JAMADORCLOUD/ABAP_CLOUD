CLASS zcl_b_103_solution_15_5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_b_103_solution_15_5 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    DATA carrier TYPE REF TO lcl_carrier.
    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'AA'.

*  DATA(carrier) = NEW lcl_carrier(  i_carrier_id = c_carrier_id ).

    TRY.

        DATA(carrier) = lcl_carrier=>get_instance(  i_carrier_id = c_carrier_id ).

      CATCH cx_abap_invalid_value.

        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).

      CATCH cx_abap_auth_check_exception.

        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).

    ENDTRY.

    TRY.

        DATA(carrier2) = lcl_carrier=>get_instance(  i_carrier_id = c_carrier_id ).

      CATCH cx_abap_invalid_value.

        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).

      CATCH cx_abap_auth_check_exception.

        cl_abap_unit_assert=>fail( `Unable to instantiate lcl_carrier` ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
