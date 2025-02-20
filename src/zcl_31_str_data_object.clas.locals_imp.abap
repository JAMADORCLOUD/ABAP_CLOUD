*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_connection DEFINITION.
  PUBLIC SECTION.

* Attributes

* Methods
    METHODS constructor
      IMPORTING
        i_carrier_id    TYPE /dmo/carrier_id
        i_connection_id TYPE /dmo/connection_id
      RAISING
        cx_abap_invalid_value.

    " Functional Method
    METHODS get_output
      RETURNING VALUE(r_output) TYPE string_table.

*  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA carrier_id    TYPE /dmo/carrier_id.
    DATA connection_id TYPE /dmo/connection_id.
*    DATA airport_from_id TYPE /dmo/airport_from_id.
*    DATA airport_to_id   TYPE /dmo/airport_to_id.
*    DATA carrier_name    TYPE /dmo/carrier_name.


    TYPES:
      BEGIN OF st_details,
        DepartureAirport   TYPE /dmo/airport_from_id,
        DestinationAirport TYPE /dmo/airport_to_id,
        AirlineName        TYPE /dmo/carrier_name,
      END OF st_details.

    DATA details TYPE st_details.

ENDCLASS.

CLASS lcl_connection IMPLEMENTATION.

  METHOD constructor.

    IF i_carrier_id IS INITIAL OR i_connection_id IS INITIAL.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

    carrier_id = i_carrier_id.
*    me->carrier_id = i_carrier_id.         "Same result
    connection_id = i_connection_id.
*    me->connection_id = i_connection_id.   "Same result

*    SELECT SINGLE
*          FROM /dmo/connection
*        FIELDS airport_from_id, airport_to_id
*         WHERE carrier_id    = @i_carrier_id
*           AND connection_id = @i_connection_id
*          INTO ( @airport_from_id, @airport_to_id ).

 SELECT SINGLE
       FROM /DMO/I_Connection
    FIELDS DepartureAirport, DestinationAirport, \_Airline-Name AS AirlineName
     WHERE AirlineID    = @i_carrier_id
       AND ConnectionID = @i_connection_id
*       INTO ( @airport_from_id, @airport_to_id, @carrier_name ).
*       INTO @details.
       INTO CORRESPONDING FIELDS OF @details.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_abap_invalid_value.
    ENDIF.

  ENDMETHOD.

  METHOD get_output.

*    APPEND |--------------------------------|             TO r_output.
*    APPEND |Carrier:     { carrier_id } { carrier_name }| TO r_output.
*    APPEND |Connection:  { connection_id   }|             TO r_output.
*    APPEND |Departure:   { airport_from_id }|             TO r_output.
*    APPEND |Destination: { airport_to_id   }|             TO r_output.

    APPEND |--------------------------------|                    TO r_output.
    APPEND |Carrier:     { carrier_id } { details-airlinename }| TO r_output.
    APPEND |Connection:  { connection_id   }|                    TO r_output.
    APPEND |Departure:   { details-departureairport     }|       TO r_output.
    APPEND |Destination: { details-destinationairport   }|       TO r_output.

  ENDMETHOD.

ENDCLASS.
