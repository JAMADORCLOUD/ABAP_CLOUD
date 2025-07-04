CLASS zcl_b_109_cond_operator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_b_109_cond_operator IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: age     TYPE i VALUE 5,
          message TYPE string.

    message = COND string( WHEN age < 18 THEN 'Minor'
                           WHEN age >= 18 AND age < 65 THEN 'Adult'
                           ELSE 'Senior' ).

    out->write( message ).


  ENDMETHOD.

ENDCLASS.
