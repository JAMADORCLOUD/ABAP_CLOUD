*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

*CLASS lcl_carrier DEFINITION
CLASS lcl_carrier DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        i_carrier_id TYPE /dmo/carrier_id.

    CLASS-METHODS get_instance
      IMPORTING
                i_carrier_id    TYPE /dmo/carrier_id
      RETURNING
                VALUE(r_result) TYPE REF TO lcl_carrier
      RAISING   cx_abap_invalid_value
                cx_abap_auth_check_exception.

  PRIVATE SECTION.

    TYPES: tt_carriers TYPE STANDARD TABLE OF REF TO lcl_carrier
                      WITH DEFAULT KEY.

    CLASS-DATA instances TYPE tt_carriers.

    DATA carrier_id TYPE /dmo/carrier_id.
    DATA name TYPE /dmo/carrier_name.
    DATA currency_code TYPE /dmo/currency_code.

ENDCLASS.


CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.

    me->carrier_id = i_carrier_id.

  ENDMETHOD.


  METHOD get_instance.

    DATA name TYPE /dmo/carrier_name.
    DATA currency_code TYPE /dmo/currency_code.

    SELECT SINGLE
     FROM /dmo/carrier
*   FIELDS concat_with_space( carrier_id, name, 1 ), currency_code
   FIELDS concat_with_space( carrier_id, name, 1 ) AS name,
    currency_code
    WHERE carrier_id = @i_carrier_id
*    INTO ( @name, @currency_code ).
    INTO @DATA(details).


    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value
      EXPORTING
       value = CONV #( i_carrier_id ).
    ENDIF.

    AUTHORITY-CHECK
           OBJECT '/LRN/CARR'
               ID '/LRN/CARR' FIELD i_carrier_id
               ID 'ACTVT'     FIELD '03'.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE cx_abap_auth_check_exception
      EXPORTING
      textid = cx_abap_auth_check_exception=>missing_authorization.
    ENDIF.

*    TRY.
*
*        r_result = instances[ table_line->carrier_id = i_carrier_id  ].
*
*      CATCH cx_sy_itab_line_not_found.
*
*        r_result = NEW #( i_carrier_id = i_carrier_id ).
*
*        r_result->name          = details-name.
*        r_result->currency_code = details-currency_code.
*
*        APPEND r_result TO instances.
*
*    ENDTRY.


  ENDMETHOD.

ENDCLASS.
