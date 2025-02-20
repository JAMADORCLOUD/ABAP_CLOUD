*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.

    CLASS-DATA conn_counter TYPE i READ-ONLY.

** Methods
*    METHODS set_attributes
*      IMPORTING
*        i_carrier_id    TYPE /dmo/carrier_id  DEFAULT 'LH'
*        i_Connection_id TYPE /dmo/connection_id
*      RAISING
*        cx_abap_invalid_value.

    METHODS constructor
      IMPORTING
        carrier_id TYPE /dmo/carrier_id
        connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

*    METHODS get_attributes
*      EXPORTING
*        e_carrier_id    TYPE /dmo/carrier_id
*        e_connection_id TYPE /dmo/connection_id.

*  PROTECTED SECTION.

  PRIVATE SECTION.
** Attributes
    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.

  IF carrier_id IS INITIAL OR connection_id IS INITIAL.
    RAISE EXCEPTION TYPE cx_abap_invalid_value.
  ENDIF.

    me->carrier_id = carrier_id.
    me->connection_id = connection_id.

    conn_counter = conn_counter + 1.

  ENDMETHOD.

*  METHOD set_attributes.
*
*    carrier_id    = i_carrier_id.
*    connection_id = i_connection_id.
*
*  ENDMETHOD.
*
*  METHOD get_attributes.
*
*    e_carrier_id = carrier_id.
*    e_connection_id = connection_id.
*
*  ENDMETHOD.

ENDCLASS.
