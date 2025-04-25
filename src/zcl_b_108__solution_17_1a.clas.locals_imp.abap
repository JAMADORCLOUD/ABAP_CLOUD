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

"! Flight Carrier -
"! A factory logic ensures that there is only one instance for the same carrier ID.
CLASS lcl_carrier DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
                i_carrier_id TYPE /dmo/carrier_id
      RAISING   zcx_107_failed.

    "! Factory method - returns an instance of this class.
    "! @parameter i_carrier_id | Three-character identification of the carrier.
    "! @parameter r_result | Reference to the instance - initial if instantiation failed.
    "! @raising zcx_107_failed | Instantiation failed - evaluate the exception text for details.
    CLASS-METHODS get_instance
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
      RETURNING
        VALUE(r_result) TYPE REF TO lcl_carrier
      RAISING
*      cx_abap_invalid_value
*      cx_abap_auth_check_exception
        zcx_107_failed.

    METHODS get_output
      RETURNING
        VALUE(r_result) TYPE string_table.

  PRIVATE SECTION.

    DATA carrier_id TYPE /dmo/carrier_id.
    DATA name TYPE /dmo/carrier_name.
    DATA currency_code TYPE /dmo/currency_code.
    DATA name_aux    TYPE c LENGTH 20.

ENDCLASS.


CLASS lcl_Carrier IMPLEMENTATION.


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

ENDCLASS.
