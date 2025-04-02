CLASS zcl_58_des_functions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_58_des_functions IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA result TYPE i.

    DATA text    TYPE string VALUE `  ABAP  `.
    DATA substring TYPE string VALUE `AB`.
    DATA offset    TYPE i      VALUE 1.

* Call different description functions
******************************************************************************
*    result = strlen(     text ).
*    result = numofchar(  text ).

*    result = count(             val = text sub = substring off = offset ).
*    result = find(             val = text sub = substring off = offset ).

*    result = count_any_of(     val = text sub = substring off = offset ).
*    result = find_any_of(      val = text sub = substring off = offset ).

*    result = count_any_not_of( val = text sub = substring off = offset ).
    result = find_any_not_of(  val = text sub = substring off = offset ).

    out->write( |Text      = `{ text }`| ).
    out->write( |Substring = `{ substring }` | ).
    out->write( |Offset    = { offset } | ).
    out->write( |Result    = { result } | ).

  ENDMETHOD.

ENDCLASS.
