CLASS zcl_49_trun_round DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_49_trun_round IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA long_char TYPE c LENGTH 10.
    DATA short_char TYPE c LENGTH 5.

    DATA result TYPE p LENGTH 3 DECIMALS 2.

    long_char = 'ABCDEFGHIJ'.
    short_char = long_char.

    out->write( long_char ).
    out->write( short_char ).

    result = 1 / 8.
    out->write( |1 / 8 is rounded to { result NUMBER = USER }| ).

  ENDMETHOD.

  ENDCLASS.
