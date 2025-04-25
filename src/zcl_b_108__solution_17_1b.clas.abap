CLASS zcl_b_108__solution_17_1b DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_b_108__solution_17_1b IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA flight TYPE REF TO lcl_flight.
    DATA exception TYPE REF TO zcx_107_failed.
    CONSTANTS c_carrier_id TYPE /dmo/carrier_id VALUE 'AA'.

    TRY.

*        flight = NEW #( i_carrier_id = 'SQ' ).
      CATCH zcx_107_failed INTO exception.
        out->write( exception->get_text( ) ).

    ENDTRY.

    out->write(  name = `Carrier Overview`
             data = flight->get_output( ) ).

*    TRY.
*
*        DATA(carrier_aux)  = lcl_carrier=>get_instance(  i_carrier_id = c_carrier_id ).
*
*        out->write(  name = `Carrier Overview`
*           data = carrier_aux ).
**             data = carrier_aux->get_output( ) ).
*
*      CATCH cx_abap_invalid_value INTO DATA(exc_val).
**     out->write( exc_val->get_text( ) ).
**   CATCH cx_abap_auth_check_exception INTO DATA(exc_auth).
**     out->write( exc_auth->get_text( ) ).
*      CATCH zcx_107_failed  INTO DATA(exc_fail).
*
*        out->write(  exc_fail->get_text( ) ).
*
*    ENDTRY.

  ENDMETHOD.

ENDCLASS.
