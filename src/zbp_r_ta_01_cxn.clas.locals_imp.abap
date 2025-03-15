CLASS lhc_zr_ta_01_cxn DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR cnx
        RESULT result,
      CheckSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR cnx~CheckSemanticKey,
      GetCities FOR DETERMINE ON SAVE
            IMPORTING keys FOR cnx~GetCities,
      validatePrice FOR VALIDATE ON SAVE
            IMPORTING keys FOR cnx~validatePrice,
      validateCurrencyCode FOR VALIDATE ON SAVE
            IMPORTING keys FOR cnx~validateCurrencyCode.
ENDCLASS.

CLASS lhc_zr_ta_01_cxn IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD CheckSemanticKey.

*    DATA read_keys   TYPE TABLE FOR READ IMPORT zr_ta_01_cxn.
*    DATA cnxs        TYPE TABLE FOR READ RESULT zr_ta_01_cxn.

*    read_keys = CORRESPONDING #( keys ).

    DATA reported_record LIKE LINE OF reported-cnx.
    DATA failed_record LIKE LINE OF failed-cnx.
    DATA lo_message TYPE REF TO if_abap_behv_message.

    READ ENTITIES OF zr_ta_01_cxn IN LOCAL MODE
    ENTITY cnx FIELDS ( uuid carrid connid airportfrom airportto )
    WITH CORRESPONDING #( keys )
*    WITH read_keys
    RESULT DATA(cnxs).

    LOOP AT cnxs INTO DATA(cnx).

      SELECT FROM zta_01_cxn
      FIELDS uuid
      WHERE carrid = @cnx-carrid
        AND connid = @cnx-connid
        AND uuid <> @cnx-uuid
      UNION
      SELECT FROM zta_01_cxn_d
      FIELDS uuid
      WHERE carrid = @cnx-carrid
        AND connid = @cnx-connid
        AND uuid <> @cnx-uuid
      INTO TABLE @DATA(check_result).

      IF check_result IS NOT INITIAL.

*        DATA(message) = me->new_message(
        lo_message = me->new_message(
        id = 'ZCL_CXN'
        number = 001
        severity = ms-error
        v1 = cnx-carrid
        v2 = cnx-connid ).

*        DATA reported_record LIKE LINE OF reported-cnx.

        reported_record-%tky = cnx-%tky.
        reported_record-%msg = lo_message.  "message
        reported_record-%element-carrid = if_abap_behv=>mk-on.
        reported_record-%element-connid = if_abap_behv=>mk-on.
        APPEND reported_record TO reported-cnx.

*        DATA failed_record LIKE LINE OF failed-cnx.

        failed_record-%tky = cnx-%tky.
        APPEND failed_record TO failed-cnx.

      ENDIF.

      IF cnx-airportFrom = cnx-airportTo.

*        DATA(message_3)  = me->new_message(
        lo_message = me->new_message(
        id = 'ZCL_CXN'
        number = 003
        severity = ms-error
        v1 = cnx-airportfrom
        v2 = cnx-airportto ).

*        DATA reported_record LIKE LINE OF reported-cnx.

        reported_record-%tky = cnx-%tky.
        reported_record-%msg = lo_message.  "message_3
        reported_record-%element-airportfrom = if_abap_behv=>mk-on.
        reported_record-%element-airportto = if_abap_behv=>mk-on.
        APPEND reported_record TO reported-cnx.

*        DATA failed_record LIKE LINE OF failed-cnx.

        failed_record-%tky = cnx-%tky.
        APPEND failed_record TO failed-cnx.

      ENDIF.

      SELECT SINGLE
               FROM /dmo/i_carrier
             FIELDS @abap_true
              WHERE airlineid = @cnx-carrid
               INTO @DATA(exists).

      IF exists <> abap_true.

*        DATA(message_2)  = me->new_message(
        lo_message = me->new_message(
        id = 'ZCL_CXN'
        number = 002
        severity = ms-error
        v1 = cnx-carrid ).

*        DATA reported_record LIKE LINE OF reported-cnx.

        reported_record-%tky = cnx-%tky.
        reported_record-%msg = lo_message.  "message_2
        reported_record-%element-carrid = if_abap_behv=>mk-on.
        APPEND reported_record TO reported-cnx.

*        DATA failed_record LIKE LINE OF failed-cnx.

        failed_record-%tky = cnx-%tky.
        APPEND failed_record TO failed-cnx.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD GetCities.

    DATA read_data TYPE TABLE FOR READ RESULT zr_ta_01_cxn.

    READ ENTITIES OF zr_ta_01_cxn IN LOCAL MODE
    ENTITY cnx
    FIELDS ( airportfrom airportto )
    WITH CORRESPONDING #( keys )
    RESULT read_data.

    LOOP AT read_data INTO DATA(cnx).

      SELECT SINGLE
               FROM /dmo/i_airport
             FIELDS city, countrycode
              WHERE airportid = @cnx-airportfrom
               INTO ( @cnx-cityfrom, @cnx-countryfrom ).

      IF sy-subrc NE 0.

        CLEAR: cnx-cityfrom,
               cnx-countryfrom.

      ENDIF.

      SELECT SINGLE
               FROM /dmo/i_airport
             FIELDS city, countrycode
              WHERE airportid = @cnx-airportto
               INTO ( @cnx-cityto, @cnx-countryto ).

      IF sy-subrc NE 0.

        CLEAR: cnx-cityto,
               cnx-countryto.

      ENDIF.

      MODIFY read_data FROM cnx.

    ENDLOOP.

    DATA update_data TYPE TABLE FOR UPDATE zr_ta_01_cxn.
    update_data = CORRESPONDING #( read_data ).

    MODIFY ENTITIES OF zr_ta_01_cxn IN LOCAL MODE
        ENTITY cnx
        UPDATE FIELDS (
          cityfrom
          countryfrom
          cityto
          countryto
        )
        WITH update_data
        REPORTED DATA(reported_records).

    " These records must be returned to the reported variable
    " to notify the user that data has been changed.
    reported-cnx = CORRESPONDING #( reported_records-cnx ).

  ENDMETHOD.

  METHOD validatePrice.

    DATA failed_record   LIKE LINE OF failed-cnx.
    DATA reported_record LIKE LINE OF reported-cnx.

    READ ENTITIES OF zr_ta_01_cxn IN LOCAL MODE
          ENTITY cnx
          FIELDS ( price )
            WITH CORRESPONDING #(  keys )
          RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).

      IF flight-price <= 0.

        DATA(message_p)  = me->new_message(
        id = 'ZCL_CXN'
        number = 004
        severity = ms-error
        v1 = flight-carrid ).

        reported_record-%tky = flight-%tky.
        reported_record-%msg = message_p.
        reported_record-%element-price = if_abap_behv=>mk-on.
        APPEND reported_record TO reported-cnx.

        failed_record-%tky = flight-%tky.
        APPEND failed_record TO failed-cnx.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateCurrencyCode.

    DATA failed_record   LIKE LINE OF failed-cnx.
    DATA reported_record LIKE LINE OF reported-cnx.
    DATA exists TYPE abap_bool.


    READ ENTITIES OF zr_ta_01_cxn IN LOCAL MODE
          ENTITY cnx
          FIELDS ( currencycode )
            WITH CORRESPONDING #(  keys )
          RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).

      exists = abap_false.

      SELECT SINGLE FROM i_currency
            FIELDS @abap_true
            WHERE currency = @flight-currencycode
            INTO @exists.

      IF  exists = abap_false. " The Currency Code is not valid

        reported_record-%tky = flight-%tky.
        reported_record-%msg = new_message(
                                id       = 'ZCL_CXN'
                                number   = 005
                                severity = if_abap_behv_message=>severity-error
                                v1       = flight-currencycode ).

        reported_record-%element-price = if_abap_behv=>mk-on.
        APPEND reported_record TO reported-cnx.

        failed_record-%tky = flight-%tky.
        APPEND failed_record TO failed-cnx.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
