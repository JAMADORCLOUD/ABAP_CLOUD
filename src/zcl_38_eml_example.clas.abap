CLASS zcl_38_eml_example DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_38_eml_example IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


    DATA agencies_upd TYPE TABLE FOR UPDATE /DMO/I_AgencyTP.

    agencies_upd = VALUE #( ( agencyid = '070049' name = 'Jesus Amador Valdez' ) ).

    MODIFY ENTITIES OF /DMO/I_AgencyTP
    ENTITY /DMO/agency
    UPDATE FIELDS ( name )
    WITH agencies_upd.

    COMMIT ENTITIES.

    out->write( `Method execution finished!`  ).

  ENDMETHOD.

ENDCLASS.
