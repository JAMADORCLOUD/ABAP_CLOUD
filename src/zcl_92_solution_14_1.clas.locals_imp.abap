*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_airport DEFINITION.

  PUBLIC SECTION.

    DATA: lv_name TYPE /dmo/airport_name,
          lv_city TYPE /dmo/city.

* Methods
    METHODS constructor
      IMPORTING
        i_airport_id TYPE /dmo/airport_id
      RAISING
        cx_abap_invalid_value
        cx_abap_auth_check_exception.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_airport IMPLEMENTATION.

  METHOD constructor.

    SELECT SINGLE
*      FROM /dmo/airport
      FROM zcds_01_airports
    FIELDS name, city
*      WHERE airport_id = @i_airport_id
     WHERE AirportID = @i_airport_id
      INTO ( @me->lv_name, @me->lv_city ).

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    AUTHORITY-CHECK OBJECT '/DMO/TRVL'
    ID 'CNTRY' FIELD 'DE'
    ID 'ACTVT' FIELD '03'.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_auth_check_exception.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
