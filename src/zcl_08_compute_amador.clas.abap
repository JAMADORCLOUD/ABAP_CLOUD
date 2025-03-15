CLASS zcl_08_compute_amador DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_08_COMPUTE_AMADOR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA number1 TYPE i.
    DATA number2 TYPE i.

    DATA result TYPE p LENGTH 8 DECIMALS 2.

    number1 = -8.
    number2 =  3.


*    DATA(result) = number1 / number2. " same -> DATA result TYPE i.

    result = number1 / number2.

    DATA(output) = |{ number1 } / { number2 } = { result }|.

    out->write( output ).

  ENDMETHOD.
ENDCLASS.
