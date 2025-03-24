CLASS zcl_39_apt_example DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_39_apt_example IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    INSERT INTO zta_03_p_flight VALUES @( VALUE #( client = '100'
**                                              uuid = 1
                                              carrier_id = 'SQ'
                                              connection_id = '0012'
                                              flight_date = cl_abap_context_info=>get_system_date( )
                                              timzone = sy-zonlo ) ).
*                                              flight_date = sy-datum ) ).
*                                              airport_from = 'MTY'
*                                              city_from = 'Monterrey'
*                                              country_from = 'MEX'
*                                              airport_to = 'TX'
*                                              city_to = 'Seguin'
*                                              country_to = 'USA' ) ).
*                                              local_created_by = 'JAMADORV'
*                                              local_created_at = '20250228125037' " YYYYDDMMHHMMSS format
*                                              local_last_changed_by = 'JAVALDEZ'
*                                              local_last_changed_at = '20252802135037'
*                                              last_changed_at = '20252802135037' ) ).

*    DELETE zta_01_cxn FROM @( VALUE #( uuid = 13 ) ).
*    DELETE FROM ZTA_03_P_flight.

    out->write(  sy-dbcnt ).

  ENDMETHOD.

ENDCLASS.
