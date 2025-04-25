CLASS zcl_b_106__exceptions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_b_106__exceptions IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA connection TYPE REF TO lcl_connection.
    DATA exception TYPE REF TO lcx_no_connection.

    TRY.
        connection = NEW #( i_airlineid = 'SQ' i_connectionnumber = '0001' ).
      CATCH lcx_no_connection INTO exception.
        out->write( exception->get_text( ) ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
