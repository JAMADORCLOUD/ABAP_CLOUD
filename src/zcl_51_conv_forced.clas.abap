CLASS zcl_51_conv_forced DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_51_conv_forced IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: var    type c LENGTH 10,
          v_date TYPE d.

* result has type C.
* and is displayed unformatted in the console

    DATA(result1) = '20230101'.
    out->write( result1 ).

* result2 is forced to have type D
* and is displayed with date formatting in the console

    DATA(result2) = CONV d( '20230101' ).
    out->write( result2 ).

    v_date = '20230101'.
    out->write( v_date ).

* The method do_something( ) has an importing parameter of type string.
* Attempting to pass var results in a syntax error
* The CONV #( ) expression converts var into the expected type
* Note that CONV #( ) can lead to conversion exceptions

    var = 'JESUS_VALD'.

*   lcl_class=>do_something( var ). "1
    lcl_class=>do_something( i_string = CONV #( var ) ). "2

  ENDMETHOD.

ENDCLASS.
