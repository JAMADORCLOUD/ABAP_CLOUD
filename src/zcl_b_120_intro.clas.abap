CLASS zcl_b_120_intro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_b_120_intro IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA var TYPE string.

    SELECT FROM zta_01_cxn
           FIELDS *
             INTO TABLE @DATA(result).

  ENDMETHOD.

ENDCLASS.
