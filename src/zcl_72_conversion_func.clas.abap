CLASS zcl_72_conversion_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_72_conversion_func IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT FROM /dmo/travel
           FIELDS lastchangedat,
                  CAST( lastchangedat AS DEC( 15,0 ) ) AS latstchangedat_short,

                  tstmp_to_dats( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
                                 tzone = CAST( 'EST' AS CHAR( 6 ) )
                               ) AS date_est,
                  tstmp_to_tims( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
                                 tzone = CAST( 'EST' AS CHAR( 6 ) )
                               ) AS time_est

            WHERE customer_id = '000001'
             INTO TABLE @DATA(result_date_time).

    out->write(
      EXPORTING
        data   = result_date_time
        name   = 'RESULT_DATE_TIME'
    ).

*********************************************************************
    DATA lr_cx TYPE REF TO cx_root.

    DATA(today) = cl_abap_context_info=>get_system_date(  ).

    TRY.

        SELECT FROM /dmo/travel
             FIELDS total_price,
                    currency_code,

                    currency_conversion( amount             = total_price,
                                         source_currency    = currency_code,
                                         target_currency    = 'EUR',
                                         exchange_rate_date = @today
                                       ) AS total_price_EUR

              WHERE customer_id = '00000017' AND currency_code <> 'EUR'
               INTO TABLE @DATA(result_currency).

    out->write(
      EXPORTING
        data   = result_currency
        name   = 'RESULT__CURRENCY'
    ).

      CATCH cx_sy_open_sql_db INTO lr_cx.

      out->write( `Error: No data`  ).

    ENDTRY.

**********************************************************************

    SELECT FROM /dmo/connection
         FIELDS distance,
                distance_unit,
                unit_conversion( quantity = CAST( distance AS QUAN ),
                                 source_unit = distance_unit,
                                 target_unit = CAST( 'MI' AS UNIT ) )  AS distance_MI

          WHERE airport_from_id = 'FRA'
           INTO TABLE @DATA(result_unit).

    out->write(
      EXPORTING
        data   = result_unit
        name   = 'RESULT_UNIT'
    ).

  ENDMETHOD.

ENDCLASS.
