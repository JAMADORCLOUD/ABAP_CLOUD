CLASS zcl_01_hello_amador DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_01_hello_amador IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Add Comment   CTRL + <
* Add Uncomment CTRL + SHIFT + >
* CTRL + F3 for Activate
* F9 Execute Console

*  out->write( 'Hello World' ).
  out->write( 'Hello World Again' ).

  ENDMETHOD.
ENDCLASS.
