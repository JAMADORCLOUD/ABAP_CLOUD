CLASS zcl_37_eml_example DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_37_eml_example IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA update_tab TYPE TABLE FOR UPDATE /DMO/R_AgencyTP.
    update_tab = VALUE #( ( agencyID = '070002' Name = 'MODIFIED Agency' ) ). "  CVC Brasil

    MODIFY ENTITIES OF /DMO/R_AgencyTP
    ENTITY /DMO/agency
    UPDATE FIELDS ( name )
    WITH update_tab.

    COMMIT ENTITIES.

  ENDMETHOD.

ENDCLASS.
