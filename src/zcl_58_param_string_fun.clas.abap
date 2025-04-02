CLASS zcl_58_param_string_fun DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_58_param_string_fun IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA text   TYPE string VALUE `Let's talk about ABAP`.
    DATA result TYPE i.

    out->write(  text ).

    result = find( val = text sub = 'A' ).
*
*    result = find( val = text sub = 'A' case = abap_false ).
*
*    result = find( val = text sub = 'A' case = abap_false occ =  -1 ).
*    result = find( val = text sub = 'A' case = abap_false occ =  -2 ).
*    result = find( val = text sub = 'A' case = abap_false occ =   2 ).
*
*    result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 ).
*    result = find( val = text sub = 'A' case = abap_false occ = 2 off = 10 len = 4 ).

    out->write( |RESULT = { result } | ).

*    DATA result_int TYPE i.
*    DATA text_2   TYPE string VALUE `test env `.

*    result_int = numofchar( text_2 ).
*    result_int = strlen( text_2 ).
*    result_int = find( val = text_2 sub = 'env' ).
*    out->write( text_2 ).

*    out->write( |RESULT = { result_int } | ).

*    DATA result_string TYPE string.

*    result_string = replace( val = text_2 sub = 'env' with = 'Env' ).
*    out->write( |RESULT = { result_string } | ).

*    IF contains( val = text_2 sub = 'env' ).
*      CLEAR text_2.
*    ENDIF.

  ENDMETHOD.

ENDCLASS.
