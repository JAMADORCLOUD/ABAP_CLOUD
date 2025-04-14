CLASS zcl_91_authorization DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_91_authorization IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA airports TYPE STANDARD TABLE OF /dmo/airport
                  WITH NON-UNIQUE KEY airport_id.

*    AUTHORITY-CHECK OBJECT '/DMO/TRVL'
*    ID 'CNTRY' FIELD 'DE'
*    ID 'ACTVT' FIELD '03'.

*    IF sy-subrc EQ 0.

      SELECT FROM /dmo/airport
          FIELDS *
          WHERE country = 'US'
          INTO TABLE @airports.

      out->write( airports ).

*  ELSE.

*    out->write( 'No Authorization' ).

*  ENDIF.

  ENDMETHOD.

ENDCLASS.
