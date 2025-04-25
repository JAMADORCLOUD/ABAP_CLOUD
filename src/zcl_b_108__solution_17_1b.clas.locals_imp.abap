*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS zcx_107_failed DEFINITION INHERITING FROM cx_static_Check.

  PUBLIC SECTION.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg .

    METHODS constructor
      IMPORTING
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   LIKE previous OPTIONAL
        carrier_id TYPE /dmo/carrier_id OPTIONAL.

    CONSTANTS:
      BEGIN OF carrier_not_exist,
        msgid TYPE symsgid VALUE 'ZCL_03_00_MESSAGES',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'CARRIER_ID',
        attr2 TYPE scx_attrname VALUE 'attr2',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF carrier_not_exist.

    CONSTANTS:
      BEGIN OF carrier_no_read_auth,
        msgid TYPE symsgid      VALUE 'ZCL_03_00_MESSAGES',
        msgno TYPE symsgno      VALUE '020',
        attr1 TYPE scx_attrname VALUE 'CARRIER_ID',
        attr2 TYPE scx_attrname VALUE 'attr2',
        attr3 TYPE scx_attrname VALUE 'attr3',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF carrier_no_read_auth.

    DATA carrier_id TYPE /dmo/carrier_id READ-ONLY.

ENDCLASS.

CLASS zcx_107_failed IMPLEMENTATION.

  METHOD constructor.

    super->constructor( previous = previous ).

    CLEAR me->textid.

    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
*      if_t100_message~t100key = carrier_not_exist.
*      if_t100_message~t100key = carrier_no_read_auth.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    IF carrier_id IS NOT INITIAL.
      me->carrier_id = carrier_id.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

"! Abstract superclass for classes
"! {@link .lcl_passenger_flight} and
"! {@link .lcl_cargo_flight}. <br/>
"! Every instance is uniquely identified by attributes
"! {@link .lcl_flight.DATA:carrier_id },
"! {@link .lcl_flight.DATA:connection_id }, and
"! {@link .lcl_flight.DATA:flight_date }.
CLASS lcl_flight DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
                i_carrier_id    TYPE /dmo/carrier_id
                i_connection_id TYPE /dmo/connection_id
                i_flight_date   TYPE /dmo/flight_date
      RAISING   zcx_107_failed.

    "! Factory method - returns an instance of this class.
    "! @parameter i_carrier_id | Three-character identification of the carrier.
    "! @parameter r_result | Reference to the instance - initial if instantiation failed.
    "! @raising zcx_107_failed | Instantiation failed - evaluate the exception text for details.
    CLASS-METHODS get_instance
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_flight
      RAISING
*      cx_abap_invalid_value
*      cx_abap_auth_check_exception
        zcx_107_failed.

    "! Search for a <strong>passenger flight</strong> between two airports that
    "! <ul>
    "! <li>lies on or after a given date and</li>
    "! <li>has a minimum number of available seats left</li>
    "!</ul>
    "! @parameter i_airport_from_id | <em>Departure</em> airport
    "! @parameter i_airport_to_id | <em>Arrival</em> airport
    "! @parameter i_from_date | First possible flight date
    "! @parameter i_seats | Minimum number of available seats
    "! @parameter e_flight | Found flight (object reference)
    "! @parameter e_days_later | Number of days after the requested date
    CLASS-METHODS find_passenger_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id
        i_from_date       TYPE /dmo/flight_date
        i_seats           TYPE /dmo/plane_seats_max
      EXPORTING
        e_flight          TYPE /dmo/carrier_id
        e_days_later      TYPE i.

    "! Search for a <strong>cargo flight</strong> between two airports that
    "! <ul>
    "! <li>lies on or after a given date and</li>
    "! <li>has a minimum number of available capacity left</li>
    "!</ul>
    "! @parameter i_airport_from_id | <em>Departure</em> airport
    "! @parameter i_airport_to_id | <em>Arrival</em> airport
    "! @parameter i_from_date | First possible flight date
    "! @parameter i_cargo | Minimum number of available capacity
    "! @parameter e_flight | Found flight (object reference)
    "! @parameter e_days_later | Number of days after the requested date
    CLASS-METHODS find_cargo_flight
      IMPORTING
        i_airport_from_id TYPE /dmo/airport_from_id
        i_airport_to_id   TYPE /dmo/airport_to_id
        i_from_date       TYPE /dmo/flight_date
        i_cargo           TYPE i
      EXPORTING
        e_flight          TYPE /dmo/carrier_id
        e_days_later      TYPE i.

    METHODS get_output
      RETURNING
        VALUE(r_result) TYPE string_table.

  PRIVATE SECTION.

    DATA carrier_id TYPE /dmo/carrier_id.
    DATA name TYPE /dmo/carrier_name.
    DATA currency_code TYPE /dmo/currency_code.
    DATA name_aux    TYPE c LENGTH 20.

ENDCLASS.


CLASS lcl_flight IMPLEMENTATION.

  METHOD constructor.

    DATA name TYPE /dmo/carrier_name.
    DATA currency_code TYPE /dmo/currency_code.


    SELECT SINGLE FROM /dmo/carrier
    FIELDS name, currency_code
    WHERE carrier_id = @i_carrier_id
    INTO ( @name, @currency_code ).


    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE zcx_107_failed
        EXPORTING
          textid     = zcx_107_failed=>carrier_not_exist
*         previous   =
          carrier_id = i_carrier_id.

    ELSE.

      AUTHORITY-CHECK OBJECT '/DMO/TRVL'
      ID 'CNTRY' FIELD 'DE'
      ID 'ACTVT' FIELD '03'.

      IF sy-subrc EQ 0.

        RAISE EXCEPTION TYPE zcx_107_failed
          EXPORTING
            textid     = zcx_107_failed=>carrier_no_read_auth
*           previous   =
            carrier_id = i_carrier_id.

      ENDIF.

      me->name = name.
      me->currency_code = currency_code.

    ENDIF.
  ENDMETHOD.

  METHOD get_instance.

    IF sy-subrc EQ 1.

      RAISE EXCEPTION TYPE zcx_107_failed
        EXPORTING
          textid     = zcx_107_failed=>carrier_not_exist
*         previous   =
          carrier_id = i_carrier_id.

    ELSEIF sy-subrc EQ 4.

      RAISE EXCEPTION TYPE zcx_107_failed
        EXPORTING
          textid     = zcx_107_failed=>carrier_no_read_auth
*         previous   =
          carrier_id = i_carrier_id.

    ELSE.

    ENDIF.

  ENDMETHOD.

  METHOD get_output.

    name_aux = 'JESUS_A.VALDEZ'.

    APPEND |{ 'Carrier Name:'(001)       } { name_aux } | TO r_result.

  ENDMETHOD.

  METHOD find_passenger_flight.

  ENDMETHOD.

  METHOD find_cargo_flight.

  ENDMETHOD.

ENDCLASS.
