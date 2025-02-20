CLASS zcl_19_fun_met_fibonacci DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS ZCL_19_FUN_MET_FIBONACCI IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

DATA fibonacci  TYPE REF TO lcl_fibonacci.

* Create Instance
**********************************************************************

    fibonacci = NEW #(  ).

      out->write( data = fibonacci->get_fibonacci( 10 ) " 50 - 100 Error CX_SY_ARITHMETIC_OVERFLOW
                  name = 'Resultado Fibonacci' ).

  ENDMETHOD.

ENDCLASS.
