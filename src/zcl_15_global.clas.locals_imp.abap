*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_connection DEFINITION. "create private.

  PUBLIC SECTION.

    DATA carrier_id       TYPE /dmo/carrier_id.   "S_CARR_ID
    DATA connection_id    TYPE /dmo/connection_id. "S_CONN_ID

    CLASS-DATA conn_counter   TYPE i.

* Definition Class
    METHODS set_attributes      "Ctrl + 1 for Implementation Several Methods
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id OPTIONAL
        i_connection_id TYPE /dmo/connection_id.


    METHODS get_attributes
      IMPORTING
        e_carrier_id    TYPE /dmo/carrier_id OPTIONAL
        e_connection_id TYPE /dmo/connection_id.

  PROTECTED SECTION.
  PRIVATE SECTION.

  ENDCLASS.

  CLASS lcl_connection IMPLEMENTATION.

  METHOD set_attributes.

        carrier_id = i_carrier_id.
        connection_id = i_connection_id.

  ENDMETHOD.

* Implementation Class
  METHOD get_attributes.

        carrier_id = e_carrier_id.
        connection_id = e_connection_id.

  ENDMETHOD.

ENDCLASS.
